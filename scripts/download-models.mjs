import https from 'https';
import fs from 'fs';
import path from 'path';

// List of real open-source 3D models from reliable GitHub repositories
const modelSources = [
  // Characters & Humans
  {
    name: 'character_peasant.glb',
    url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/CesiumMan/glTF-Binary/CesiumMan.glb'
  },
  {
    name: 'lantern_prop.glb',
    url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Lantern/glTF-Binary/Lantern.glb'
  },
  // Animals
  {
    name: 'fish.glb',
    url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/BarramundiFish/glTF-Binary/BarramundiFish.glb'
  }
];

const outDir = path.join(process.cwd(), 'public', 'models');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return downloadFile(res.headers.location, dest).then(resolve).catch(reject);
      }
      if (res.statusCode !== 200) {
        fs.unlink(dest, () => {});
        return reject(new Error(`HTTP ${res.statusCode}`));
      }
      res.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve(true);
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => {});
      reject(err);
    });
  });
}

async function start() {
  console.log('Downloading 3D assets...');
  for (const item of modelSources) {
    const dest = path.join(outDir, item.name);
    try {
      await downloadFile(item.url, dest);
      console.log(`✓ Downloaded ${item.name} (${fs.statSync(dest).size} bytes)`);
    } catch (e) {
      console.error(`✗ Error downloading ${item.name}:`, e.message);
    }
  }
}

start();
