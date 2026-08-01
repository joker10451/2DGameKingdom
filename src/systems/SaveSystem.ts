import { SAVE_KEY } from '../config';
import { bus } from './EventBus';
import { SAVE_CHANGED, SAVE_LOADED } from './events';

/** Сохранение в localStorage. Облако — в YandexBridge. */
export class SaveSystem {
  private data: Record<string, unknown> = {};
  private dirty = false;

  get(): Record<string, unknown> {
    return this.data;
  }

  set(key: string, value: unknown): void {
    this.data[key] = value;
    this.dirty = true;
    bus.emit(SAVE_CHANGED, key, value);
  }

  markDirty(): void {
    this.dirty = true;
  }

  get isDirty(): boolean {
    return this.dirty;
  }

  saveNow(): void {
    localStorage.setItem(SAVE_KEY, JSON.stringify(this.data));
    this.dirty = false;
  }

  load(): Record<string, unknown> {
    try {
      const raw = localStorage.getItem(SAVE_KEY);
      if (raw) this.data = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      this.data = {};
    }
    bus.emit(SAVE_LOADED, this.data);
    return this.data;
  }

  reset(): void {
    localStorage.removeItem(SAVE_KEY);
    this.data = {};
    this.dirty = false;
  }
}
