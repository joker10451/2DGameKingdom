import Phaser from 'phaser';
import { CONFIG } from './config';
import { BootScene } from './scenes/BootScene';

new Phaser.Game({
  type: Phaser.AUTO,
  width: CONFIG.width,
  height: CONFIG.height,
  parent: 'game',
  backgroundColor: '#f4f1e8',
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  scene: [BootScene],
});
