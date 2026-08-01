/** Типы данных из src/data/*.json */

/** Элемент цепочки слияния (один тир). */
export interface ChainItem {
  tier: number;
  id: string;
  name: string;
}

/** Цепочка слияния: тиры от 1 до max. */
export interface Chain {
  id: string;
  name: string;
  items: ChainItem[];
}

/** Корень chains.json. */
export interface ChainsData {
  chains: Record<string, Chain>;
}

/** Генератор предметов (лейка и т.п.). */
export interface Generator {
  id: string;
  name: string;
  chainId: string;
  itemId: string;
  cooldownSec: number;
}

/** Заказ: нужен предмет itemId тира tier, награда монетами. */
export interface OrderData {
  id: string;
  itemId: string;
  tier: number;
  rewardCoins: number;
}
