class_name DeathLifecycleSystem
extends RefCounted

## DeathLifecycleSystem: Полный жизненный цикл смерти персонажей
## Управляет деактивацией AI, освобождением рабочих мест, наследством, трауром и кровной местью

static func handle_character_death(
	victim_node: Node,
	victim_data: CharacterData,
	killer_node: Node = null,
	killer_data: CharacterData = null,
	all_citizens: Array = [],
	quest_system: RefCounted = null
) -> Dictionary:
	if not victim_data:
		return {"status": "error", "msg": "No victim data provided"}

	# 1. Помечаем мертвого персонажа
	victim_data.is_dead = true
	victim_data.health = 0.0

	# 2. Деактивация AI компонентов
	if victim_node:
		var brain = victim_node.get_node_or_null("UtilityBrain")
		if brain:
			brain.set_process(false)
			brain.current_action = "DEAD"

		var needs = victim_node.get_node_or_null("NeedsComponent")
		if needs:
			needs.set_process(false)

		if victim_node is CanvasItem:
			victim_node.modulate = Color(0.5, 0.5, 0.5, 0.7)

	# 3. Освобождение рабочего места
	var previous_role = victim_data.current_role
	var previous_workplace = victim_data.workplace_id if "workplace_id" in victim_data else ""
	if "workplace_id" in victim_data:
		victim_data.workplace_id = ""

	# 4. Обработка имущества и наследства
	var dropped_gold = victim_data.gold
	var dropped_items = victim_data.inventory.duplicate()
	victim_data.gold = 0
	victim_data.inventory.clear()

	# 5. Социальная волна: Траур родственников и Кровная Месть убийце
	var killer_id = killer_data.id if killer_data and "id" in killer_data else (killer_node.name if killer_node else "")
	var mourning_count := 0
	var grudges_added := 0

	for citizen in all_citizens:
		var c_mem: MemoryComponent = null
		var c_needs: NeedsComponent = null
		if citizen is MemoryComponent:
			c_mem = citizen
		elif citizen is Node:
			c_mem = citizen.get_node_or_null("MemoryComponent")
			if not c_mem:
				for ch in citizen.get_children():
					if ch is MemoryComponent:
						c_mem = ch
						break
			c_needs = citizen.get_node_or_null("NeedsComponent")
			if not c_needs:
				for ch in citizen.get_children():
					if ch is NeedsComponent:
						c_needs = ch
						break

		if c_mem:
			var op = c_mem.get_opinion(victim_data.name)
			# Если были друзьями или семьей (Opinion > 25)
			if op > 25.0:
				c_mem.modify_opinion(victim_data.name, -15.0, "Скорбь о гибели друга %s" % victim_data.name)
				if c_needs:
					c_needs.social_need = clampf(c_needs.social_need + 30.0, 0.0, 100.0)
					c_needs.fatigue = clampf(c_needs.fatigue + 15.0, 0.0, 100.0)
				mourning_count += 1

				# Кровная обида на убийцу
				if killer_id != "":
					c_mem.add_grudge(killer_id, "Убийство близкого товарища %s" % victim_data.name, 10)
					grudges_added += 1

	# 6. Отмена активных квестов погибшего
	if quest_system and quest_system.has_method("cancel_quests_from_giver"):
		quest_system.cancel_quests_from_giver(victim_data.name)

	# 7. Отправка в EventBus
	var eb = Engine.get_main_loop().root.get_node_or_null("/root/EventBus") if Engine.get_main_loop() else null
	if eb and eb.has_signal("character_died"):
		eb.character_died.emit(victim_node, killer_node)

	return {
		"status": "success",
		"victim_name": victim_data.name,
		"previous_role": previous_role,
		"previous_workplace": previous_workplace,
		"dropped_gold": dropped_gold,
		"dropped_items": dropped_items,
		"mourning_citizens": mourning_count,
		"grudges_against_killer": grudges_added,
		"msg": "💀 Персонаж %s погиб. Рабочее место освобождено, вещи сброшены." % victim_data.name
	}
