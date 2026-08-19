with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

target = '''\t\t\t\tif npc["role"] in ["Бандит", "Разбойник"]:
\t\t\t\t\tp.renown += 10
\t\t\t\t\t_log("[color=gold]⭐ Слава увеличена на +10 за уничтожение бандита![/color]")
\t\t\t\t\tvar completed_quests = ContractManager.update_progress(p, "hunting", "bandit", 1)
\t\t\t\t\tfor cq in completed_quests:
\t\t\t\t\t\t_log("[color=gold][b]📜 ЦЕЛЬ КОНТРАКТА ВЫПОЛНЕНА: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))
\t\t\t\t\t\t_spawn_floating_text(player_pos, "📜 Задание выполнено!", Color(1.0, 0.9, 0.2), 18)
\t# Вепри и другие животные становятся агрессивными при ударе
\tw["is_hostile"] = true
\tw["aggro_dist"] = 180.0'''

replacement = '''\t\t\t\tif npc["role"] in ["Бандит", "Разбойник"]:
\t\t\t\t\tp.renown += 10
\t\t\t\t\t_log("[color=gold]⭐ Слава увеличена на +10 за уничтожение бандита![/color]")
\t\t\t\t\tvar completed_quests = ContractManager.update_progress(p, "hunting", "bandit", 1)
\t\t\t\t\tfor cq in completed_quests:
\t\t\t\t\t\t_log("[color=gold][b]📜 ЦЕЛЬ КОНТРАКТА ВЫПОЛНЕНА: %s! Сдайте контракт [ Q ].[/b][/color]" % cq.get("title", ""))
\t\t\t\t\t\t_spawn_floating_text(player_pos, "📜 Задание выполнено!", Color(1.0, 0.9, 0.2), 18)
\t\t\telse:
\t\t\t\tp.honor -= 25
\t\t\t\t_log("[color=red]⚠️ Убийство мирного жителя! Честь снижена на -25.[/color]")
\t\tnpc["gold"] = 0
\t\t
\t\tif is_raid_active:
\t\t\t_check_raid_wave_progress()
\t\tif is_fort_siege_active:
\t\t\t_check_fort_siege_progress()

func _hit_wildlife(idx: int) -> void:
\tvar w = wildlife_data[idx]
\tif w.get("is_dead", false): return
\t
\t# Вепри и другие животные становятся агрессивными при ударе
\tw["is_hostile"] = true
\tw["aggro_dist"] = 180.0'''

if target in text:
    text = text.replace(target, replacement, 1)
    print('Found and replaced target cleanly!')
else:
    # Try regex or flexible replacement
    import re
    pattern = r'(\s+p\.renown \+= 10[\s\S]*?_spawn_floating_text\(player_pos, "📜 Задание выполнено!", Color\(1\.0, 0\.9, 0\.2\), 18\)\n)\s+# Вепри'
    sub_rep = r'''\1\t\t\telse:
\t\t\t\tp.honor -= 25
\t\t\t\t_log("[color=red]⚠️ Убийство мирного жителя! Честь снижена на -25.[/color]")
\t\tnpc["gold"] = 0
\t\t
\t\tif is_raid_active:
\t\t\t_check_raid_wave_progress()
\t\tif is_fort_siege_active:
\t\t\t_check_fort_siege_progress()

func _hit_wildlife(idx: int) -> void:
\tvar w = wildlife_data[idx]
\tif w.get("is_dead", false): return
\t
\t# Вепри'''
    text, n = re.subn(pattern, sub_rep, text)
    print('Regex substitutions made:', n)

with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print('Saved GameWorld2D.gd!')
