import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SAMPLE_RATE = 44100;

function createWavBuffer(samples, sampleRate = SAMPLE_RATE) {
  const numChannels = 1;
  const bitsPerSample = 16;
  const byteRate = (sampleRate * numChannels * bitsPerSample) / 8;
  const blockAlign = (numChannels * bitsPerSample) / 8;
  const dataLength = samples.length * 2;
  const buffer = Buffer.alloc(44 + dataLength);

  // RIFF identifier
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(36 + dataLength, 4);
  buffer.write('WAVE', 8);
  buffer.write('fmt ', 12);
  buffer.writeUInt32LE(16, 16); // SubChunk1Size (16 for PCM)
  buffer.writeUInt16LE(1, 20); // AudioFormat (1 for PCM)
  buffer.writeUInt16LE(numChannels, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(byteRate, 28);
  buffer.writeUInt16LE(blockAlign, 32);
  buffer.writeUInt16LE(bitsPerSample, 34);
  buffer.write('data', 36);
  buffer.writeUInt32LE(dataLength, 40);

  // Write PCM samples
  for (let i = 0; i < samples.length; i++) {
    const s = Math.max(-1, Math.min(1, samples[i]));
    const val = s < 0 ? s * 0x8000 : s * 0x7fff;
    buffer.writeInt16LE(Math.round(val), 44 + i * 2);
  }

  return buffer;
}

// DSP Generators
function generateShoot(duration = 0.22) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 18);
    // FM synthesis for laser/plasma snap
    const mod = Math.sin(2 * Math.PI * 45 * t) * 800 * env;
    const carrierFreq = 950 * Math.exp(-t * 22) + mod;
    const tone = Math.sin(2 * Math.PI * carrierFreq * t);
    const noise = (Math.random() * 2 - 1) * Math.exp(-t * 35) * 0.4;
    samples[i] = (tone * 0.7 + noise) * env * 0.8;
  }
  return samples;
}

function generateMagicBolt(duration = 0.28) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 12);
    const f1 = 1200 * Math.exp(-t * 8) + Math.sin(2 * Math.PI * 18 * t) * 150;
    const f2 = 1800 * Math.exp(-t * 10);
    const tone = Math.sin(2 * Math.PI * f1 * t) * 0.5 + Math.sin(2 * Math.PI * f2 * t) * 0.3;
    const shimmer = Math.sin(2 * Math.PI * 3200 * t) * Math.exp(-t * 25) * 0.25;
    samples[i] = (tone + shimmer) * env * 0.85;
  }
  return samples;
}

function generateLightning(duration = 0.4) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 7);
    const zap = (Math.random() * 2 - 1) * (1 + Math.sin(2 * Math.PI * 60 * t) * 0.5);
    const sub = Math.sin(2 * Math.PI * (160 * Math.exp(-t * 6)) * t) * 0.6;
    const crackle = Math.random() < 0.15 ? (Math.random() * 2 - 1) * 0.8 : 0;
    samples[i] = (zap * 0.45 + sub + crackle) * env * 0.9;
  }
  return samples;
}

function generateHit(duration = 0.16) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 30);
    const thump = Math.sin(2 * Math.PI * (180 * Math.exp(-t * 40)) * t) * 0.8;
    const snap = (Math.random() * 2 - 1) * Math.exp(-t * 60) * 0.6;
    samples[i] = (thump + snap) * env * 0.95;
  }
  return samples;
}

function generatePlayerHurt(duration = 0.25) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 14);
    const punch = Math.sin(2 * Math.PI * (140 * Math.exp(-t * 15)) * t) * 0.7;
    const grunt = Math.sin(2 * Math.PI * 90 * t) * 0.3;
    const crunch = (Math.random() * 2 - 1) * Math.exp(-t * 45) * 0.4;
    samples[i] = (punch + grunt + crunch) * env * 0.9;
  }
  return samples;
}

function generateExplosion(duration = 0.75) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 4.5);
    const subBoom = Math.sin(2 * Math.PI * (85 * Math.exp(-t * 3.5)) * t) * 0.8;
    const blastNoise = (Math.random() * 2 - 1) * Math.exp(-t * 8) * 0.6;
    const rumble = (Math.random() * 2 - 1) * 0.3 * env;
    samples[i] = (subBoom + blastNoise + rumble) * env * 0.95;
  }
  return samples;
}

function generateCoin(duration = 0.32) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 9);
    // Pure metallic dual-tone bell resonance
    const f1 = 1864.66; // A#6
    const f2 = 2793.83; // F7
    const bell = Math.sin(2 * Math.PI * f1 * t) * 0.6 + Math.sin(2 * Math.PI * f2 * t) * 0.4;
    const ping = Math.sin(2 * Math.PI * 4186 * t) * Math.exp(-t * 35) * 0.3;
    samples[i] = (bell + ping) * env * 0.75;
  }
  return samples;
}

function generateGem(duration = 0.22) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 14);
    const f = 1318.51 * Math.exp(t * 2); // E6 gliding up
    const crystal = Math.sin(2 * Math.PI * f * t) * 0.7 + Math.sin(2 * Math.PI * f * 2 * t) * 0.3;
    samples[i] = crystal * env * 0.65;
  }
  return samples;
}

