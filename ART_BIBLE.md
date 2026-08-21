# 2DGameKingdom — ART BIBLE

**Version:** 1.0
**Status:** Approved visual foundation
**Scope:** World, characters, buildings, props, resources, FX and UI

---

## 1. Visual Identity

2DGameKingdom is a stylized medieval living-world simulation. The visual language must communicate a believable, readable medieval settlement while remaining practical for a 2D Godot game.

### Core direction

- Stylized hand-painted 2D illustration.
- Top-down 3/4 orthographic presentation.
- Medieval European-inspired architecture and clothing.
- Warm, grounded, slightly cozy atmosphere; serious simulation underneath.
- Clear silhouettes and strong readability at normal gameplay zoom.
- Cohesive assets must look as if they were created by one art team.
- Detail supports gameplay; detail must never destroy readability.

### Explicitly avoid

- Pixel art.
- Photorealism.
- Generic 3D renders or Blender-like presentation.
- Anime/manga aesthetics.
- Random perspective between assets.
- Excessive black outlines.
- Neon or highly saturated fantasy colors unless deliberately used for gameplay feedback.
- Modern objects, materials or architecture.
- Text, labels, UI elements or watermarks inside world assets.
- Unnecessary environmental backgrounds when generating isolated assets.

---

## 2. Camera and Coordinate Rules

### World camera

- Orthographic.
- Top-down 3/4 view.
- All buildings and props use the same apparent camera angle.
- Vertical walls are visible; roofs remain the dominant readable shape.
- No cinematic vanishing-point perspective.

### Lighting direction

All standard world assets use a common light direction:

**Upper-left → lower-right shadow direction.**

- Key light comes from upper-left.
- Cast shadows fall toward lower-right.
- Interior/exterior lighting must remain consistent between asset families.
- Do not bake contradictory light sources into individual sprites.

### Ground contact

Every world asset must visually sit on the same ground plane.

- Avoid floating objects.
- Avoid deep contact shadows that look like black holes.
- Use a soft grounding shadow where appropriate.

---

## 3. Grid and Scale

### Base grid

**1 tile = 48×48 px.**

All gameplay footprints should be designed around this grid even when the source image is larger.

### Reference scale

| Asset | Typical size |
|---|---:|
| Small prop | 16–32 px |
| NPC | 32–40 px tall |
| Small tree | 48–72 px |
| Large tree | 72–96 px |
| Small house | 3×3 tiles |
| Medium house | 4×3 tiles |
| Large house | 4×4 tiles |
| Farm building | 3–4×3–4 tiles |
| Mill | 4×4 tiles |
| Bakery | 3×3 tiles |
| Smithy | 3×3 tiles |
| Tavern | 5×4 tiles |
| Castle structure | 8×8 tiles or larger |

These are target footprints, not mandatory pixel dimensions. Gameplay collision and placement remain authoritative.

---

## 4. Shape Language

Use a simple, readable silhouette language:

- Buildings: chunky, slightly irregular medieval forms.
- Roofs: broad, readable shapes; roofs are a primary visual identifier.
- Wood: rounded/chunky beams rather than razor-thin lines.
- Stone: irregular blocks with controlled variation.
- Vegetation: clustered masses, not individual noisy leaves.
- Props: exaggerated enough to remain recognizable at gameplay zoom.
- NPCs: compact silhouettes with profession-specific accessories.

Variation is desirable, but the base proportions must remain consistent.

---

## 5. Color System

The palette is warm and natural. Assets may use additional shades, but should remain visually compatible with these anchors.

### Earth

- `#6B4F3A`
- `#8A6548`
- `#A9825C`

### Wood

- `#5A3A27`
- `#785034`
- `#A06D42`

### Stone

- `#77736A`
- `#969187`
- `#B2ACA0`

### Grass

- `#58704A`
- `#70875A`
- `#8C9B65`

### Crops

- `#82944D`
- `#A6A94F`
- `#C1A84E`

### Roofs

- `#713F32`
- `#8B4C38`
- `#A65D43`

### Metal

