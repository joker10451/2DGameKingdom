extends Control

## Интерактивная панель симуляции живого средневекового мира

@onready var time_label: Label = $VBoxContainer/TopBar/TimeLabel
@onready var speed_1x_btn: Button = $VBoxContainer/TopBar/Speed1x
@onready var speed_2x_btn: Button = $VBoxContainer/TopBar/Speed2x
@onready var speed_5x_btn: Button = $VBoxContainer/TopBar/Speed5x
@onready var pause_btn: Button = $VBoxContainer/TopBar/PauseBtn

@onready var player_info_label: RichTextLabel = $VBoxContainer/MainSplit/LeftPanel/PlayerCard/PlayerInfo
@onready var role_options: OptionButton = $VBoxContainer/MainSplit/LeftPanel/PlayerCard/RoleSelect
@onready var change_role_btn: Button = $VBoxContainer/MainSplit/LeftPanel/PlayerCard/ChangeRoleBtn
@onready var role_status_label: Label = $VBoxContainer/MainSplit/LeftPanel/PlayerCard/RoleStatusLabel

@onready var npc_container: VBoxContainer = $VBoxContainer/MainSplit/CenterPanel/NPCScroll/NPCList
@onready var market_label: RichTextLabel = $VBoxContainer/MainSplit/RightPanel/MarketCard/MarketInfo
@onready var log_box: RichTextLabel = $VBoxContainer/MainSplit/RightPanel/LogCard/LogContent

var spawn_timer: float = 0.0

func _ready() -> void:
	_setup_roles_dropdown()
	_connect_signals()
	_spawn_initial_village()
	_update_market_display()
	_update_player_ui()

func _setup_roles_dropdown() -> void:
	role_options.clear()
	for r in HierarchyManager.ROLES.keys():
		role_options.add_item(r)

func _connect_signals() -> void:
	speed_1x_btn.pressed.connect(func(): TimeManager.set_speed(1.0))
	speed_2x_btn.pressed.connect(func(): TimeManager.set_speed(2.0))
	speed_5x_btn.pressed.connect(func(): TimeManager.set_speed(5.0))
	pause_btn.pressed.connect(func(): TimeManager.set_speed(0.0))
	
	change_role_btn.pressed.connect(_on_change_role_pressed)
	
	EventBus.minute_passed.connect(_on_minute_passed)
	EventBus.hour_passed.connect(_on_hour_passed)
	EventBus.transaction_completed.connect(_on_transaction)
	EventBus.character_role_changed.connect(_on_role_changed)
	EventBus.need_critical.connect(_on_need_critical)

func _process(_delta: float) -> void:
	if TimeManager:
		time_label.text = "🕒 %s | %s" % [TimeManager.get_formatted_time(), TimeManager.get_formatted_date()]
	_update_player_ui()
	_update_npc_cards()

func _spawn_initial_village() -> void:
	var initial_citizens = [
		{"name": "Джайлс", "role": "Крестьянин", "gold": 8, "traits": ["Честный"]},
		{"name": "Аларик", "role": "Торговец", "gold": 85, "traits": ["Жадный"]},
		{"name": "Каэль", "role": "Бандит", "gold": 12, "traits": ["Жестокий", "Амбициозный"]},
		{"name": "Роланд", "role": "Стражник", "gold": 25, "traits": ["Храбрый"]},
		{"name": "Вульфрик", "role": "Ремесленник", "gold": 50, "traits": ["Честный"]},
		{"name": "Барон Вильгельм", "role": "Лорд", "gold": 400, "traits": ["Амбициозный"]}
	]
	
	for cit_info in initial_citizens:
		var c_data = CharacterData.new()
		c_data.character_name = cit_info["name"]
		c_data.current_role = cit_info["role"]
		c_data.gold = cit_info["gold"]
		c_data.traits.assign(cit_info["traits"])
		
		var node = Node2D.new()
		node.set_script(load("res://src/character/Citizen.gd"))
		node.set("data", c_data)
		
		var needs = NeedsComponent.new()
		needs.name = "NeedsComponent"
		node.add_child(needs)
		
		var memory = MemoryComponent.new()
		memory.name = "MemoryComponent"
		node.add_child(memory)
		
		var brain = UtilityBrain.new()
		brain.name = "UtilityBrain"
		node.add_child(brain)
		
		add_child(node)

func _update_player_ui() -> void:
	var p = GameManager.player_data
	if not p:
		return
	
	var inv_str = ""
	for item in p.inventory:
		inv_str += "%s: %d, " % [item, p.inventory[item]]
	if inv_str == "":
		inv_str = "Пусто"
	else:
		inv_str = inv_str.trim_suffix(", ")
	
	player_info_label.text = """[b]Имя:[/b] %s
[b]Роль:[/b] %s
[b]Золото:[/b] [color=gold]%d монет[/color]
[b]Слава (Renown):[/b] %d
[b]Честь:[/b] %d
[b]Инвентарь:[/b] %s""" % [p.get_full_display_name(), p.current_role, p.gold, p.renown, p.honor, inv_str]

