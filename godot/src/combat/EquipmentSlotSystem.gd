class_name EquipmentSlotSystem
extends RefCounted

## СИСТЕМА 8 СЛОТОВ ЭКИПИРОВКИ ПЕРСОНАЖА (PAPERDOLL EQUIPMENT)
## Управляет слотами шлема, брони, перчаток, сапог, оружия, щита, кольца и амулета

# equipped_slots: slot_name -> item_id (String)
var equipped_slots: Dictionary = {
	"head": "helmet_iron",
	"chest": "armor_chainmail",
	"hands": "gauntlets_plate",
	"feet": "boots_leather",
	"weapon": "sword_iron",
	"shield": "shield_heater",
	"ring": "ring_undying",
	"amulet": "amulet_sun"
}

const SLOT_NAMES_RU := {
	"head": "🪖 Шлем",
	"chest": "🛡️ Нагрудная Броня",
	"hands": "🧤 Рукавицы",
	"feet": "👢 Сапоги",
	"weapon": "⚔️ Оружие",
	"shield": "🛡️ Щит",
	"ring": "💍 Кольцо",
	"amulet": "📿 Амулет"
}

func equip_item(slot: String, item_id: String) -> Dictionary:
	if not equipped_slots.has(slot):
		return {"success": false, "msg": "Неверный слот экипировки."}
		
	var old_item = equipped_slots[slot]
	equipped_slots[slot] = item_id
	
	return {
		"success": true,
		"slot": slot,
		"old_item": old_item,
		"new_item": item_id,
		"msg": "✨ Экипирован предмет в слот %s: %s!" % [SLOT_NAMES_RU.get(slot, slot), item_id]
	}

func unequip_slot(slot: String) -> String:
	if not equipped_slots.has(slot): return ""
	var it = equipped_slots[slot]
	equipped_slots[slot] = ""
	return it

func get_total_armor() -> int:
	var total = 0
	if equipped_slots["head"] != "": total += 12
	if equipped_slots["chest"] != "": total += 25
	if equipped_slots["hands"] != "": total += 8
	if equipped_slots["feet"] != "": total += 5
	return total

func get_total_damage() -> int:
	var w = equipped_slots.get("weapon", "")
	if w == "sword_paladin_sun": return 28
	elif w == "sword_iron": return 16
	elif w == "damascus_sword": return 22
	elif w == "axe_iron": return 18
	elif w == "bow_hunting": return 15
	return 8 # Кулаки

func get_speed_multiplier() -> float:
	var mult = 1.0
	if equipped_slots.get("feet", "") == "boots_leather":
		mult += 0.10 # +10% скорости от легких сапог
	return mult

func get_summary_text() -> String:
	var lines: Array[String] = []
	for s in ["head", "chest", "hands", "feet", "weapon", "shield", "ring", "amulet"]:
		var it = equipped_slots.get(s, "—")
		if it == "": it = "— (Пусто)"
		lines.append("%s: [color=gold]%s[/color]" % [SLOT_NAMES_RU[s], it])
	return "\n".join(lines)