- `#55565A`
- `#74767A`
- `#9A9A91`

### Gameplay accents

Gold, red and blue may be used for readable gameplay states, faction identity and UI, but must not turn ordinary world assets into neon objects.

---

## 6. Materials and Texture

### Wood

Warm, slightly worn, hand-painted grain. Avoid photographic wood texture.

### Stone

Large readable shapes with subtle surface variation. Avoid high-frequency noise.

### Plaster

Softly uneven, slightly weathered surfaces. Use restrained cracks and stains.

### Roofs

Readable rows of thatch, shingles or tiles. Avoid microscopic individual pieces.

### Metal

Muted steel/iron with simple highlights. Avoid chrome-like reflections.

### General texture rule

Texture must communicate material and age, not exist merely as noise.

---

## 7. Characters

NPCs are assembled conceptually from a shared base character system.

### Base

- Consistent body proportions.
- Consistent head scale.
- Consistent 3/4 top-down camera.
- Consistent lighting.
- Profession expressed through clothing, accessories and held tools.

### Profession examples

**Farmer**
- Straw hat or simple work cap.
- Brown/green work clothing.
- Boots.
- Hoe, sickle or farming tool.

**Miller**
- Beige/brown apron.
- Flour marks.
- Grain sack or mill-related tool.

**Baker**
- Light apron.
- Baker cap or cloth head covering.
- Bread basket or baking tool.

**Blacksmith**
- Dark leather apron.
- Hammer.
- Utility belt.

**Carpenter**
- Work apron.
- Saw, hammer or wood tool.

**Merchant**
- Cleaner, richer clothing.
- Satchel or ledger.

**Guard**
- Leather/metal protection.
- Helmet.
- Spear or sword.

**Noble**
- Better fabrics.
- Heraldic details.
- Visually cleaner silhouette.

**King**
- Strongest silhouette.
- Crown/royal headwear.
- Distinctive royal colors and heraldry.

Do not generate each profession as an unrelated art style.

---

## 8. Buildings

Buildings must be designed as game assets, not concept-art illustrations.

### Required generation properties

- Full building visible.
- Isolated asset.
- Transparent background when supported.
- 3/4 top-down orthographic presentation.
- No characters.
- No unrelated environment.
- No text or signs unless the sign is an intentionally designed world prop.
- Consistent ground contact.
- Consistent light direction.
- Clear gameplay footprint.

### Building families

#### Village

- Small cottage.
- Medium cottage.
- Large house.
- Farmhouse.
- Barn.
- Well.

#### Production

- Mill.
- Bakery.
- Smithy.
- Carpenter workshop.
- Warehouse.

#### Commerce

- Market stall.
- General store.
- Tavern.
.
#### Military

- Guard post.
- Barracks.
- Watchtower.
- Gatehouse.

#### Nobility

- Manor.
- Keep.
- Castle.
- Royal hall.

---

## 9. Environment and Tiles

Terrain must be produced as coordinated tilesets rather than unrelated individual images.

### First tileset

- Grass center.
- Grass variations.
- Dirt center.
- Dirt edges.
- Dirt corners.
- Road straight.
- Road corner.
- Road intersection.
- Water center.
- Water edge.
- Water corners.

### Nature families

- Deciduous trees.
- Conifers.
- Bushes.
- Grass clusters.
- Flowers.
- Rocks.
- Fallen logs.

Variations must share lighting, palette and scale.

---

## 10. Props

Props are gameplay-readable supporting assets.

### Farming

- Hay bale.
- Grain sack.
- Basket.
- Hoe.
- Sickle.
- Fence.
- Water trough.

### Production

- Crate.
- Barrel.
- Flour sack.
- Anvil.
- Hammer.
- Saw.
- Wood pile.
- Oven.

### Commerce

- Market table.
- Stall canopy.
- Signboard.
- Coin chest.
.
### Household

- Table.
- Bench.
- Chair.
- Bucket.
- Lantern.
- Firewood.

Props should be recognizable at gameplay distance and should not compete visually with characters or buildings.

---

