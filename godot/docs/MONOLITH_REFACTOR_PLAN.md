# План рефакторинга монолита `GameWorld2D.gd`

**Состояние на 19.08.2026.** `src/game2d/GameWorld2D.gd` — 13 157 строк, 215 функций.
Валидация Godot 4.7.1 `--headless --validate`: фатальных ошибок парсинга **0** (см. `.mcp/validate_log.txt`).

## Что УЖЕ модульно (трогать не надо)
`_ready()` инстанцирует ~40 под-систем как отдельные `RefCounted`/`Node`, например:
`EstateManager`, `PartyManager`, `NobilitySystem`, `RaidSystem`, `DungeonGenerator2D`,
`FactionWarfareSystem`, `CitizenQuestSystem`, `ProceduralAudioSystem`, `AtmosphereVFXSystem`,
`CryptMonstersSystem`, `SocialMemoryDialogueSystem` и др. Они вызываются как `System.new()` + метод.
Это правильная архитектура — ядро логики уже вынесено.

## Что зашито в монолит (цель разбиения)
Все 215 функций делятся на зоны ответственности:

| Зона | Функции (примеры) | Строки | Куда выносить |
|---|---|---|---|
| **A. Ввод и игровой цикл** | `_input`, `_physics_process`, `_process`, `_handle_interaction_key`, `_perform_action_at_cursor`, `_spawn_player` | 638–2232 | (остаётся в GameWorld2D — оркестратор) |
| **B. Спавн и мир** | `_spawn_npcs`, `_spawn_wildlife`, `_create_animal`, `_create_build_cursor`, `_spawn_environmental_lights` | 842–1412 | `World/Spawning.gd` (хелпер) |
| **C. Бой и урон** | `_hit_npc`, `_hit_wildlife`, `_animal_attack_player`, `_bandit_attack_player`, `_on_player_defeat`, `_spawn_slash_effect`, `_spawn_projectile`, `_update_projectiles`, `_update_enemy_archers`, `_perform_dodge_roll`, `_use_bandage` | 2480–3090, 8325–8520, 13003+ | `combat/CombatController.gd` |
| **D. UI-хелперы** | `_make_medieval_panel_style`, `_style_button`, `_spawn_floating_text`, `_log`, `_shake_screen`, `_play_sfx`, `_get_game_manager`, `_get_time_manager` | 2233+, 4096–4182, 6619+ | `ui/UIHelpers.gd` (autoload или static) |
| **E. Модальные окна (34 шт!)** | `_build_*_modal`, `_open_*`, `_refresh_*`, `_on_*_pressed` для: inventory, trade, smithing, event, construction, chest, skills, contracts, party, estate, settlement, citizen_shop, alchemy, stable, shipyard, bard, dog, origin | 4690–13150 | `ui/modals/*.gd` (по фиче) |
| **F. Локации/путешествия** | `_toggle_overworld_mode`, `_enter_overworld_location`, `_toggle_dungeon`, `_enter_crypt_dungeon`, `_start_fort_siege`, `_start_island_expedition` | 3606–3998, 12847+ | `world/TravelController.gd` |
| **G. Производство/хозяйство** | `_use_windmill`, `_use_carpentry_bench`, `_open_bakery_menu`, `_harvest_*`, `_try_fish`, `_repair_structure`, `_update_colonists_labor` | 3224–3610, 9809+ | уже есть `production/*` — связать |
| **H. Социум/питомцы** | `_spawn_dog_companion`, `_process_dog_companion`, `_feed_dog_*`, `_train_family_heir`, `_praise_current_npc`, `_trigger_peasant_revolt_*` | 12331+ | `social/*` / `character/PetCompanionSystem` |

## Стратегия (минимальный риск)
1. **Сначала E + D** — UI и хелперы. Они чисто презентационные, не ломают игровую логику.
   Вынести каждое модальное окно в `ui/modals/<Feature>Modal.gd` с методом `build(parent_canvas, world)`.
   `GameWorld2D` держит ссылку и вызывает `InventoryModal.build(...)`.
2. **Потом C** — бой. Создать `CombatController` (RefCounted), передавать ему `player_*`-поля по ссылке/сигналам.
3. **B, F, G, H** — спавн/путешествия/хозяйство/социум выносятся как хелперы-узлы, вызываемые из оркестратора.
4. `GameWorld2D.gd` остаётся **оркестратором**: `_ready`, `_process`, `_physics_process`, `_input`, маршрутизация к модулям.

## Правила (из GAME.md §8)
- Single Source of Truth: UI не угадывает состояние, ядро считает урон/ресурсы.
- Крупными мазками: брать связанную зону (3–6 карточек), не дробить по одной функции.
- Не создавать документы ради документов — этот план живёт только как техэнциклопедия.

## Прогресс (обновляется по ходу)

| Шаг | Что сделано | Статус |
|---|---|---|
| 1. UI-хелперы | `ui/UIHelpers.gd` (autoload): `panel_style()`, `style_button()`. Монолит делегирует. | ✅ `19e6890` |
| 2. InventoryModal | `ui/modals/InventoryModal.gd` (RefCounted-фасад + колбэки эффектов). | ✅ `e1573c7` |
| 3. SkillsModal | `ui/modals/SkillsModal.gd` (read-only фасад). | ✅ `7f57532` |
| 4. TradeModal | `_build_trade_modal` (рынок) — мутирует gold/инвентарь, сложнее. | ⬜ |
| 5. SmithingModal | `_build_smithing_modal` — крафт (мутирует инвентарь/навыки). | ⬜ |
| 6. ContractsModal | `_build_contracts_modal` (22 функции!). Самая большая зона. | ⬜ |
| 7. PartyModal | `_build_party_modal` (13 функций). | ⬜ |
| 8. EstateModal | `_build_estate_modal` (15 функций). | ⬜ |
| 9. SettlementModal | `_build_settlement_modal`. | ⬜ |
| 10. Remaining modals | event, construction, chest, dialogue, origin, citizen_shop, alchemy, stable, shipyard, bard, dog. | ⬜ |
| 11. CombatController | `_hit_npc/_hit_wildlife/_spawn_slash_effect/_spawn_projectile` → `combat/`. | ⬜ |
| 12. Spawning/World helpers | `_spawn_npcs/_spawn_wildlife/_create_animal` → `world/`. | ⬜ |

**Метрика:** GameWorld2D.gd 13 157 → 12 559 строк (−598). Каждый вынос модалки экономит 50–350 строк.
**Риск:** модалки, мутирующие состояние (trade/smithing/contracts/party/estate), требуют колбэков как в InventoryModal. Read-only (skills) — проще.

## Известные дефекты (из валидации, чинить отдельно)
- `SpriteGenerator2D.gd` — **ИСПРАВЛЕНО** (PNG→Texture2D, 22→0 WARNING). `2225d49`
- Headless-лог при выходе: `ObjectDB instances were leaked` / `1 resources still in use` — штатный шум, не влияет.

