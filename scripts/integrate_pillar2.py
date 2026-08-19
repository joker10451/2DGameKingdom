with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Preloads and variables
old_vars = '''const CookingBuffSystemScript = preload("res://src/production/CookingBuffSystem.gd")'''
new_vars = '''const CookingBuffSystemScript = preload("res://src/production/CookingBuffSystem.gd")
const SocialMemoryDialogueSystemScript = preload("res://src/social/SocialMemoryDialogueSystem.gd")
const InterCitizenSocialSystemScript = preload("res://src/social/InterCitizenSocialSystem.gd")
const FamilyDynastyDeepeningSystemScript = preload("res://src/social/FamilyDynastyDeepeningSystem.gd")

var social_memory_dialogue_system: RefCounted
var inter_citizen_social_system: RefCounted
var family_dynasty_deepening_system: RefCounted'''
text = text.replace(old_vars, new_vars, 1)

# 2. Instantiate in _ready()
old_ready_end = '''\tif world_map:
\t\tworld_map.place_structure(Vector2i(28, 12), "grindstone")'''

new_ready_end = '''\tif world_map:
\t\tworld_map.place_structure(Vector2i(28, 12), "grindstone")
\t
\t# 5.10. Углубление Социума, Памяти и Семьи (Блок №2)
\tsocial_memory_dialogue_system = SocialMemoryDialogueSystemScript.new()
\tinter_citizen_social_system = InterCitizenSocialSystemScript.new()
\tfamily_dynasty_deepening_system = FamilyDynastyDeepeningSystemScript.new()'''
text = text.replace(old_ready_end, new_ready_end, 1)

# 3. Add dynamic topics in _open_dialogue()
old_dialogue_gift = '''\t_add_dialogue_btn("«Подарить 15 золотых на цель жизни» (+35 отн., +8 чести)", func():'''

new_dialogue_topics = '''\t# Новые ветки живого общения (Блок №2)
\tif social_memory_dialogue_system:
\t\t_add_dialogue_btn("🗣️ «Что нового слышно в Олдерии?» (Слухи)", func():
\t\t\tvar goss = social_memory_dialogue_system.get_gossip_topic(npc, {})
\t\t\tdialogue_text.text = "[b]%s[/b]\\n\\n%s" % [goss["title"], goss["text"]]
\t\t)
\t\t_add_dialogue_btn("🏰 «Как тебе живется в деревне?» (Мнение)", func():
\t\t\tvar op = social_memory_dialogue_system.get_village_opinion(npc, 10)
\t\t\tdialogue_text.text = "[b]%s[/b]\\n\\n%s" % [op["title"], op["text"]]
\t\t)
\t\t_add_dialogue_btn("📜 «Расскажи о себе» (Предыстория)", func():
\t\t\tvar bio = social_memory_dialogue_system.get_character_backstory(npc)
\t\t\tdialogue_text.text = "[b]%s[/b]\\n\\n%s" % [bio["title"], bio["text"]]
\t\t)

\t_add_dialogue_btn("«Подарить 15 золотых на цель жизни» (+35 отн., +8 чести)", func():'''

text = text.replace(old_dialogue_gift, new_dialogue_topics, 1)

# 4. Add Helper Methods for Tavern Brawls and Family
helpers = '''
# =========================================================
# УГЛУБЛЕНИЕ СОЦИУМА: ТАВЕРНА, ДРАКИ И СЕМЕЙНЫЙ БЫТ
# =========================================================
func _trigger_tavern_brawl() -> void:
	if not inter_citizen_social_system or npc_data.size() < 2: return
	var res = inter_citizen_social_system.start_tavern_brawl(npc_data[0], npc_data[1])
	_log("[color=red][b]%s[/b][/color]" % res["msg"])
	_spawn_floating_text(Vector2(25 * 48, 23 * 48), "🥊 ДРАКА В ТАВЕРНЕ!", Color.RED, 20)

func _resolve_tavern_brawl_ale() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not inter_citizen_social_system or not p: return
	var res = inter_citizen_social_system.resolve_brawl_buy_ale(p)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🍺 ТОСТ ЗА ЛОРДА! +15 ЧЕСТИ", Color.GOLD, 18)

func _get_spouse_home_lunch() -> void:
	var gm = _get_game_manager()
	var p: CharacterData = gm.player_data if gm else null
	if not family_dynasty_deepening_system or not p: return
	var tm = _get_game_manager()
	var cur_day = TimeManager.day if TimeManager else 1
	var res = family_dynasty_deepening_system.get_spouse_lunch(p, cur_day)
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "🍲 ДОМАШНИЙ ОБЕД: 100% СЫТОСТЬ", Color.GOLD, 18)

func _train_family_heir(train_type: String = "combat") -> void:
	if not family_dynasty_deepening_system: return
	var res = {}
	if train_type == "combat":
		res = family_dynasty_deepening_system.train_heir_combat()
	else:
		res = family_dynasty_deepening_system.train_heir_stewardship()
	_log("[color=gold]%s[/color]" % res["msg"])
	_spawn_floating_text(player_pos, "⚔️ ОБУЧЕНИЕ НАСЛЕДНИКА", Color.GOLD, 18)
'''

text = text.rstrip() + "\n" + helpers

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Pillar 2 Social Deepening integrated into GameWorld2D.gd!")