## 11. Resources

Every physical economy resource should have a visually consistent icon family.

Initial resources:

- Grain.
- Flour.
- Bread.
- Wood.
- Planks.
- Stone.
- Iron ore.
- Iron ingots.
- Gold.
- Herbs.
- Pelts.

Resource icons should use the same camera/material language as the rest of the game but can have slightly stronger silhouettes for UI readability.

---

## 12. Effects

FX are restrained and readable.

### Production

- Mill dust.
- Flour particles.
- Smithy sparks.
- Bakery smoke.
- Wood dust.

### Environment

- Rain.
- Storm.
- Dust.
- Smoke.
- Fire.

### Social/gameplay

- Heart/friendship indicator.
- Anger indicator.
- Quest indicator.
- Critical need indicator.
- Death indicator.

FX must reinforce simulation state rather than become permanent visual clutter.

---

## 13. UI Visual Language

World UI and menus should feel like the same game.

### Principles

- Warm parchment/wood/stone-inspired surfaces.
- Clear hierarchy.
- Restrained decoration.
- Strong readability.
- Icons over unnecessary text where possible.
- Red = danger/critical.
- Gold = economy/status.
- Green = healthy/positive.
- Blue = information/neutral.

Do not copy the exact colors of the world palette into every UI element; UI needs sufficient contrast.

---

## 14. World-Space Indicators

NPC state should be visible without opening menus.

Examples:

- Food need → bread/food icon.
- Fatigue → sleep icon.
- Social need → speech icon.
- Danger → warning/shield icon.
- Critical need → strong warning marker.
- Waiting for production resource → hourglass.
- Quest → quest marker.
- Friendship → heart.
- Hostility → anger/sword marker.

Indicators should be small, temporary and never obscure the NPC.

---

## 15. Asset Naming Convention

Use lowercase `snake_case`.

### Buildings

`building_<family>_<name>_<variant>`

Examples:

- `building_village_cottage_small_01`
- `building_production_mill_01`
- `building_production_bakery_01`

### Characters

`character_<profession>_<variant>`

Examples:

- `character_farmer_01`
- `character_miller_01`
- `character_guard_02`

### Props

`prop_<category>_<name>_<variant>`

### Environment

`env_<category>_<name>_<variant>`

### Resources

`resource_<name>`

### UI

`ui_<category>_<name>`

Avoid names such as `final_final2.png`, `new_house.png` or `ai_generated_7.png`.

---

## 16. Asset Status

Every asset should have one status:

- 🔴 `NOT_GENERATED`
- 🟡 `GENERATED`
- 🟠 `NEEDS_CLEANUP`
- 🟢 `APPROVED`
- 🔵 `INTEGRATED`

Never integrate an asset directly from the generation stage into production without review.

---

## 17. Generation Workflow

```text
Concept
  ↓
Master reference
  ↓
Style review
  ↓
Generation
  ↓
Background cleanup
  ↓
Crop / scale
  ↓
Palette & lighting review
  ↓
Silhouette review
  ↓
Godot import
  ↓
In-game scale review
  ↓
Approval
```

### Golden rule

**Generate families, not isolated assets.**

For example, generate six trees in one coordinated request rather than six unrelated tree prompts.

---

## 18. Master Asset Strategy

Before mass production, approve these ten master assets:

1. Small medieval cottage.
2. Grass tile.
3. Dirt/road tile.
4. Tree.
5. Farm plot.
6. Farmer NPC.
7. Mill.
8. Bakery.
9. Well.
10. Generic village prop.

If these ten assets look like one coherent game, the visual language is approved for expansion.

---

## 19. AI Generation Prompt — Global Prefix

Use this prefix for all world asset generation:

> 2DGameKingdom visual style, stylized hand-painted 2D medieval European game art, top-down 3/4 orthographic perspective, clean readable silhouette, slightly exaggerated proportions, soft painterly textures, subtle dark warm-brown outlines, warm natural earth-tone palette, soft directional lighting from upper-left, soft ambient shadow toward lower-right, medium detail, high readability at game camera distance, cohesive medieval living-world aesthetic, game-ready asset design.

