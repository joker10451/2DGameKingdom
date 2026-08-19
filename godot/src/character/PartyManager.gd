class_name PartyManager
extends RefCounted

## МЕНЕДЖЕР ДРУЖИНЫ И СПУТНИКОВ

const PartyDatabase = preload("res://src/character/PartyDatabase.gd")
const MAX_PARTY_SIZE := 3

static func ensure_player_party(p: CharacterData) -> void:
	if not p: return
	if not p.get('party_members'):
		p.set('party_members', [])

static func get_available_mercenaries(p: CharacterData) -> Array[Dictionary]:
	ensure_player_party(p)
	var current_ids: Array = []
	for m in p.party_members:
		current_ids.append(m.get('id', ''))
		
	var result: Array[Dictionary] = []
	for id in PartyDatabase.get_all_mercenary_ids():
		if id not in current_ids:
			result.append(PartyDatabase.get_mercenary(id))
	return result

static func hire_mercenary(p: CharacterData, merc_id: String) -> Dictionary:
	ensure_player_party(p)
	if p.party_members.size() >= MAX_PARTY_SIZE:
		return {'success': false, 'reason': 'Отряд уже полон (макс. 3 спутника)!'}
		
	var merc = PartyDatabase.get_mercenary(merc_id)
	if merc.is_empty():
		return {'success': false, 'reason': 'Наемник не найден!'}
		
	var cost = merc.get('hire_cost', 30)
	if p.gold < cost:
		return {'success': false, 'reason': 'Недостаточно золота для найма (требуется %d з.)!' % cost}
		
	p.gold -= cost
	p.party_members.append(merc)
	return {'success': true, 'mercenary': merc}

static func dismiss_mercenary(p: CharacterData, merc_id: String) -> bool:
	ensure_player_party(p)
	for i in range(p.party_members.size()):
		if p.party_members[i].get('id') == merc_id:
			p.party_members.remove_at(i)
			return true
	return false

static func get_total_daily_wages(p: CharacterData) -> int:
	ensure_player_party(p)
	var total := 0
	for m in p.party_members:
		total += m.get('daily_wage', 5)
	return total

static func pay_daily_wages(p: CharacterData) -> Dictionary:
	ensure_player_party(p)
	if p.party_members.size() == 0:
		return {'paid': 0, 'dismissed': []}
		
	var total_wage = get_total_daily_wages(p)
	if p.gold >= total_wage:
		p.gold -= total_wage
		return {'paid': total_wage, 'dismissed': []}
	else:
		# Если золота не хватает на всех, распускаем спутников
		var dismissed_names: Array = []
		while p.party_members.size() > 0 and p.gold < get_total_daily_wages(p):
			var removed = p.party_members.pop_back()
			dismissed_names.append(removed.get('name', 'Наемник'))
			
		var final_wage = get_total_daily_wages(p)
		p.gold = maxi(0, p.gold - final_wage)
		return {'paid': final_wage, 'dismissed': dismissed_names}
