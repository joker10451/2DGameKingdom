import { Economy } from './Economy';
import { GameManager } from './GameManager';
import { ItemDB } from './ItemDB';
import { OrderSystem } from './OrderSystem';
import { SaveSystem } from './SaveSystem';
import { YandexBridge } from './YandexBridge';

/** Синглтоны систем: сцены и код используют только эти экземпляры. */
export const itemDB = new ItemDB();
export const economy = new Economy();
export const orderSystem = new OrderSystem(economy);
export const saveSystem = new SaveSystem();
export const yandex = new YandexBridge();
export const gameManager = new GameManager();

export * from './EventBus';
export * from './events';
