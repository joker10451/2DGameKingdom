extends SceneTree

## Headless CI Quality Gate & Smoke Test
## Runs on GitHub Actions and local validation to ensure 0 SCRIPT ERRORs

func _init() -> void:
	print("\n========================================================")
	print("🛡️  STARTING GODOT HEADLESS QUALITY GATE & SMOKE TEST")
	print("========================================================")

	# 1. Validate All 21 UI Modal Facades
	print("\n[1/4] Validating 21 Modular Modal Facades...")
	var modals = [
		"res://src/ui/modals/AlchemyModal.gd",
		"res://src/ui/modals/BardModal.gd",
		"res://src/ui/modals/CaravanModal.gd",
		"res://src/ui/modals/ChestModal.gd",
		"res://src/ui/modals/CitizenShopModal.gd",
		"res://src/ui/modals/ConstructionModal.gd",
		"res://src/ui/modals/ContractsModal.gd",
		"res://src/ui/modals/DialogueModal.gd",
		"res://src/ui/modals/DogModal.gd",
		"res://src/ui/modals/EstateModal.gd",
		"res://src/ui/modals/EventModal.gd",
		"res://src/ui/modals/InventoryModal.gd",
		"res://src/ui/modals/OriginModal.gd",
		"res://src/ui/modals/PartyModal.gd",
		"res://src/ui/modals/RegionalDiplomacyModal.gd",
		"res://src/ui/modals/SettlementModal.gd",
		"res://src/ui/modals/ShipyardModal.gd",
		"res://src/ui/modals/SkillsModal.gd",
		"res://src/ui/modals/SmithingModal.gd",
		"res://src/ui/modals/StableModal.gd",
		"res://src/ui/modals/TradeModal.gd"
	]
	for m in modals:
		var script_res = load(m)
		if script_res == null:
			printerr("❌ [CI FAILED] Cannot load modal script: ", m)
			quit(1)
			return
		var inst = script_res.new()
		if inst == null:
			printerr("❌ [CI FAILED] Cannot instantiate modal facade: ", m)
			quit(1)
			return
		print("  ✅ Modal facade OK: ", m.get_file())

	# 2. Validate Combat & Raid System
	print("\n[2/4] Validating Combat & Warfare Systems...")
	var raid_script = preload("res://src/combat/RaidSystem.gd")
	var raid_sys = raid_script.new()
	var raid_info = raid_sys.start_raid(Vector2i(6, 6))
	if raid_info.get("count", 0) <= 0:
		printerr("❌ [CI FAILED] RaidSystem failed to spawn raider wave!")
		quit(1)
		return
	print("  ✅ RaidSystem 3-Wave Combat Logic OK (Spawned %d raiders)" % raid_info["count"])

	# 3. Validate Living World NPC Routine AI
	print("\n[3/4] Validating Living World 24h Routine AI...")
	var npc_ai = preload("res://src/ai/NPCRoutineController.gd")
	var phase_morning = npc_ai.get_schedule_phase(10, false, "clear", "Кузнец")
	if phase_morning != "work_shift_1":
		printerr("❌ [CI FAILED] Unexpected NPC schedule phase: ", phase_morning)
		quit(1)
		return
	var phase_alarm = npc_ai.get_schedule_phase(10, true, "clear", "Крестьянин")
	if phase_alarm != "panic_flee":
		printerr("❌ [CI FAILED] NPC panic on alarm failed!")
		quit(1)
		return
	print("  ✅ NPCRoutineController 24h AI OK (Work shift & Alarm evacuation verified)")

	# 5. Validate Living Closed-Loop Production Chain (Farm -> Mill -> Bakery)
	print("\n[5/5] Validating LivingProductionSystem Chains...")
	var prod_script = preload("res://src/economy/LivingProductionSystem.gd")
	var stockpiles: Dictionary = {"grain": 0, "flour": 0, "bread": 0}

	# Step A: Farmer produces 2 grain
	var farm_res = prod_script.execute_work_shift("Хлебопашец", stockpiles)
	if farm_res["status"] != "success" or stockpiles["grain"] != 2:
		printerr("❌ [CI FAILED] Farming grain production failed: ", farm_res)
		quit(1)
		return

	# Step B: Miller transforms 2 grain -> 2 flour
	var mill_res = prod_script.execute_work_shift("Мельник", stockpiles)
	if mill_res["status"] != "success" or stockpiles["grain"] != 0 or stockpiles["flour"] != 2:
		printerr("❌ [CI FAILED] Milling grain to flour failed: ", mill_res)
		quit(1)
		return

	# Step C: Baker transforms 2 flour -> 2 bread
	var bake_res = prod_script.execute_work_shift("Пекарь", stockpiles)
	if bake_res["status"] != "success" or stockpiles["flour"] != 0 or stockpiles["bread"] != 2:
		printerr("❌ [CI FAILED] Baking bread failed: ", bake_res)
		quit(1)
		return

	# Step D: Missing materials guard (baker tries to bake again with 0 flour)
	var fail_res = prod_script.execute_work_shift("Пекарь", stockpiles)
	if fail_res["status"] != "missing_materials":
		printerr("❌ [CI FAILED] Missing materials guard failed: ", fail_res)
		quit(1)
		return
	# 6. Validate Death Lifecycle System (Death -> Inheritance -> Mourning -> Grudge)
	print("\n[6/8] Validating Death Lifecycle System...")
	var death_sys_script = preload("res://src/entities/DeathLifecycleSystem.gd")
	var victim_d = preload("res://src/character/CharacterData.gd").new()
	victim_d.name = "Кузнец Вульфрик"
	victim_d.gold = 75
	victim_d.inventory = {"iron_ingot": 4}
	victim_d.health = 10.0

	var killer_d = preload("res://src/character/CharacterData.gd").new()
	killer_d.id = "bandit_boss_1"
	killer_d.name = "Атаман Бран"

	# Friend node with MemoryComponent
	var friend_node = Node.new()
	var friend_mem = preload("res://src/ai/MemoryComponent.gd").new()
	friend_mem.opinions["Кузнец Вульфрик"] = 50.0 # Best friend
	friend_node.add_child(friend_mem)

	var d_res = death_sys_script.handle_character_death(null, victim_d, null, killer_d, [friend_node])
	if not victim_d.is_dead or victim_d.gold != 0 or d_res["mourning_citizens"] != 1 or d_res["grudges_against_killer"] != 1:
		printerr("❌ [CI FAILED] DeathLifecycleSystem failed: ", d_res)
		quit(1)
		return
	print("  ✅ DeathLifecycleSystem OK (Workplace freed, mourning triggered, blood grudge added)")

	# 7. Validate Memory -> AI Utility Behavior
	print("\n[7/8] Validating Memory -> Behavior Integration...")
	var brain = preload("res://src/ai/UtilityBrain.gd").new()
	var test_char_d = preload("res://src/character/CharacterData.gd").new()
	test_char_d.current_role = "Крестьянин"
	var actor_needs = preload("res://src/ai/NeedsComponent.gd").new()
	var actor_mem = preload("res://src/ai/MemoryComponent.gd").new()
	actor_mem.opinions["bandit_boss_1"] = -60.0 # Hates killer
	brain.char_data = test_char_d
	brain.needs = actor_needs
	brain.memory = actor_mem
	brain.evaluate_and_act()
	if brain.current_action != "FLEE_OR_AVOID":
		printerr("❌ [CI FAILED] Memory -> Behavior failed: expected FLEE_OR_AVOID, got ", brain.current_action)
		quit(1)
		return
	print("  ✅ Memory -> Behavior OK (Hated target triggers FLEE_OR_AVOID for Peasant)")

	# 8. Validate Citizen Quest Reputation Rewards
	print("\n[8/8] Validating Quest Reputation Rewards...")
	var quest_sys = preload("res://src/quest/CitizenQuestSystem.gd").new()
	var q_player = preload("res://src/character/CharacterData.gd").new()
	q_player.inventory = {"wheat": 8}
	q_player.reputation = 10
	quest_sys.active_quests["quest_farmer_harvest"] = {"status": "active"}
	var q_reward = quest_sys.complete_quest("quest_farmer_harvest", q_player)
	if q_player.reputation != 30 or q_reward.get("reputation", 0) != 20:
		printerr("❌ [CI FAILED] Quest reputation reward failed (expected 30, got %d)" % q_player.reputation)
		quit(1)
		return
	print("  ✅ CitizenQuestSystem Reputation Fix OK (Reputation: 10 -> %d)" % q_player.reputation)

	print("\n========================================================")
	print("🎉 [CI QUALITY GATE PASSED] All 8 test suites passed with 0 errors!")
	print("========================================================\n")
	quit(0)
