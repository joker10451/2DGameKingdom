class_name SettlementUnrestSystem
extends RefCounted

## СИСТЕМА ДОВОЛЬСТВА, НАЛОГОВОЙ ПОЛИТИКИ И КРЕСТЬЯНСКИХ БУНТОВ
## Управляет уровнем счастья жителей и разрешением волнений

var contentment: int = 75 # 0..100
var is_revolt_active: bool = false

func update_contentment(tax_rate: int = 10, has_food: bool = true, is_safe: bool = true) -> int:
	var change = 0
	
	# Налоги
	if tax_rate <= 5: change += 2
	elif tax_rate >= 20: change -= 3
	
	# Провизия
	if not has_food: change -= 5
	else: change += 1
	
	# Безопасность
	if is_safe: change += 1
	else: change -= 3
	
	contentment = clamp(contentment + change, 0, 100)
	
	if contentment < 20 and not is_revolt_active:
		trigger_peasant_revolt()
		
	return contentment

func trigger_peasant_revolt() -> Dictionary:
	is_revolt_active = true
	return {
		"started": true,
		"msg": "🔥 КРЕСТЬЯНСКИЙ БУНТ! Недовольные жители вышли на площадь с вилами и факелами! Требуют хлеба и снижения податей!"
	}

func resolve_revolt_feast(player_data: CharacterData) -> Dictionary:
	if not is_revolt_active: return {}
	
	var cost = 30
	if player_data and player_data.gold >= cost:
		player_data.gold -= cost
		player_data.honor += 15
		player_data.renown += 20
		
	is_revolt_active = false
	contentment = min(100, contentment + 40)
	
	return {
		"success": true,
		"contentment": contentment,
		"msg": "🎉 ВЫ ЗАКАТИЛИ ГРАНДИОЗНЫЙ ПРАЗДНИК! На площади накрыты столы с жареным мясом и бочонками эля! Бунт утих, народ славит щедрого Лорда (+40 довольства, +15 чести)!"
	}

func resolve_revolt_grain(stockpile: RefCounted) -> Dictionary:
	if not is_revolt_active: return {}
	
	if stockpile and "stockpiles" in stockpile:
		stockpile.stockpiles["bread"] = max(0, stockpile.stockpiles.get("bread", 0) - 20)
		
	is_revolt_active = false
	contentment = min(100, contentment + 30)
	
	return {
		"success": true,
		"contentment": contentment,
		"msg": "🥖 ВЫ РАЗДАЛИ ХЛЕБ ИЗ АМБАРОВ! Каждая семья получила по свежей буханке хлеба. Волнения утихли (+30 довольства)!"
	}

func resolve_revolt_force() -> Dictionary:
	if not is_revolt_active: return {}
	is_revolt_active = false
	contentment = max(10, contentment - 10)
	return {
		"success": true,
		"msg": "🛡️ СТРАЖА ПОДАВИЛА БУНТ! Зачинщики разогнаны, на улицах выставлены патрули (порядок восстановлен, но в народе зреет скрытая обида)."
	}
