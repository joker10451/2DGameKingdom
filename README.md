# Бабушкина дача

Казуальная игра (merge + обустройство) для Яндекс Игр.
Стек: Phaser 3.80+, TypeScript strict, Vite 5/6. Portrait 720x1280, только веб.

## Команды

```bash
npm i
npm run dev      # dev-сервер с HMR
npm run build    # проверка типов + сборка в dist (base './', target es2020)
npm run preview  # превью собранного бандла
npx tsc --noEmit # только проверка типов
```

## Яндекс Игры

Локально SDK отсутствует — `YandexBridge` работает в режиме эмуляции
(проверка `typeof window.YaGames === 'undefined'`).

Перед загрузкой в превью/продакшен Яндекса раскомментируй
`<script src="/sdk.js"></script>` в `index.html`.

## Структура

- `src/scenes` — Phaser-сцены (рендер, ввод, подписки на EventBus)
- `src/systems` — чистые TS-системы без Phaser + EventBus (синглтоны в `index.ts`)
- `src/data` — JSON-данные (контент и числа не хардкодить)
- `src/ui` — Phaser-виджеты HUD
- `src/types` — типы данных и ambient-типы (`yandex.d.ts`)
- `docs/` — GDD.md и ARCHITECTURE.md
