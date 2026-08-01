/**
 * Ambient-типы SDK Яндекс Игр (официальных типов нет).
 * Файл — модуль, поэтому declare global объявляет Window глобально,
 * а сам интерфейс YaGamesSdk импортируется оттуда, где нужен.
 */
export interface YaGamesSdk {
  adv: {
    showRewardedVideo(o: {
      callbacks: {
        onRewarded?: () => void;
        onClose?: () => void;
        onError?: () => void;
      };
    }): void;
    showFullscreenAdv(o: {
      callbacks: {
        onClose?: () => void;
        onError?: () => void;
      };
    }): void;
  };
  getPlayer(): Promise<{
    setData(d: Record<string, unknown>, flush?: boolean): Promise<void>;
    getData(keys?: string[]): Promise<Record<string, unknown>>;
  }>;
  features?: {
    LoadingAPI?: {
      ready(): void;
    };
  };
}

declare global {
  interface Window {
    YaGames: {
      init(): Promise<YaGamesSdk>;
    };
    ysdk?: YaGamesSdk;
  }
}

export {};
