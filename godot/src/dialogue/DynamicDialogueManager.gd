class_name DynamicDialogueManager
extends RefCounted

## Генератор контекстных диалогов на основе памяти, потребностей и роли NPC

static func generate_dialogue(npc: Node, player_data: CharacterData) -> Dictionary:
	var data: CharacterData = npc.get("data")
	var needs: NeedsComponent = npc.get_node_or_null("NeedsComponent")
	var memory: MemoryComponent = npc.get_node_or_null("MemoryComponent")
	
	if not data or not needs:
		return {
			"greeting": "Здравствуй, путник.",
			"options": [{"text": "Уйти", "action": "close"}]
		}
	
	var opinion = memory.get_opinion("player") if memory else 0.0
	var greeting = ""
	var options = []
	
	# 1. Проверка на вражду и обиды в памяти
	if memory and memory.has_grudge_against("player"):
		greeting = "Убирайся с моих глаз, вор! Я помню, что ты натворил!"
		options.append({"text": "[Угрожать оружием]", "action": "threaten"})
		options.append({"text": "[Извиниться и заплатить 10 зол.]", "action": "pay_weregild"})
		options.append({"text": "Уйти", "action": "close"})
		return {"greeting": greeting, "options": options}
	
	# 2. Реакция на критические потребности
	if needs.hunger >= 75.0:
		greeting = "Ох... В животе пусто со вчерашнего утра. В деревне совсем не осталось хлеба..."
		if player_data.get_item_count("bread") > 0:
			options.append({"text": "«Держи кусок хлеба» (Поделиться едой)", "action": "give_bread"})
	elif needs.fatigue >= 80.0:
		greeting = "Глаза слипаются после работы... Дай мне хоть час поспать."
	else:
		# 3. Реплика в зависимости от роли и статуса игрока
		match data.current_role:
			"Крестьянин":
				if player_data.current_role == "Лорд" or player_data.current_role == "Король":
					greeting = "Кланяюсь вам, милорд! Урожай в этом году неплохой, оброк будет в срок."
					options.append({"text": "«Увеличить налог на 20%»", "action": "raise_tax"})
				elif player_data.current_role == "Бандит":
					greeting = "Пощадите, добрый человек! У меня только мешок зерна для детей..."
					options.append({"text": "«Отдавай зерно и монеты!» (Ограбить)", "action": "rob_npc"})
				else:
					greeting = "Здравствуй, сосед. Земля нынче сухая, тяжело пахать."
					options.append({"text": "«Купить зерно у тебя напрямую»", "action": "buy_direct_grain"})
			"Торговец":
				greeting = "Приветствую! У меня лучшие цены отсюда до самого Стального Предела. Что ищешь?"
				options.append({"text": "[Открыть торговлю]", "action": "open_trade"})
				options.append({"text": "«Какие цены в других городах?» (Слухи о рынке)", "action": "trade_rumors"})
			"Стражник":
				if player_data.honor < -20:
					greeting = "Стой! Твое лицо мне не нравится. Держи руки на виду."
					options.append({"text": "[Подкупить стражника: 15 зол.]", "action": "bribe_guard"})
				else:
					greeting = "В поселении все спокойно. Закон лорда блюдется строго."
					options.append({"text": "«Где прячутся разбойники?» (Взять контракт)", "action": "bounty_quest"})
			"Бандит":
				greeting = "Чего вылупился? Кошелек или жизнь, путник!"
				options.append({"text": "[Обнажить меч и атаковать]", "action": "attack_npc"})
				options.append({"text": "«Я сам вне закона. Возьмите меня в шайку!»", "action": "join_bandits"})
			"Лорд":
				greeting = "Говори быстрее, простолюдин. Дела графства не ждут."
				if player_data.renown >= 100 and player_data.current_role != "Лорд":
					options.append({"text": "«Я хочу присягнуть вам на верность и стать рыцарем»", "action": "swear_fealty"})
				options.append({"text": "«Оплатить пошлину за право торговли»", "action": "pay_tax"})
	
	# Общие опции
	options.append({"text": "«Что нового слышно?» (Сплетни и новости)", "action": "ask_gossip"})
	options.append({"text": "«Бывай.» (Уйти)", "action": "close"})
	
	return {"greeting": greeting, "options": options}
