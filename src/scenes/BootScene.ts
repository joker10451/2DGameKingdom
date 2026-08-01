import Phaser from 'phaser';
import { CONFIG } from '../config';
import chainsUrl from '../data/chains.json?url';
import generatorsUrl from '../data/generators.json?url';
import ordersUrl from '../data/orders.json?url';
import renovationUrl from '../data/renovation.json?url';
import tutorialUrl from '../data/tutorial.json?url';
import { bus, economy, itemDB, orderSystem, saveSystem, yandex } from '../systems';
import { BOOT_READY } from '../systems/events';
import type { ChainsData, Generator, OrderData } from '../types/game';

/** Загрузочная сцена: текст «loading», подъём JSON, инициализация систем. */
export class BootScene extends Phaser.Scene {
  constructor() {
    super('Boot');
  }

  preload(): void {
    const { width, height } = CONFIG;
    this.add
      .text(width / 2, height / 2, 'loading', {
        fontFamily: 'Arial',
        fontSize: '48px',
        color: '#6b5b3e',
      })
      .setOrigin(0.5);

    this.load.json('chains', chainsUrl);
    this.load.json('generators', generatorsUrl);
    this.load.json('orders', ordersUrl);
    this.load.json('renovation', renovationUrl);
    this.load.json('tutorial', tutorialUrl);
  }

  create(): void {
    const chainsCount = itemDB.load(this.cache.json.get('chains') as ChainsData);
    itemDB.loadGenerators(this.cache.json.get('generators') as Generator[]);
    orderSystem.load(this.cache.json.get('orders') as OrderData[]);
    console.log('ItemDB loaded:', chainsCount, 'chains');

    saveSystem.load();
    void yandex.init();
    bus.emit(BOOT_READY);
  }

  update(_time: number, delta: number): void {
    economy.update(delta);
  }
}
