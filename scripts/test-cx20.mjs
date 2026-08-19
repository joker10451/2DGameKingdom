import https from 'https';

const testUrls = [
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/Duck/glTF-Binary/Duck.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/CesiumMan/glTF-Binary/CesiumMan.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/BrainStem/glTF-Binary/BrainStem.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/Monster/glTF-Binary/Monster.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/RiggedFigure/glTF-Binary/RiggedFigure.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/RiggedSimple/glTF-Binary/RiggedSimple.glb',
  'https://raw.githubusercontent.com/cx20/gltf-test/master/sampleModels/Knight/glTF-Binary/Knight.glb'
];

async function check(url) {
  return new Promise((resolve) => {
    https.request(url, { method: 'HEAD' }, (res) => {
      resolve({ url, status: res.statusCode });
    }).on('error', () => resolve({ url, status: 500 })).end();
  });
}

for (const q of testUrls) {
  const r = await check(q);
  console.log(`${r.status}: ${r.url}`);
}
