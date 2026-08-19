with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add Quest and Event preloads and variables
old_vars = '''const AtmosphereParticles2DScript = preload("res://src/world/AtmosphereParticles2D.gd")
var day_night_modulate: CanvasModulate
var atmosphere_particles: Node2D'''

new_vars = '''const AtmosphereParticles2DScript = preload("res://src/world/AtmosphereParticles2D.gd")
const CitizenQuestSystemScript = preload("res://src/quest/CitizenQuestSystem.gd")
const NoticeBoardSystemScript = preload("res://src/quest/NoticeBoardSystem.gd")
const WorldEventSystemScript = preload("res://src/world/WorldEventSystem.gd")

var citizen_quest_system: RefCounted
var notice_board_system: RefCounted
var world_event_system: RefCounted

var day_night_modulate: CanvasModulate
var atmosphere_particles: Node2D'''

text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate systems in _ready()
old_ready_systems = '''\t# 5.5. Атмосферные частицы (листья, светлячки, искры)
\tatmosphere_particles = AtmosphereParticles2DScript.new()
\tatmosphere_particles.name = "AtmosphereParticles"
\tadd_child(atmosphere_particles)'''

new_ready_systems = '''\t# 5.5. Атмосферные частицы (листья, светлячки, искры)
\tatmosphere_particles = AtmosphereParticles2DScript.new()
\tatmosphere_particles.name = "AtmosphereParticles"
\tadd_child(atmosphere_particles)
\t
\t# 5.6. Квесты жителей, Доска Объявлений и События
\tcitizen_quest_system = CitizenQuestSystemScript.new()
\tnotice_board_system = NoticeBoardSystemScript.new()
\tworld_event_system = WorldEventSystemScript.new()'''

text = text.replace(old_ready_systems, new_ready_systems, 1)

# 3. Add quest hooks to _open_dialogue()
old_dialogue_end = '''\t_add_dialogue_btn("«Подарить 15 золотых на цель жизни» (+35 отн., +8 чести)", func():'''

quest_dialogue_hooks = '''\t# Квесты жителей Олдерии
\tif citizen_quest_system:
\t\tvar gm_q = _get_game_manager()
\t\tvar p_q = gm_q.player_data if gm_q else null
\t\tvar avail_q = citizen_quest_system.get_available_quest_for_npc(npc["role"], npc["name"])
\t\tif not avail_q.is_empty():
\t\t\t_add_dialogue_btn("📜 «У вас есть для меня поручение?» (%s)" % avail_q["title"], func():
\t\t\t\t_show_quest_offer(avail_q, npc)
\t\t\t)
\t\tvar active_q = citizen_quest_system.get_active_quest_for_npc(npc["role"], npc["name"])
\t\tif not active_q.is_empty():
\t\t\tvar can_c = citizen_quest_system.can_complete_quest(active_q["id"], p_q.inventory if p_q else {})
\t\t\tvar st = " (Готово к сдаче! ✅)" if can_c else " (В процессе...)"
\t\t\t_add_dialogue_btn("🎁 «Я по поводу вашего поручения»%s" % st, func():
\t\t\t\t_try_complete_quest(active_q, npc)
\t\t\t)

\t_add_dialogue_btn("«Подарить 15 золотых на цель жизни» (+35 отн., +8 чести)", func():'''

text = text.replace(old_dialogue_end, quest_dialogue_hooks, 1)

# 4. Add _show_quest_offer and _try_complete_quest helper methods
quest_helpers = '''
# =========================================================
# КВЕСТЫ ЖИТЕЛЕЙ И ДОСКА ОБЪЯВЛЕНИЙ
# =========================================================
func _show_quest_offer(q: Dictionary, npc: Dictionary) -> void:
	dialogue_title.text = "Поручение: %s" % q["title"]
	var req_text = ""
	for it in q["req_items"].keys():
		var it_def = ItemDatabase.get_item(it)
		req_text += "\\n- %s: %d шт." % [it_def.get("name", it), q["req_items"][it]]
		
	var rew_text = "\\n💰 Золото: %d з." % q["rewards"].get("gold", 0)
	if q["rewards"].has("items"):
		for it in q["rewards"]["items"].keys():
			var it_def = ItemDatabase.get_item(it)
			rew_text += "\\n🎁 Награда: %s (%d шт.)" % [it_def.get("name", it), q["rewards"]["items"][it]]
			
	dialogue_text.text = """[b]«%s»[/b]

%s

[color=gold]📦 Требуется принести:[/color]%s

[color=lightblue]✨ Награда за выполнение:[/color]%s""" % [npc["name"], q["desc"], req_text, rew_text]

	for c in dialogue_options_container.get_children():
		c.queue_free()
		
	_add_dialogue_btn("✅ «Я берусь за это дело!» (Принять квест)", func():
		citizen_quest_system.accept_quest(q["id"])
		_log("[color=gold]📜 Вы взяли квест: %s от %s![/color]" % [q["title"], npc["name"]])
		_update_active_quest_tracker()
		_close_all_modals()
	)
	_add_dialogue_btn("❌ «Сейчас у меня нет на это времени» (Отказаться)", func():
		_close_all_modals()
	)

func _try_complete_quest(q: Dictionary, npc: Dictionary) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not p: return
	
	if not citizen_quest_system.can_complete_quest(q["id"], p.inventory):
		_log("[color=red]❌ У вас еще нет всех необходимых предметов для поручения: %s![/color]" % q["title"])
		_close_all_modals()
		return
		
	var rews = citizen_quest_system.complete_quest(q["id"], p)
	npc["reputation_to_player"] = npc.get("reputation_to_player", 0) + 20
	
	_log("[color=gold]🎉 ВЫ ВЫПОЛНИЛИ КВЕСТ: %s! Получено +%d золота, +%d славы![/color]" % [q["title"], rews.get("gold", 0), rews.get("renown", 0)])
	_update_active_quest_tracker()
	_close_all_modals()

func _update_active_quest_tracker() -> void:
	if not active_quest_lbl: return
	if citizen_quest_system:
		var q = citizen_quest_system.get_current_primary_quest()
		if not q.is_empty():
			active_quest_lbl.text = "📜 %s\\n%s" % [q["title"], q["desc"]]
			return
	if notice_board_system and notice_board_system.active_contract_id != "":
		for c in notice_board_system.contracts:
			if c["id"] == notice_board_system.active_contract_id:
				active_quest_lbl.text = "📜 %s\\n%s" % [c["title"], c["desc"]]
				return
	active_quest_lbl.text = "📜 Задание: Нет активных\\nДоска Заказов на площади [E] или меню [Q]"
'''

text = text.rstrip() + "\n" + quest_helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Citizen Quest System and Notice Board integrated into GameWorld2D.gd!")
