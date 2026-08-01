import type { OrderData } from '../types/game';
import type { Economy } from './Economy';
import { bus } from './EventBus';
import { ORDER_COMPLETED } from './events';

/** Активные заказы: приём предметов с доски и выдача наград. */
export class OrderSystem {
  private orders: OrderData[] = [];

  constructor(private economy: Economy) {}

  load(list: OrderData[]): void {
    this.orders = list;
  }

  get active(): OrderData[] {
    return this.orders;
  }

  trySubmit(itemId: string, tier: number): boolean {
    const index = this.orders.findIndex((o) => o.itemId === itemId && o.tier === tier);
    if (index === -1) return false;
    const [order] = this.orders.splice(index, 1);
    this.economy.addCoins(order.rewardCoins);
    bus.emit(ORDER_COMPLETED, order);
    return true;
  }

  /** TODO: подтянуть следующий заказ из пула (задача «Заказы»). */
  next(): void {
    // stub
  }
}
