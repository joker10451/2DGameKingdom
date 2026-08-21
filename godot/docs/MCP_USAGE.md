# Godot MCP — руководство использования

_Актуально: 21.08.2026. Проверено по исходникам `godot-mcp-server.mjs` и `~/.hermes/config.yaml`._

## Что это
MCP-сервер позволяет агенту Hermes управлять запущенной игрой «Хроники Олдерии»
(Godot 4.7.1) удалённо: снимать скриншоты, читать UI-элементы, эмулировать ввод,
исполнять GDScript в живой игре.

## Архитектура
```
Hermes (агент)
  └─ stdio (JSON-RPC 2.0, newline-delimited)
       └─ godot-mcp-server.mjs  (Node.js, E:/kiro/game/godot/.mcp/scripts/)
            └─ TCP 127.0.0.1:55139  (4-байта BE length + UTF-8 JSON)
                 └─ mcp_bridge.gd  (Godot autoload в игре)
```

- **Формат кадра бриджа:** `4 байта big-endian длина` + `UTF-8 JSON`.
- **Аутентификация:** `SESSION_TOKEN` пустой → fail-open (без пароля). Не использовать
  в публичных сетях.

## Регистрация в Hermes
Уже прописано в `~/.hermes/config.yaml`:
```yaml
mcp_servers:
  godot:
    command: node
    args:
      - E:/kiro/game/godot/.mcp/scripts/godot-mcp-server.mjs
```
MCP-сервер поднимается Hermesом автоматически при старте сессии (stdio).

## Запуск игры (ОБЯЗАТЕЛЬНО с окном)
Бридж слушает порт только пока игра запущена. **Headless-режим (`--headless`)
НЕ даёт viewport** → `screenshot` вернёт «Failed to capture viewport image».
```
# Консольная сборка Godot (не зависает в Git Bash):
"D:/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe" --path "E:/kiro/game/godot"
```
После запуска бридж поднимает TCP-сервер на 55139 (см. лог игры: «MCP bridge TCP on 55139»).

## Инструменты (6 шт.)

| Инструмент | Назначение | Аргументы |
|---|---|---|
| `ping` | Проверить, что бридж жив | — |
| `screenshot` | Скриншот viewport (PNG-путь) | `preview_max_width?`, `preview_max_height?` (px) |
| `get_ui_elements` | Список UI-контролов | `visible_only?` (bool, default true), `type_filter?` (напр. `"Button"`) |
| `input` | Эмуляция ввода | `actions` (array of `{type, ...}`) |
| `run_script` | GDScript в живой игре | `script` (string) |
| `shutdown` | Остановить бридж/игру | — |

### Примеры вызовов (из агента)
- `mcp_godot_ping()` → подтвердить связь.
- `mcp_godot_screenshot(preview_max_width=1280)` → показать кадр в чате.
- `mcp_godot_get_ui_elements(type_filter="Button")` → найти кнопки (напр. «Купить коня»).
- `mcp_godot_input(actions=[{type:"click", element_name:"buy_horse_btn"}])` → клик.
- `mcp_godot_run_script(script="print(get_tree().get_nodes_in_group('ui'))")` → отладка.
- `mcp_godot_shutdown()` → корректно остановить бридж.

## Типы input (actions)
Каждый элемент `actions` — объект с полем `type`:
- `key` — `key` (напр. `"E"`, `"Q"`, `"Escape"`)
- `mouse_button` — `button` (`left`/`right`), `position?` `{x,y}`
- `mouse_motion` — `position` `{x,y}`
- `ui_click` — `element_name` (имя Control из `get_ui_elements`)
- `action` — Godot InputEventAction (`action` имя)
- `wait` — `ms` (задержка)

## Ограничения
1. **Headless не снимает скриншот** — только Godot с окном.
2. **Порт держится в TIME_WAIT** после `shutdown`/закрытия игры — переподключение
   возможно только после перезапуска Godot.
3. **Без аутентификации** — только localhost, не выставлять наружу.
4. Состояние модалок (Stable/Shipyard/Dog/Bard и др.) живёт в RefCounted-фасадах
   `src/ui/modals/*.gd`; бридж видит их как обычные Control-ноды в дереве сцены.

## Диагностика
- `ping` возвращает `refused` → игра не запущена или бридж не поднялся (см. лог Godot).
- `screenshot` → «Failed to capture viewport image» → игра в `--headless` (нет viewport).
- Порт занят → старый процесс Godot не закрылся; убить через Диспетчер задач.

## Проверено (21.08.2026)
- `godot-mcp-server.mjs` парсится (`node --check`): OK.
- Регистрация в `config.yaml` корректна.
- Headless-валидация всего проекта: `EXIT=0`, 0 SCRIPT ERROR.
- Живая проверка (скриншот через окно) **не выполнялась** — требует GUI Godot на этой машине.
