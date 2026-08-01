import { CONFIG } from '../config';
import type { Chain, ChainItem, ChainsData, Generator } from '../types/game';

/** База цепочек слияния. Чистая логика, без Phaser. */
export class ItemDB {
  private chains = new Map<string, Chain>();
  private generators: Generator[] = [];
  private itemIndex = new Map<string, { chain: Chain; index: number }>();

  /** Загружает цепочки; возвращает количество цепочек. */
  load(data: ChainsData): number {
    this.chains.clear();
    this.itemIndex.clear();
    for (const chain of Object.values(data.chains)) {
      this.chains.set(chain.id, chain);
      chain.items.forEach((item, index) => this.itemIndex.set(item.id, { chain, index }));
    }
    return this.chains.size;
  }

  loadGenerators(list: Generator[]): void {
    this.generators = list;
  }

  getChain(id: string): Chain | undefined {
    return this.chains.get(id);
  }

  getItem(itemId: string): ChainItem | undefined {
    const entry = this.itemIndex.get(itemId);
    return entry ? entry.chain.items[entry.index] : undefined;
  }

  getNextTier(itemId: string): ChainItem | undefined {
    const entry = this.itemIndex.get(itemId);
    if (!entry) return undefined;
    return entry.chain.items[entry.index + 1];
  }

  isMaxTier(itemId: string): boolean {
    const entry = this.itemIndex.get(itemId);
    return !entry || entry.index === entry.chain.items.length - 1;
  }

  getGeneratorFor(itemId: string): Generator | undefined {
    return this.generators.find((g) => g.itemId === itemId);
  }

  mergeCount(): number {
    return CONFIG.mergeCount;
  }
}
