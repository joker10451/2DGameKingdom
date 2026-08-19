import https from 'https';

const repos = [
  'https://raw.githubusercontent.com/jessesquires/ThreeJS-GLTF-Models/master/tree.glb',
  'https://raw.githubusercontent.com/jessesquires/ThreeJS-GLTF-Models/master/rock.glb',
  'https://raw.githubusercontent.com/jessesquires/ThreeJS-GLTF-Models/master/castle.glb',
  'https://raw.githubusercontent.com/pmndrs/drei-assets/master/forest/tree.glb',
  'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/CesiumMan/glTF-Binary/CesiumMan.glb',
  'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/BarramundiFish/glTF-Binary/BarramundiFish.glb'
];

async function checkUrl(url) {
  return new Promise((resolve) => {
    https.request(url, { method: 'HEAD' }, (res) => {
      resolve({ url, status: res.statusCode });
    }).on('error', () => resolve({ url, status: 500 })).end();
  });
}

async function main() {
  for (const u of repos) {
    const res = await checkUrl(u);
    console.log(`${res.status === 200 ? '✓' : '✗'} ${res.status}: ${res.url}`);
  }
}

main();
