# ГАЙД ПО СКАЧИВАНИЮ 3D АССЕТОВ

Все паки **бесплатные** (лицензия CC0 — можно использовать коммерчески без ограничений).
Формат: скачивай **GLB/GLTF** — это нативный 3D формат Godot 4.

---

## ⭐ ПРИОРИТЕТ 1: Скачать первым делом

### 1. KayKit Medieval Hexagon Pack (200+ моделей зданий)
- **Что внутри**: Таверны, кузницы, мельницы, каменные дома, крепостные стены, башни, мосты, дороги, деревья, камни
- **Скачать**: https://kaylousberg.itch.io/kaykit-medieval-hexagon
- **Или прямо из Godot**: AssetLib → поиск "KayKit Medieval" (Asset #2127)

### 2. KayKit Adventurers — Персонажи с анимациями (4-5 героев)
- **Что внутри**: Рыцарь, Маг, Разбойник, Варвар + 25 оружий (мечи, щиты, луки, посохи) + 75+ анимаций (ходьба, бег, удар, блок, смерть)
- **Скачать**: https://kaylousberg.itch.io/kaykit-adventurers
- **Из Godot**: AssetLib → "KayKit Adventurers" (Asset #2130)

### 3. KayKit Character Animations (90+ универсальных анимаций)
- **Что внутри**: Idle, Walk, Run, Sprint, Jump, Attack_1h, Attack_2h, Block, Dodge, Hit, Death, Interact, Sit, Wave
- **Скачать**: https://kaylousberg.itch.io/kaykit-character-animations

---

## ⭐ ПРИОРИТЕТ 2: Природа и пропсы

### 4. Quaternius Medieval Village MegaKit (300+ модулей)
- **Что внутри**: Модульные стены, крыши, балки, фундаменты, окна, балконы, рыночные палатки, заборы, мосты
- **Скачать**: https://quaternius.itch.io/medieval-village-megakit

### 5. Quaternius Stylized Nature MegaKit (150+ моделей природы)
- **Что внутри**: Дубы, сосны, берёзы, ивы, кусты, цветы, грибы, камни, валуны, брёвна
- **Скачать**: https://quaternius.itch.io/stylized-nature-megakit

### 6. Quaternius Fantasy Props MegaKit (200+ предметов)
- **Что внутри**: Мечи, щиты, зелья, наковальни, горны, сундуки, монеты, бочки, кружки эля, вывески, фонари
- **Скачать**: https://quaternius.itch.io/fantasy-props-megakit

---

## ⭐ ПРИОРИТЕТ 3: Замки, интерьеры, подземелья

### 7. Kenney Fantasy Town Kit (150+ моделей города)
- **Что внутри**: Фахверковые дома, крыши, вывески, рыночные палатки, повозки, бочки, фонари, дорожки
- **Скачать**: https://kenney.nl/assets/fantasy-town-kit

### 8. Kenney Castle Kit (75+ моделей замка)
- **Что внутри**: Каменные стены, зубцы, башни, арки, подъёмные мосты, катапульты, флаги
- **Скачать**: https://kenney.nl/assets/castle-kit

### 9. Kenney Furniture Kit (120+ предметов мебели)
- **Что внутри**: Столы, стулья, кровати, шкафы, полки, ковры, сундуки — для интерьеров таверн и домов
- **Скачать**: https://kenney.nl/assets/furniture-kit

### 10. Kenney Nature Kit (330+ моделей природы)
- **Что внутри**: Деревья, кусты, скалы, водопады, палатки, костры
- **Скачать**: https://kenney.nl/assets/nature-kit

---

## 📦 Как установить в проект

### Вариант А: Через AssetLib прямо в Godot (для KayKit)
1. Откройте вкладку **AssetLib** вверху редактора Godot
2. Найдите "KayKit Medieval" или "KayKit Adventurers"
3. Нажмите **Download** → **Install** → файлы появятся в `addons/`

### Вариант Б: Ручная установка (для Quaternius и Kenney)
1. Скачайте ZIP с itch.io или kenney.nl
2. Распакуйте
3. Скопируйте папку с .glb файлами в `res://assets/` вашего проекта:
```
res://assets/
├── kaykit_medieval/     ← здания, стены, мосты
├── kaykit_adventurers/  ← персонажи + анимации
├── quaternius_village/  ← модульные части зданий
├── quaternius_nature/   ← деревья, камни, кусты
├── quaternius_props/    ← оружие, мебель, предметы
├── kenney_town/         ← городские дома и вывески
├── kenney_castle/       ← замковые стены и башни
└── kenney_furniture/    ← интерьеры таверн и домов
```
4. Godot автоматически импортирует все .glb файлы при открытии проекта