func _update_npc_cards() -> void:
	# Очистка и пересоздание элементов списка NPC
	for child in npc_container.get_children():
		child.queue_free()
	
	for cit in GameManager.all_citizens:
		var data: CharacterData = cit.data
		var needs: NeedsComponent = cit.get_node_or_null("NeedsComponent")
		var brain: UtilityBrain = cit.get_node_or_null("UtilityBrain")
		
		if not data or not needs or not brain:
			continue
		
		var panel = PanelContainer.new()
		var lbl = RichTextLabel.new()
		lbl.fit_content = true
		lbl.bbcode_enabled = true
		
		var action_color = "cyan"
		if brain.current_action.contains("STEAL") or brain.current_action.contains("AMBUSH"):
			action_color = "red"
		elif brain.current_action.contains("TRADE") or brain.current_action.contains("WORK"):
			action_color = "green"
		
		lbl.text = """[b]%s[/b] | Золото: [color=gold]%d[/color] | Черты: %s
[b]Действие (AI):[/b] [color=%s]%s[/color]
Голод: %.0f/100 | Усталость: %.0f/100 | Амбиции: %.0f/100""" % [
			data.get_full_display_name(),
			data.gold,
			", ".join(data.traits),
			action_color,
			brain.current_action,
			needs.hunger,
			needs.fatigue,
			needs.ambition_drive
		]
		
		panel.add_child(lbl)
		npc_container.add_child(panel)

func _update_market_display() -> void:
	var m = GameManager.local_market
	if not m:
		return
	
	var text = "[b]Городской Рынок (Цены & Спрос):[/b]\n"
	for item in m.base_prices:
		var cur_p = m.get_current_price(item)
		var stock = m.inventory.get(item, 0)
		text += "• [b]%s[/b]: %.1f зол. (Запас: %d шт.)\n" % [item, cur_p, stock]
	
	market_label.text = text

func _on_change_role_pressed() -> void:
	var selected_idx = role_options.selected
	var target_role = role_options.get_item_text(selected_idx)
	var p = GameManager.player_data
	
	var check = HierarchyManager.can_assume_role(p, target_role)
	if check["allowed"]:
		HierarchyManager.change_role(p, target_role)
		role_status_label.text = "[color=green]Вы успешно стали: %s![/color]" % target_role
		_log_event("Игрок сменил статус и стал: %s" % target_role)
	else:
		role_status_label.text = "[color=red]%s[/color]" % check["reason"]

func _on_hour_passed(_hour: int, _day: int) -> void:
	_update_market_display()

func _on_minute_passed(_min: int, _hour: int) -> void:
	pass

func _on_transaction(_b: Node, _s: Node, item_id: String, count: int, total_price: float) -> void:
	_log_event("Сделка на рынке: %d шт. %s за %.1f зол." % [count, item_id, total_price])

func _on_role_changed(_char: Node, old_r: String, new_r: String) -> void:
	_log_event("Смена статуса: %s -> %s" % [old_r, new_r])

func _on_need_critical(char_node: Node, need_name: String, val: float) -> void:
	if "data" in char_node and char_node.data:
		_log_event("[color=orange]Внимание: %s испытывает критический %s (%.1f)![/color]" % [char_node.data.character_name, need_name, val])

func _log_event(msg: String) -> void:
	var time_str = TimeManager.get_formatted_time() if TimeManager else "00:00"
	log_box.text = "[%s] %s\n" % [time_str, msg] + log_box.text

# Действия игрока из интерфейса
func _on_work_pressed() -> void:
	var p = GameManager.player_data
	p.gold += 3
	p.add_item("grain", 1)
	p.renown += 1
	_log_event("Вы поработали в поле (+3 зол., +1 зерно)")

func _on_buy_food_pressed() -> void:
	var p = GameManager.player_data
	var m = GameManager.local_market
	if m.buy_from_market(p, "bread", 1):
		_log_event("Вы купили хлеб на рынке")
	else:
		_log_event("[color=red]Не удалось купить хлеб (не хватает золота или товара нет)[/color]")

func _on_rob_merchant_pressed() -> void:
	var p = GameManager.player_data
	if randf() > 0.4:
		var loot = randi_range(15, 40)
		p.gold += loot
		p.honor -= 15
		p.renown += 5
		_log_event("[color=red]Вы успешно ограбили караван торговца (+%d зол., -15 чести)![/color]" % loot)
	else:
		p.gold = max(0, p.gold - 10)
		p.honor -= 10
		_log_event("[color=red]Стража отбила нападение! Вы оштрафованы и ранены.[/color]")
