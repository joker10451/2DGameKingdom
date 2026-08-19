import https from 'https';

const queries = [
  'https://raw.githubusercontent.com/Poly-Pizza/poly-models/main/models/House/House.glb',
  'https://raw.githubusercontent.com/Poly-Pizza/poly-models/main/models/Castle/Castle.glb',
  'https://raw.githubusercontent.com/Poly-Pizza/poly-models/main/models/Tent/Tent.glb',
  'https://raw.githubusercontent.com/Poly-Pizza/poly-models/main/models/Tree/Tree.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/CesiumMan/glTF-Binary/CesiumMan.glb'
];

async function check(url) {
  return new Promise((resolve) => {
    https.request(url, { method: 'HEAD' }, (res) => {
      resolve({ url, status: res.statusCode });
    }).on('error', () => resolve({ url, status: 500 })).end();
  });
}

for (const q of queries) {
  const r = await check(q);
  console.log(`${r.status}: ${r.url}`);
}
