with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const FamilyDynastyDeepeningSystemScript = preload("res://src/social/FamilyDynastyDeepeningSystem.gd")'''
new_vars = '''const FamilyDynastyDeepeningSystemScript = preload("res://src/social/FamilyDynastyDeepeningSystem.gd")
const NPCLearningSystemScript = preload("res://src/social/NPCLearningSystem.gd")
const ApprenticeshipSystemScript = preload("res://src/social/ApprenticeshipSystem.gd")

var npc_learning_system: RefCounted
var apprenticeship_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tfamily_dynasty_deepening_system = FamilyDynastyDeepeningSystemScript.new()'''
new_ready_end = '''\tfamily_dynasty_deepening_system = FamilyDynastyDeepeningSystemScript.new()
\t
\t# 5.11. Система Обучения и Подкрепления NPC
\tnpc_learning_system = NPCLearningSystemScript.new()
\tapprenticeship_system = ApprenticeshipSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add reinforcement and learning buttons in _open_dialogue()
old_topics = '''\t\t_add_dialogue_btn("📜 «Расскажи о себе» (Предыстория)", func():
\t\t\tvar bio = social_memory_dialogue_system.get_character_backstory(npc)
\t\t\tdialogue_text.text = "[b]%s[/b]\\n\\n%s" % [bio["title"], bio["text"]]
\t\t)'''

new_topics = '''\t\t_add_dialogue_btn("📜 «Расскажи о себе» (Предыстория)", func():
\t\t\tvar bio = social_memory_dialogue_system.get_character_backstory(npc)
\t\t\tdialogue_text.text = "[b]%s[/b]\\n\\n%s" % [bio["title"], bio["text"]]
\t\t)
\t
\t# Меню Наставничества и Подкрепления
\tif npc_learning_system:
\t\tvar n_id = npc.get("name", "npc_0")
\t\t_add_dialogue_btn("🌟 «Похвалить за усердие» (+Трудолюбие, +Лояльность)", func():
\t\t\t_praise_current_npc(n_id, npc)
\t\t)
\t\t_add_dialogue_btn("🪙 «Выдать премию (10 з.)» (Бафф x1.5 скорости работы)", func():
\t\t\t_reward_current_npc_bonus(n_id, npc)
\t\t)
\t\t_add_dialogue_btn("⚠️ «Сделать строгий выговор за лень» (+Дисциплина)", func():
\t\t\t_reprimand_current_npc(n_id, npc)
\t\t)
\t\t_add_dialogue_btn("📖 «Провести урок ремесла» (+35 XP опыта)", func():
\t\t\t_teach_current_npc_lesson(n_id, npc)
\t\t)'''

text = text.replace(old_topics, new_topics, 1)

# 4. Add Helper Methods
helpers = '''
# =========================================================
# СИСТЕМА ОБУЧЕНИЯ, ПОДКРЕПЛЕНИЯ И НАСТАВНИЧЕСТВА NPC
# =========================================================
func _praise_current_npc(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var res = npc_learning_system.praise_npc(npc_id, npc)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🌟 ПОХВАЛА! +ТРУДОЛЮБИЕ", Color.GOLD, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _reward_current_npc_bonus(npc_id: String, npc: Dictionary) -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not npc_learning_system or not p: return
	var res = npc_learning_system.reward_bonus(npc_id, npc, p)
	if res.get("success", false):
		_log("[color=gold][b]%s[/b][/color]" % res["msg"])
		_spawn_floating_text(player_pos, "🪙 ПРЕМИЯ! x1.5 СКОРОСТЬ", Color.GOLD, 18)
	else:
		_log("[color=orange]%s[/color]" % res.get("msg", ""))
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _reprimand_current_npc(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var res = npc_learning_system.reprimand_npc(npc_id, npc)
	_log("[color=orange]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "⚠️ ВЫГОВОР! +ДИСЦИПЛИНА", Color.ORANGE, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]

func _teach_current_npc_lesson(npc_id: String, npc: Dictionary) -> void:
	if not npc_learning_system: return
	var role = npc.get("role", "")
	var craft = "farming"
	if role == "Кузнец": craft = "smithing"
	elif role in ["Пекарь", "Трактирщица"]: craft = "baking"
	elif role in ["Городской Стражник", "Охотник"]: craft = "combat"
	
	var res = npc_learning_system.teach_skill(npc_id, craft)
	_log("[color=lightblue]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "📖 УРОК РЕМЕСЛА: +35 XP", Color.CYAN, 18)
	if dialogue_text:
		dialogue_text.text = res["msg"]
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("NPC Learning & Reinforcement system integrated into GameWorld2D.gd!")
