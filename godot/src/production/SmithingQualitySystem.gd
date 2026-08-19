class_name SmithingQualitySystem
extends RefCounted

## СИСТЕМА КАЧЕСТВА КОВКИ И ТОЧИЛЬНОГО КАМНЯ
## Управляет заточкой лезвий на точильном камне и рангами мастерства при ковке

func sharpen_weapon(player_data: CharacterData) -> Dictionary:
	if not player_data: return {}
	
	# Накладываем бафф бритвенной заточки
	return {
		"success": true,
		"buff_id": "buff_sharpness",
		"duration_hours": 24,
		"bonus_dmg_pct": 15,
		"msg": "✨ ВЖИК-ВЖИК! Вы заточили лезвие на точильном камне! Получен бафф: «Бритвенная Заточка» (+15% к урону на 24 часа)!"
	}

func roll_smithing_quality(smith_skill: int = 1) -> Dictionary:
	var roll = randf() + (smith_skill * 0.05)
	
	if roll >= 1.25:
		return {
			"tier": "masterwork",
			"prefix": "🌟 Шедевр Мастера: ",
			"stat_mult": 1.25,
			"extra_gold": 30,
			"msg": "👑 ВЫКОВАН ШЕДЕВР МАСТЕРА! Оружие сияет безупречной полировкой (+25% к характеристикам)!"
		}
	elif roll >= 0.70:
		return {
			"tier": "fine",
			"prefix": "⚔️ Добротный ",
			"stat_mult": 1.10,
			"extra_gold": 10,
			"msg": "✨ Выковано добротное снаряжение (+10% к характеристикам)!"
		}
	else:
		return {
			"tier": "standard",
			"prefix": "",
			"stat_mult": 1.0,
			"extra_gold": 0,
			"msg": "⚒️ Выковано надежное стандартное снаряжение."
		}
