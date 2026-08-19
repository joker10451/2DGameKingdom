class_name TownCouncilSystem
extends RefCounted

## СОВЕТ ПОСЕЛЕНИЯ И НАЗНАЧЕНИЕ ДОЛЖНОСТЕЙ
## Управляет назначением жителей на посты Капитана Стражи, Казначея, Старосты и Судьи

# council: office_id -> {title: String, icon: String, holder_name: String, bonus_desc: String}
var council: Dictionary = {
	"captain_guard": {
		"title": "Капитан Стражи",
		"icon": "🛡️",
		"holder_name": "Вульфрик Железный",
		"bonus": "+30% к защите деревни и скорость обучения ополчения"
	},
	"treasurer": {
		"title": "Казначей Поселения",
		"icon": "🪙",
		"holder_name": "Изольда Лесник",
		"bonus": "+15% к сбору податей, защита от коррупции"
	},
	"bailiff": {
		"title": "Староста / Управляющий",
		"icon": "🌾",
		"holder_name": "Радмир Пахарь",
		"bonus": "+25% к урожаю на всех фермах и полях"
	},
	"magistrate": {
		"title": "Судья / Магистрат",
		"icon": "⚖️",
		"holder_name": "Хильда Знахарка",
		"bonus": "-50% к беспорядкам, стабильный общественный порядок"
	}
}

func appoint_official(office_id: String, npc_name: String) -> Dictionary:
	if not council.has(office_id):
		return {"success": false, "msg": "Неизвестная должность."}
		
	council[office_id]["holder_name"] = npc_name
	var c = council[office_id]
	return {
		"success": true,
		"msg": "👑 НАЗНАЧЕНИЕ: %s %s теперь занимает должность «%s» (%s)!" % [c["icon"], npc_name, c["title"], c["bonus"]]
	}

func dismiss_official(office_id: String) -> Dictionary:
	if not council.has(office_id): return {"success": false}
	var old = council[office_id]["holder_name"]
	council[office_id]["holder_name"] = "— (Вакантно)"
	return {
		"success": true,
		"msg": "Должность «%s» освобождена (ранее занимал: %s)." % [council[office_id]["title"], old]
	}

func get_council_text() -> String:
	var lines: Array[String] = []
	for off_id in ["captain_guard", "treasurer", "bailiff", "magistrate"]:
		var c = council[off_id]
		lines.append("%s [b]%s[/b]: [color=gold]%s[/color]\n   [color=gray]Эффект: %s[/color]" % [c["icon"], c["title"], c["holder_name"], c["bonus"]])
	return "\n".join(lines)
