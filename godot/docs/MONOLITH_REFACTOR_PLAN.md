# План рефакторинга монолита GameWorld2D.gd

_Актуально: 21.08.2026. Headless-валидация EXIT=0, 0 SCRIPT ERROR._

## Цель
Вынести UI-модалки из монолита `src/game2d/GameWorld2D.gd` (было ~13157 строк)
в RefCounted-фасады `src/ui/modals/*.gd`. UI + состояние выбора живут в фасаде;
мутации «мира» (инвентарь, золото, квесты, питомцы) — через колбэки в монолите.

## Паттерн
```
class_name XModal extends RefCounted
const UIHelpersScript = preload("res://src/ui/UIHelpers.gd")
var _on_log, _on_floating_text, _on_spark, ... : Callable
func build(canvas, ...колбэки...): _build_panel(canvas)
func open()/close()/is_open()/refresh()
# действия: _on_*_pressed -> if _on_x.is_valid(): _on_x.call(...)
```

## Статус (16/16 self-contained вынесены)

| # | Фасад | Коммит |
|---|---|---|
| 1 | InventoryModal | ранее |
| 2 | SkillsModal | ранее |
| 3 | TradeModal | ранее |
| 4 | SmithingModal | ранее |
| 5 | ContractsModal | 6355ea7 |
| 6 | PartyModal | 7f4be69 |
| 7 | EstateModal | ранее |
| 8 | ConstructionModal | fe8dab0 |
| 9 | ChestModal | 9ae61ca |
| 10 | OriginModal | 142554c |
| 11 | CitizenShopModal | 2a08938 |
| 12 | AlchemyModal | 6431c10 |
| 13 | StableModal | 4b2d109 |
| 14 | ShipyardModal | dd03c17 |
| 15 | DogModal | 35c270d |
| 16 | BardModal | f97a556 |

**Итог:** GameWorld2D.gd = 9099 строк (−31% от ~13157).

## НЕ трогать (отложено, высокий риск)
- `_build_dialogue_modal` (строка ~4420) — общие `dialogue_*` globals
- `_build_event_modal` (~4801) — размер ~1870 строк, связан с квестами
- `_build_settlement_modal` (~6744) — связан с Party/Estate globals

Решение: выносить только после стабилизации и живой проверки через MCP.

## Инфраструктура
- Godot MCP-бридж: `godot/mcp_bridge.gd` (autoload, TCP 127.0.0.1:55139)
- MCP-сервер: `godot/.mcp/scripts/godot-mcp-server.mjs` (Node.js stdio→TCP прокси)
- Регистрирован в `~/.hermes/config.yaml` под `mcp_servers.godot`
- Скриншот в headless НЕ работает (`viewport == null`) — нужен Godot с окном

## Заметки
- Все фасады обязаны иметь `const UIHelpersScript` (иначе `--script` падает)
- Кириллические `_log`-строки править через patch-инструмент (Python искажает unicode)
- Блочные замены через Python могут срезать хвост соседней функции — всегда
  проверять headless-валидацией после правки