function generateLevelUp(duration = 0.85) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  // Major arpeggio C5 -> E5 -> G5 -> C6
  const notes = [523.25, 659.25, 783.99, 1046.5];
  const step = duration / notes.length;

  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    let sum = 0;
    notes.forEach((freq, idx) => {
      const noteStart = idx * 0.12;
      if (t >= noteStart) {
        const nt = t - noteStart;
        const env = Math.exp(-nt * 6);
        const tone = Math.sin(2 * Math.PI * freq * nt) * 0.5 + Math.sin(2 * Math.PI * freq * 2 * nt) * 0.25;
        sum += tone * env;
      }
    });
    samples[i] = Math.min(1, Math.max(-1, sum * 0.7));
  }
  return samples;
}

function generateFanfare(duration = 1.2) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  const chords = [
    { time: 0.0, freq: 523.25 }, // C5
    { time: 0.18, freq: 659.25 }, // E5
    { time: 0.36, freq: 783.99 }, // G5
    { time: 0.54, freq: 1046.5 }, // C6
    { time: 0.72, freq: 1318.51 }, // E6 (Climax)
  ];

  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    let sum = 0;
    chords.forEach((c) => {
      if (t >= c.time) {
        const nt = t - c.time;
        const env = Math.exp(-nt * 4.5);
        const brass = Math.sin(2 * Math.PI * c.freq * nt) * 0.4 + Math.sin(2 * Math.PI * c.freq * 1.5 * nt) * 0.25 + Math.sin(2 * Math.PI * c.freq * 2 * nt) * 0.15;
        sum += brass * env;
      }
    });
    samples[i] = Math.min(1, Math.max(-1, sum * 0.75));
  }
  return samples;
}

function generateUltiReady(duration = 0.6) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  const freqs = [880, 1174.66, 1479.98, 1760];
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    let sum = 0;
    freqs.forEach((f, idx) => {
      const nt = t - idx * 0.08;
      if (nt >= 0) {
        const env = Math.exp(-nt * 7);
        const chime = Math.sin(2 * Math.PI * f * nt) * 0.4 + Math.sin(2 * Math.PI * f * 2.76 * nt) * 0.2;
        sum += chime * env;
      }
    });
    samples[i] = Math.min(1, Math.max(-1, sum * 0.8));
  }
  return samples;
}

function generateUltiActivate(duration = 1.1) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 3);
    const sweep = Math.sin(2 * Math.PI * (180 + Math.sin(t * 12) * 600 + Math.exp(-t * 4) * 800) * t);
    const sub = Math.sin(2 * Math.PI * (60 * Math.exp(-t * 2)) * t) * 0.8;
    const whoosh = (Math.random() * 2 - 1) * Math.sin(Math.PI * Math.min(1, t / 0.5)) * 0.4;
    samples[i] = (sweep * 0.4 + sub + whoosh) * env * 0.9;
  }
  return samples;
}

function generateBossAlarm(duration = 0.9) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 2.8);
    const horn = Math.sin(2 * Math.PI * 110 * t) * 0.6 + Math.sin(2 * Math.PI * 220 * t) * 0.3 + Math.sin(2 * Math.PI * 330 * t) * 0.15;
    const grit = (Math.random() * 2 - 1) * 0.15;
    samples[i] = (horn + grit) * env * 0.9;
  }
  return samples;
}

function generateGameOver(duration = 1.3) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  const freqs = [392.0, 349.23, 311.13, 261.63]; // G4 -> F4 -> Eb4 -> C4
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    let sum = 0;
    freqs.forEach((f, idx) => {
      const nt = t - idx * 0.26;
      if (nt >= 0) {
        const env = Math.exp(-nt * 3.5);
        const cello = Math.sin(2 * Math.PI * f * nt) * 0.5 + Math.sin(2 * Math.PI * f * 2 * nt) * 0.25;
        sum += cello * env;
      }
    });
    samples[i] = Math.min(1, Math.max(-1, sum * 0.8));
  }
  return samples;
}

function generateClick(duration = 0.05) {
  const length = Math.floor(SAMPLE_RATE * duration);
  const samples = new Float32Array(length);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const env = Math.exp(-t * 80);
    const click = Math.sin(2 * Math.PI * 1400 * t) * 0.7 + (Math.random() * 2 - 1) * 0.3;
    samples[i] = click * env * 0.6;
  }
  return samples;
}

// Generate all sound files
const outDir = path.resolve(__dirname, '../public/sounds');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

const soundGenerators = {
  'shoot.wav': generateShoot,
  'magic_bolt.wav': generateMagicBolt,
  'lightning.wav': generateLightning,
  'hit.wav': generateHit,
  'player_hurt.wav': generatePlayerHurt,
  'explosion.wav': generateExplosion,
  'coin.wav': generateCoin,
  'gem.wav': generateGem,
  'level_up.wav': generateLevelUp,
  'fanfare.wav': generateFanfare,
  'ulti_ready.wav': generateUltiReady,
  'ulti_activate.wav': generateUltiActivate,
  'boss_alarm.wav': generateBossAlarm,
  'game_over.wav': generateGameOver,
  'click.wav': generateClick,
};

for (const [filename, generator] of Object.entries(soundGenerators)) {
  const samples = generator();
  const wavBuffer = createWavBuffer(samples);
  const filePath = path.join(outDir, filename);
  fs.writeFileSync(filePath, wavBuffer);
  console.log(`Generated ${filename} (${wavBuffer.length} bytes)`);
}

console.log('All HQ audio assets successfully generated in public/sounds/ !');
