extends Node2D

## Менеджер живого поселения: управляет перемещением жителей, зданиями и диалогами

@onready var dialogue_panel: PanelContainer = $HUD/DialogueModal
@onready var dialogue_title: Label = $HUD/DialogueModal/VBox/Title
@onready var dialogue_text: RichTextLabel = $HUD/DialogueModal/VBox/Text
@onready var dialogue_options_box: VBoxContainer = $HUD/DialogueModal/VBox/OptionsContainer

@onready var hud_time_label: Label = $HUD/TopBar/TimeLabel
@onready var hud_player_info: RichTextLabel = $HUD/BottomBar/PlayerCard/Info
@onready var hud_log: RichTextLabel = $HUD/BottomBar/LogCard/LogText
@onready var role_select: OptionButton = $HUD/BottomBar/PlayerCard/RoleOption
@onready var change_role_btn: Button = $HUD/BottomBar/PlayerCard/ChangeRoleBtn

var active_dialogue_npc: VisualCitizen = null

# Точки интереса в поселении (Vector2)
var locations = {
	"farm": Vector2(250, 480),
	"windmill": Vector2(180, 220),
	"bakery": Vector2(500, 220),
	"tavern": Vector2(720, 280),
	"market": Vector2(520, 450),
	"castle": Vector2(900, 180),
	"bandit_camp": Vector2(1050, 560),
	"guard_post": Vector2(680, 450)
}

func _ready() -> void:
	_setup_hud()
	_spawn_all_citizens()
	_connect_events()
	dialogue_panel.visible = false

func _setup_hud() -> void:
	role_select.clear()
	for r in HierarchyManager.ROLES.keys():
		role_select.add_item(r)
	
	change_role_btn.pressed.connect(_on_change_role_clicked)
	$HUD/TopBar/Speed1x.pressed.connect(func(): TimeManager.set_speed(1.0))
	$HUD/TopBar/Speed2x.pressed.connect(func(): TimeManager.set_speed(2.0))
	$HUD/TopBar/Speed5x.pressed.connect(func(): TimeManager.set_speed(5.0))
	$HUD/TopBar/PauseBtn.pressed.connect(func(): TimeManager.set_speed(0.0))

func _connect_events() -> void:
	EventBus.hour_passed.connect(func(_h, _d): _update_all_npc_targets())
	EventBus.transaction_completed.connect(func(_b, _s, item, count, price): 
		_log("[color=gold]Сделка на рынке:[/color] %d шт. %s за %.1f зол." % [count, item, price])
	)
	EventBus.character_role_changed.connect(func(_c, old_r, new_r):
		_log("[color=cyan]Смена роли в мире:[/color] %s ➔ %s" % [old_r, new_r])
	)

func _process(_delta: float) -> void:
	if TimeManager:
		hud_time_label.text = "🕒 %s | %s" % [TimeManager.get_formatted_time(), TimeManager.get_formatted_date()]
	_update_player_hud()
	_update_all_npc_targets()

func _spawn_all_citizens() -> void:
	var initial_roster = [
		{"name": "Джайлс", "role": "Крестьянин", "gold": 12, "pos": locations["farm"], "traits": ["Честный"]},
		{"name": "Аларик", "role": "Торговец", "gold": 110, "pos": locations["market"], "traits": ["Жадный"]},
		{"name": "Роланд", "role": "Стражник", "gold": 30, "pos": locations["guard_post"], "traits": ["Храбрый"]},
		{"name": "Каэль «Терновник»", "role": "Бандит", "gold": 25, "pos": locations["bandit_camp"], "traits": ["Жестокий", "Амбициозный"]},
		{"name": "Бран Пекарь", "role": "Ремесленник", "gold": 45, "pos": locations["bakery"], "traits": ["Честный"]},
		{"name": "Барон Вильгельм", "role": "Лорд", "gold": 500, "pos": locations["castle"], "traits": ["Амбициозный"]}
	]
	
	for cit in initial_roster:
		var c_data = CharacterData.new()
		c_data.character_name = cit["name"]
		c_data.current_role = cit["role"]
		c_data.gold = cit["gold"]
		c_data.traits.assign(cit["traits"])
		
		var node = VisualCitizen.new()
		node.name = "Citizen_" + cit["name"]
		node.data = c_data
		node.global_position = cit["pos"]
		
		var needs = NeedsComponent.new()
		needs.name = "NeedsComponent"
		node.add_child(needs)
		
		var memory = MemoryComponent.new()
		memory.name = "MemoryComponent"
		node.add_child(memory)
		
		var brain = UtilityBrain.new()
		brain.name = "UtilityBrain"
		node.add_child(brain)
		
		$CitizensLayer.add_child(node)

