# Архитектура — «Бабушкина дача»

> Статус: заглушка. Описывает скелет проекта; детали уточняются по задачам.

## Стек

- Phaser 3.80+ (новый Particles API: `add.particles(...)` / `emitParticle()`, не `createEmitter`).
- TypeScript strict, Vite 5/6, `base: './'` (обязательно для Яндекс Игр), `build.target: es2020`.
- Весь геймплейный UI — Phaser-объекты. DOM только `index.html` + `sdk.js`.

## Структура папок

| Папка | Назначение |
| --- | --- |
| `src/scenes` | Phaser-сцены: рендер, ввод (pointer), подписки на EventBus |
| `src/systems` | Чистые TS-системы без Phaser + EventBus; синглтоны в `index.ts` |
| `src/data` | JSON-данные — контент и числа не хардкодить |
| `src/ui` | Phaser-виджеты HUD |
| `src/types` | Типы данных и ambient-типы (`yandex.d.ts`) |
| `public/` | Статика (sdk.js отдаёт платформа, локально отсутствует) |

## Системы (src/systems)

Чистые классы не зависят от Phaser: принимают данные, эмитят события через `bus`.
Синглтоны создаются только в `src/systems/index.ts`.

| Класс | Файл | Ответственность |
| --- | --- | --- |
| EventBus | `EventBus.ts` | `bus = new Phaser.Events.EventEmitter()` |
| ItemDB | `ItemDB.ts` | цепочки слияния, тиры, генераторы, `mergeCount()` |
| Economy | `Economy.ts` | монеты, энергия, регенерация через `update(deltaMs)` |
| OrderSystem | `OrderSystem.ts` | активные заказы, `trySubmit`, награды |
| SaveSystem | `SaveSystem.ts` | localStorage, dirty-флаг, `saveNow/load/reset` |
| YandexBridge | `YandexBridge.ts` | SDK Яндекса: реклама, облако; локально — эмуляция |
| GameManager | `GameManager.ts` | режимы BOARD/META |

## События EventBus (src/systems/events.ts)

| Событие | Payload | Эмиттер |
| --- | --- | --- |
| `coins:changed` | `coins: number` | Economy |
| `energy:changed` | `energy: number` | Economy |
| `energy:shortage` | `need: number` | Economy |
| `merge:done` | — | (будущая механика merge) |
| `order:completed` | `OrderData` | OrderSystem |
| `meta:changed` | `'BOARD' \| 'META'` | GameManager |
| `rewarded:granted` | `reason: string` | YandexBridge |
| `interstitial:closed` | — | YandexBridge |
| `save:changed` | `key, value` | SaveSystem |
| `save:loaded` | `data` | SaveSystem |
| `boot:ready` | — | BootScene |

## Правила

1. Системы не импортируют Phaser (кроме EventBus).
2. Ввод — только pointer-события Phaser (мышь и тач одним кодом).
3. Все числа — из `src/data/*.json` или `src/config.ts`.
4. Сцены не создают дубли систем — только синглтоны из `src/systems/index.ts`.
5. Регенерация энергии — из `update(deltaMs)` сцены, без `setInterval`.
