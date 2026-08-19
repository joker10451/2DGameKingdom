with open('godot/src/game2d/GameWorld2D.gd', 'r', encoding='utf-8') as f:
    text = f.read()

target = '''func _update_quest_tracker() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return

\tContractManager.ensure_player_contracts(p)'''

replacement = '''func _update_quest_tracker() -> void:
\tvar gm = _get_game_manager()
\tvar p: CharacterData = gm.player_data if gm else null
\tif not p: return

\tif citizen_quest_system:
\t\tvar cq = citizen_quest_system.get_current_primary_quest()
\t\tif not cq.is_empty():
\t\t\tvar can_c = citizen_quest_system.can_complete_quest(cq["id"], p.inventory)
\t\t\tquest_tracker_title.text = "%s %s" % ["✅" if can_c else "📜", cq["title"]]
\t\t\tif can_c:
\t\t\t\tquest_tracker_desc.text = "✅ Цель выполнена! Сдайте жителю [ E ]"
\t\t\t\tquest_tracker_bar.value = 100.0
\t\t\telse:
\t\t\t\tvar first_req = cq["req_items"].keys()[0]
\t\t\t\tvar req_cnt: int = cq["req_items"][first_req]
\t\t\t\tvar cur_cnt: int = p.get_item_count(first_req)
\t\t\t\tvar it_name = ItemDatabase.get_item(first_req).get("name", first_req)
\t\t\t\tquest_tracker_desc.text = "🎯 %s: %d / %d" % [it_name, cur_cnt, req_cnt]
\t\t\t\tquest_tracker_bar.value = (float(cur_cnt) / float(req_cnt)) * 100.0
\t\t\treturn

\tContractManager.ensure_player_contracts(p)'''

# Normalize spaces/newlines
if "func _update_quest_tracker() -> void:" in text:
    parts = text.split("func _update_quest_tracker() -> void:")
    body_parts = parts[1].split("ContractManager.ensure_player_contracts(p)", 1)
    new_text = parts[0] + replacement + body_parts[1]
    with open('godot/src/game2d/GameWorld2D.gd', 'w', encoding='utf-8', newline='\n') as f:
        f.write(new_text)
    print("Successfully patched _update_quest_tracker()!")
else:
    print("Function header not found")