func _update_all_npc_targets() -> void:
	for child in $CitizensLayer.get_children():
		if child is VisualCitizen:
			var brain: UtilityBrain = child.get_node_or_null("UtilityBrain")
			if not brain:
				continue
			
			match brain.current_action:
				"EAT", "VISIT_TAVERN":
					child.set_world_destination(locations["tavern"] + Vector2(randf_range(-30, 30), randf_range(-30, 30)))
				"FARM_WORK":
					child.set_world_destination(locations["farm"] + Vector2(randf_range(-40, 40), randf_range(-40, 40)))
				"TRADE_MARKET":
					child.set_world_destination(locations["market"] + Vector2(randf_range(-25, 25), randf_range(-25, 25)))
				"PATROL_CITY":
					# Стражник патрулирует между замком и рынком
					var t = locations["guard_post"] if randf() > 0.5 else locations["market"]
					child.set_world_destination(t + Vector2(randf_range(-30, 30), randf_range(-30, 30)))
				"HUNT_OR_AMBUSH", "STEAL_RESOURCE":
					child.set_world_destination(locations["bandit_camp"] + Vector2(randf_range(-30, 30), randf_range(-30, 30)))
				"HOLD_COURT":
					child.set_world_destination(locations["castle"])

func open_dialogue_with_npc(npc: VisualCitizen) -> void:
	active_dialogue_npc = npc
	var p = GameManager.player_data
	var dlg = DynamicDialogueManager.generate_dialogue(npc, p)
	
	dialogue_title.text = "Разговор: %s" % npc.data.get_full_display_name()
	dialogue_text.text = dlg["greeting"]
	
	for c in dialogue_options_box.get_children():
		c.queue_free()
	
	for opt in dlg["options"]:
		var btn = Button.new()
		btn.text = opt["text"]
		var action_code = opt["action"]
		btn.pressed.connect(func(): _handle_dialogue_action(action_code))
		dialogue_options_box.add_child(btn)
	
	dialogue_panel.visible = true

func _handle_dialogue_action(action: String) -> void:
	var p = GameManager.player_data
	var npc = active_dialogue_npc
	
	match action:
		"give_bread":
			if p.remove_item("bread", 1):
				npc.needs.eat(40.0)
				npc.memory.modify_opinion("player", 25.0, "Поделился хлебом в голод")
				p.honor += 5
				_log("[color=green]%s благодарит вас со слезами на глазах за хлеб![/color]" % npc.data.character_name)
		"rob_npc":
			var stolen = randi_range(5, 20)
			npc.data.gold = max(0, npc.data.gold - stolen)
			p.gold += stolen
			p.honor -= 20
			npc.memory.add_grudge("player", "Ограбление на дороге", 3)
			_log("[color=red]Вы ограбили %s на %d зол.! Он затаил на вас кровную обиду.[/color]" % [npc.data.character_name, stolen])
		"pay_weregild":
			if p.gold >= 10:
				p.gold -= 10
				npc.data.gold += 10
				npc.memory.modify_opinion("player", 30.0, "Выплатил вергельд")
				_log("Вы выплатили 10 золотых компенсации. Отношения улажены.")
		"open_trade":
			if GameManager.local_market.buy_from_market(p, "bread", 1):
				_log("Вы купили хлеб у торговца.")
		"bribe_guard":
			if p.gold >= 15:
				p.gold -= 15
				p.honor -= 5
				_log("Стражник взял кошель и закрыл глаза на ваши грехи.")
		"swear_fealty":
			HierarchyManager.change_role(p, "Лорд")
			_log("[color=gold]Барон принял вашу присягу! Вы получили рыцарский титул и земли![/color]")
		"ask_gossip":
			var gossips = [
				"«Говорят, в Вольных Топях шайка Каэля снова ограбила купеческий обоз...»",
				"«Мельник жалуется, что зерно подорожало вдвое из-за засухи на востоке.»",
				"«Канцлер Ване тайно собирает наемников в столице. Быть беде...»"
			]
			dialogue_text.text = gossips.pick_random()
			return
		"close":
			pass
	
	dialogue_panel.visible = false

func _update_player_hud() -> void:
	var p = GameManager.player_data
	if not p:
		return
	
	var inv_str = ""
	for it in p.inventory:
		inv_str += "%s: %d, " % [it, p.inventory[it]]
	inv_str = inv_str.trim_suffix(", ") if inv_str != "" else "Пусто"
	
	hud_player_info.text = """[b]%s[/b] | Золото: [color=gold]%d[/color] | Честь: %d | Слава: %d
[b]Инвентарь:[/b] %s""" % [p.get_full_display_name(), p.gold, p.honor, p.renown, inv_str]

func _on_change_role_clicked() -> void:
	var selected_idx = role_select.selected
	var target_role = role_select.get_item_text(selected_idx)
	var p = GameManager.player_data
	
	var check = HierarchyManager.can_assume_role(p, target_role)
	if check["allowed"]:
		HierarchyManager.change_role(p, target_role)
		_log("[color=green]Вы успешно приняли новый статус: %s![/color]" % target_role)
	else:
		_log("[color=red]Не удалось сменить статус: %s[/color]" % check["reason"])

func _log(msg: String) -> void:
	var time_str = TimeManager.get_formatted_time() if TimeManager else "00:00"
	hud_log.text = "[%s] %s\n" % [time_str, msg] + hud_log.text