### Global negative prompt

> pixel art, photorealism, 3D render, Blender render, anime, manga, modern objects, futuristic objects, excessive black outlines, neon colors, cinematic perspective, vanishing point, text, labels, watermark, UI, unrelated background, floating object, inconsistent lighting, extreme texture noise.

---

## 20. Building Prompt Template

```text
2DGameKingdom visual style,
[BUILDING DESCRIPTION],
single isolated game asset,
full building visible,
top-down 3/4 orthographic view,
consistent 48px tile-grid proportions,
clear gameplay footprint,
medieval European construction,
[WALL MATERIAL],
[ROOF MATERIAL],
[PROPS],
soft upper-left lighting,
soft lower-right grounding shadow,
transparent background,
no characters,
no environment,
no text.
```

### Example — master cottage

```text
A small medieval European village cottage,
3x3 tile gameplay footprint,
wooden beams with warm plaster walls,
weathered terracotta roof,
small chimney,
wooden door,
two simple windows,
tiny covered entrance,
slightly worn but well maintained,
clear readable silhouette,
single isolated building,
top-down 3/4 orthographic game asset,
transparent background.
```

---

## 21. Character Prompt Template

```text
2DGameKingdom visual style,
medieval European [PROFESSION] NPC,
shared compact character proportions,
top-down 3/4 orthographic view,
clear readable silhouette,
[OUTFIT],
[ACCESSORIES],
[TOOL/WEAPON],
consistent warm palette,
soft upper-left lighting,
subtle lower-right shadow,
transparent background,
full character visible,
no text.
```

---

## 22. Tileset Prompt Template

```text
2DGameKingdom visual style,
cohesive medieval game tileset,
48x48 pixel tiles,
[GRASS/DIRT/ROAD/WATER] tile family,
seamless edges,
consistent painterly texture,
consistent upper-left lighting,
warm natural palette,
clear readable shapes,
no perspective distortion,
no text,
no characters.
```

---

## 23. Quality Gate

An asset is approved only if all answers are YES:

- Does it look like 2DGameKingdom?
- Does it use the same camera angle?
- Does it use the same lighting direction?
- Does its scale match the 48×48 grid?
- Is its silhouette readable at gameplay zoom?
- Does its palette fit the visual system?
- Does it have clean transparent/background separation when required?
- Does it avoid unwanted AI artifacts?
- Does it visually belong to its asset family?
- Does it work in an actual Godot scene?

If any answer is NO, status remains `NEEDS_CLEANUP`.

---

## 24. Visual Priorities

When visual quality conflicts with detail, use this order:

1. **Readability**
2. **Consistency**
3. **Silhouette**
4. **Scale**
5. **Lighting**
6. **Color harmony**
7. **Material definition**
8. **Small details**

Never sacrifice the first six for decorative detail.

---

## 25. First Production Pack

The first approved production batch should be:

### Terrain

- grass tileset
- dirt tileset
- village road tileset
- water edge tileset

### Nature

- 6 deciduous trees
- 4 bushes
- 4 rocks
- 3 grass clusters
- 3 flowers

### Buildings

- small cottage
- medium cottage
- farmhouse
- barn
- mill
- bakery
- smithy
- carpenter
- tavern
- market
- well

### NPCs

- farmer
- miller
- baker
- blacksmith
- carpenter
- merchant
- guard
- villager

### Props

- barrel
- crate
- sack
- hay bale
- cart
- wood pile
- fence
- bench
- table
- bucket
- lantern
- anvil
- oven
- grain sack
- flour sack
- bread basket

This pack is sufficient to rebuild a visually coherent first village before expanding to towns, castles and royal areas.

---

## 26. Non-Negotiable Rule

**No random asset generation after ART_BIBLE v1.0.**

Every new asset must belong to an existing family or explicitly extend the visual language.

If an asset looks impressive by itself but does not match the rest of the game, it is rejected.

The goal is not to collect beautiful AI images.

The goal is to build **one believable visual world**.
