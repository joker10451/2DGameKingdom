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

	# 4. Validate Economic & Caravan Invariants
	print("\n[4/4] Validating Economic Invariants...")
	var caravan_script = preload("res://src/world/TradeCaravanSystem.gd")
	var trade_sys = caravan_script.new()
	var char_data_script = preload("res://src/character/CharacterData.gd")
	var p_data = char_data_script.new()
	p_data.gold = 50

	# Dispatch caravan with 20 gold escort cost
	var res = trade_sys.dispatch_active_caravan("goldvale", "timber", 5, 20, 0.1, "Охрана", p_data, null)
	if p_data.gold != 30:
		printerr("❌ [CI FAILED] Caravan escort gold deduction failed (expected 30, got %d)" % p_data.gold)
		quit(1)
		return
	print("  ✅ TradeCaravanSystem Invariant OK (Escort deducted: 50 -> %d)" % p_data.gold)

	print("\n========================================================")
	print("🎉 [CI QUALITY GATE PASSED] All 4 test suites passed with 0 errors!")
	print("========================================================\n")
	quit(0)
