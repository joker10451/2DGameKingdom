import type { YaGamesSdk } from '../types/yandex';
import { bus } from './EventBus';
import { INTERSTITIAL_CLOSED, REWARDED_GRANTED } from './events';

/** Обёртка SDK Яндекс Игр. Локально (нет window.YaGames) эмулирует успех. */
export class YandexBridge {
  private sdk: YaGamesSdk | null = null;

  get isReady(): boolean {
    return this.sdk !== null;
  }

  private isAvailable(): boolean {
    return typeof window !== 'undefined' && typeof window.YaGames !== 'undefined';
  }

  async init(): Promise<void> {
    if (!this.isAvailable()) {
      console.warn('[YandexBridge] SDK отсутствует (локальный режим) — эмуляция');
      return;
    }
    this.sdk = await window.YaGames.init();
    this.sdk.features?.LoadingAPI?.ready();
    console.log('[YandexBridge] SDK инициализирован');
  }

  showRewarded(reason: string): void {
    if (!this.sdk) {
      bus.emit(REWARDED_GRANTED, reason);
      return;
    }
    this.sdk.adv.showRewardedVideo({
      callbacks: {
        onRewarded: () => bus.emit(REWARDED_GRANTED, reason),
        onClose: () => {},
        onError: () => {},
      },
    });
  }

  showInterstitial(): void {
    if (!this.sdk) {
      bus.emit(INTERSTITIAL_CLOSED);
      return;
    }
    this.sdk.adv.showFullscreenAdv({
      callbacks: {
        onClose: () => bus.emit(INTERSTITIAL_CLOSED),
        onError: () => {},
      },
    });
  }

  async saveCloud(dict: Record<string, unknown>): Promise<void> {
    if (!this.sdk) return;
    const player = await this.sdk.getPlayer();
    await player.setData(dict, true);
  }

  async loadCloud(): Promise<Record<string, unknown>> {
    if (!this.sdk) return {};
    const player = await this.sdk.getPlayer();
    return player.getData();
  }
}
