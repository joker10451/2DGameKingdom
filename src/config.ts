/** Единая точка конфигурации. Все числа игры — здесь или в src/data/*.json. */
export const CONFIG = {
  width: 720,
  height: 1280,
  grid: {
    cols: 8,
    rows: 10,
    cell: 96,
  },
  mergeCount: 2,
  energy: {
    max: 100,
    regenSec: 30,
    start: 100,
  },
} as const;

export type GridConfig = typeof CONFIG.grid;
export type EnergyConfig = typeof CONFIG.energy;
export type AppConfig = typeof CONFIG;

/** Ключ локального сохранения. */
export const SAVE_KEY = 'babuskin_dacha_save';
