extends Node

## EventBus: Центральная шина событий для слабой связности систем (Decoupled Signal Architecture)

# Временные сигналы
signal minute_passed(current_minute: int, current_hour: int)
signal hour_passed(current_hour: int, current_day: int)
signal day_passed(current_day: int, current_season: String)
signal season_passed(new_season: String, current_year: int)

# Сигналы персонажей и потребностей
signal character_spawned(character: Node)
signal character_died(character: Node, killer: Node)
signal character_role_changed(character: Node, old_role: String, new_role: String)
signal need_critical(character: Node, need_name: String, current_value: float)

# Социальные отношения и память
signal opinion_changed(from_char: Node, target_char: Node, delta: float, new_value: float)
signal social_interaction_occurred(initiator: Node, receiver: Node, action_type: String, result: Dictionary)

# Преступления и закон
signal crime_committed(perpetrator: Node, victim: Node, crime_type: String, severity: int)
signal crime_witnessed(witness: Node, perpetrator: Node, crime_type: String)
signal bounty_placed(target: Node, amount: int, issuer: Node)

# Экономика и торговля
signal transaction_completed(buyer: Node, seller: Node, item_id: String, count: int, total_price: float)
signal market_shortage_detected(market_node: Node, item_id: String)
signal price_fluctuated(item_id: String, old_price: float, new_price: float)

# Политика и титулы
signal title_granted(recipient: Node, title_name: String, fief_name: String)
signal title_usurped(usurper: Node, former_holder: Node, title_name: String)
signal war_declared(aggressor_faction: String, defender_faction: String)
signal peace_signed(faction_a: String, faction_b: String)
