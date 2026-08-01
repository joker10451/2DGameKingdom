import { bus } from './EventBus';
import { META_CHANGED } from './events';

export type GameMode = 'BOARD' | 'META';

/** Переключение режимов игры: доска / обустройство дачи. */
export class GameManager {
  private mode: GameMode = 'BOARD';

  get currentMode(): GameMode {
    return this.mode;
  }

  gotoBoard(): void {
    this.setMode('BOARD');
  }

  gotoMeta(): void {
    this.setMode('META');
  }

  private setMode(mode: GameMode): void {
    if (this.mode === mode) return;
    this.mode = mode;
    bus.emit(META_CHANGED, mode);
  }
}
