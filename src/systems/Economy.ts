import { CONFIG } from '../config';
import { bus } from './EventBus';
import { COINS_CHANGED, ENERGY_CHANGED, ENERGY_SHORTAGE } from './events';

/** Экономика: монеты и энергия. Регенерацию двигает update(deltaMs) из сцены. */
export class Economy {
  private _coins: number = 0;
  private _energy: number = CONFIG.energy.start;

  get coins(): number {
    return this._coins;
  }

  get energy(): number {
    return this._energy;
  }

  addCoins(amount: number): void {
    this._coins += amount;
    bus.emit(COINS_CHANGED, this._coins);
  }

  spendCoins(amount: number): boolean {
    if (this._coins < amount) return false;
    this._coins -= amount;
    bus.emit(COINS_CHANGED, this._coins);
    return true;
  }

  canAffordEnergy(amount: number): boolean {
    return this._energy >= amount;
  }

  spendEnergy(amount: number): boolean {
    if (this._energy < amount) {
      bus.emit(ENERGY_SHORTAGE, amount);
      return false;
    }
    this._energy -= amount;
    bus.emit(ENERGY_CHANGED, this._energy);
    return true;
  }

  addEnergy(amount: number): void {
    this._energy = Math.min(CONFIG.energy.max, this._energy + amount);
    bus.emit(ENERGY_CHANGED, this._energy);
  }

  /** Регенерация энергии. Вызывается из update() сцены, не setInterval. */
  update(deltaMs: number): void {
    if (this._energy >= CONFIG.energy.max) return;
    this._energy = Math.min(CONFIG.energy.max, this._energy + deltaMs / 1000 / CONFIG.energy.regenSec);
    bus.emit(ENERGY_CHANGED, this._energy);
  }
}
