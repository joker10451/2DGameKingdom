class_name FamilyDynastyDeepeningSystem
extends RefCounted

## СИСТЕМА СЕМЕЙНОГО БЫТА И ВОСПИТАНИЯ ДИНАСТИИ
## Управляет заботой супруги в Усадьбе, домашней экономикой и обучением детей

var last_lunch_day: int = -1
var household_savings: int = 40
var heir_combat_skill: int = 10
var heir_steward_skill: int = 10

func get_spouse_lunch(player_data: CharacterData, current_day: int) -> Dictionary:
	if last_lunch_day == current_day:
		return {
			"success": false,
			"msg": "🍲 Супруга с улыбкой: «Милый, я уже собрала тебе обед сегодня утром! Не забывай хорошо кушать в дороге.»"
		}
		
	last_lunch_day = current_day
	if player_data:
		player_data.satiety = 100.0
		player_data.add_item("steak", 2)
		player_data.add_item("bread", 2)
		
	return {
		"success": true,
		"msg": "🍲 «Садись к столу, любимый!» — супруга подала горячее жаркое с травами и свежий хлеб! Сытость восстановлена на 100% (+припасы в сумку)!"
	}

func collect_savings(player_data: CharacterData) -> Dictionary:
	var amt = household_savings
	household_savings = 0
	if player_data:
		player_data.gold += amt
	return {
		"success": true,
		"gold": amt,
		"msg": "🪙 «Вот сбережения от продажи домашней пряжи и меда: %d золотых!» — супруга передала кошель в общую казну." % amt
	}

func train_heir_combat() -> Dictionary:
	heir_combat_skill += 5
	return {
		"success": true,
		"skill": heir_combat_skill,
		"msg": "⚔️ Вы провели день на тренировочном плацу с сыном, обучая его выпадам и парированию! (Боевой потенциал наследника: %d)" % heir_combat_skill
	}

func train_heir_stewardship() -> Dictionary:
	heir_steward_skill += 5
	return {
		"success": true,
		"skill": heir_steward_skill,
		"msg": "📚 Вы научили наследника вести амбарные книги и рассчитывать торговую пошлину! (Навык управления наследника: %d)" % heir_steward_skill
	}
