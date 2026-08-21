class_name ContractManager
extends RefCounted

## МЕНЕДЖЕР ФЕОДАЛЬНЫХ КОНТРАКТОВ И РЕПУТАЦИИ

static func ensure_player_contracts(p: CharacterData) -> void:
	if not p: return
	if not p.get('active_contracts'):
		p.set('active_contracts', [])
	if not p.get('completed_contract_ids'):
		p.set('completed_contract_ids', [])
	if not p.get('faction_reputation') or p.get('faction_reputation').is_empty():
		p.set('faction_reputation', {
			'crown': 0,
			'merchants': 0,
			'peasants': 10,
			'outlaws': 0
		})

static func get_available_contracts(p: CharacterData) -> Array[Dictionary]:
	ensure_player_contracts(p)
	var active_ids: Array = []
	for c in p.active_contracts:
		active_ids.append(c.get('id', ''))
	
	var res: Array[Dictionary] = []
	for id in ContractDatabase.get_all_contract_ids():
		if id not in active_ids and id not in p.completed_contract_ids:
			var c = ContractDatabase.get_contract(id)
			var req_ren = c.get('req_renown', 0)
			if p.renown >= req_ren:
				res.append(c)
	return res

static func accept_contract(p: CharacterData, contract_id: String) -> bool:
	ensure_player_contracts(p)
	for c in p.active_contracts:
		if c.get('id') == contract_id:
			return false
			
	var contract = ContractDatabase.get_contract(contract_id)
	if contract.is_empty():
		return false
		
	# Если это контракт на поставку, проверяем текущее количество предметов в инвентаре
	if contract.get('category') == 'supply':
		var item_id = contract.get('target_type', '')
		contract['current_count'] = p.inventory.get(item_id, 0)
		
	p.active_contracts.append(contract)
	return true

static func update_progress(p: CharacterData, category: String, target_type: String, amount: int = 1) -> Array:
	ensure_player_contracts(p)
	var completed_now: Array = []
	
	for c in p.active_contracts:
		if c.get('category') == category and c.get('target_type') == target_type:
			var req = c.get('required_count', 1)
			var cur = c.get('current_count', 0) + amount
			c['current_count'] = clampi(cur, 0, req)
			if c['current_count'] >= req and not c.get('is_ready_to_turn_in', false):
				c['is_ready_to_turn_in'] = true
				completed_now.append(c)
				
	return completed_now

static func sync_supply_contracts(p: CharacterData) -> void:
	ensure_player_contracts(p)
	for c in p.active_contracts:
		if c.get('category') == 'supply':
			var item_id = c.get('target_type', '')
			var count = p.inventory.get(item_id, 0)
			c['current_count'] = count
			c['is_ready_to_turn_in'] = (count >= c.get('required_count', 1))

static func claim_reward(p: CharacterData, contract_id: String) -> Dictionary:
	ensure_player_contracts(p)
	var target_idx := -1
	for i in range(p.active_contracts.size()):
		if p.active_contracts[i].get('id') == contract_id:
			target_idx = i
			break
			
	if target_idx == -1:
		return {}
		
	var c = p.active_contracts[target_idx]
	sync_supply_contracts(p)
	
	if c.get('current_count', 0) < c.get('required_count', 1):
		return {}
		
	# Списываем предметы, если это контракт на поставку
	if c.get('category') == 'supply':
		var item_id = c.get('target_type', '')
		var req = c.get('required_count', 1)
		p.remove_item(item_id, req)
		
	var rewards = c.get('rewards', {})
	var gold_reward = rewards.get('gold', 0)
	var renown_reward = rewards.get('renown', 0)
	var rep_rewards: Dictionary = rewards.get('reputation', {})
	
	p.gold += gold_reward
	p.renown += renown_reward
	
	var rep_dict: Dictionary = p.get('faction_reputation')
	for f_id in rep_rewards.keys():
		var delta = rep_rewards[f_id]
		rep_dict[f_id] = rep_dict.get(f_id, 0) + delta
	p.set('faction_reputation', rep_dict)
	
	# Начисление опыта навыков
	var xp_dict: Dictionary = rewards.get('xp', {})
	for skill_id in xp_dict.keys():
		SkillSystem.add_skill_xp(p.skills, skill_id, xp_dict[skill_id])
		
	p.completed_contract_ids.append(contract_id)
	p.active_contracts.remove_at(target_idx)
	
	return {
		'contract': c,
		'gold': gold_reward,
		'renown': renown_reward,
		'reputation': rep_rewards,
		'xp': xp_dict
	}

static func abandon_contract(p: CharacterData, contract_id: String) -> bool:
	ensure_player_contracts(p)
	for i in range(p.active_contracts.size()):
		if p.active_contracts[i].get('id') == contract_id:
			p.active_contracts.remove_at(i)
			return true
	return false
