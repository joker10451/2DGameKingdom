import fs from 'fs';
import path from 'path';
import https from 'https';

const modelsToDownload = [
  {
    name: 'fox.glb',
    url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Fox/glTF-Binary/Fox.glb'
  },
  {
    name: 'lantern.glb',
    url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Lantern/glTF-Binary/Lantern.glb'
  },
  {
    name: 'robot.glb',
    url: 'https://raw.githubusercontent.com/mrdoob/three.js/master/examples/models/gltf/RobotExpressive/RobotExpressive.glb'
  }
];

const outDir = path.join(process.cwd(), 'public', 'models');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

function download(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return download(res.headers.location, dest).then(resolve).catch(reject);
      }
      if (res.statusCode !== 200) {
        fs.unlink(dest, () => {});
        return reject(new Error(`Failed with status: ${res.statusCode}`));
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

async function run() {
  for (const m of modelsToDownload) {
    const p = path.join(outDir, m.name);
    console.log(`Downloading ${m.name}...`);
    try {
      await download(m.url, p);
      console.log(`✓ Downloaded ${m.name} (${fs.statSync(p).size} bytes)`);
    } catch (e) {
      console.error(`✗ Error for ${m.name}:`, e.message);
    }
  }
}

run();
