import Phaser from 'phaser';

/** Глобальная шина событий: системы общаются со сценами через неё. */
export const bus = new Phaser.Events.EventEmitter();
