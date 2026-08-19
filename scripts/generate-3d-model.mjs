/**
 * 3D Asset Auto-Generator for Kingdom Three.js Game
 * Supports Meshy.ai / Tripo3D text-to-3d generation.
 * 
 * Usage:
 *   node scripts/generate-3d-model.mjs "medieval catapult, low-poly stylized game asset" catapult
 */
import fs from 'fs';
import path from 'path';
import https from 'https';

const API_KEY = process.env.MESHY_API_KEY || process.env.TRIPO_API_KEY || '';

const prompt = process.argv[2] || 'medieval wooden watchtower, low poly stylized 3d game asset';
const modelName = (process.argv[3] || 'generated_model').replace(/[^a-zA-Z0-9_-]/g, '_');
const outputDir = path.join(process.cwd(), 'public', 'models');
const outputPath = path.join(outputDir, `${modelName}.glb`);

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

console.log(`\n🎨 Starting 3D Generation for: "${prompt}"`);
console.log(`📁 Target output: ${outputPath}\n`);

if (!API_KEY) {
  console.log(`⚠️  API Key not found in environment (MESHY_API_KEY).`);
  console.log(`ℹ️  To generate unique custom 3D models via AI:`);
  console.log(`   1. Get a free API key at https://www.meshy.ai/ or https://www.tripo3d.ai/`);
  console.log(`   2. Set key: $env:MESHY_API_KEY="your_key_here"`);
  console.log(`   3. Run: node scripts/generate-3d-model.mjs "your prompt" ${modelName}\n`);
  process.exit(0);
}

async function request(url, options = {}, data = null) {
  return new Promise((resolve, reject) => {
    const req = https.request(url, options, (res) => {
      let body = '';
      res.on('data', (chunk) => (body += chunk));
      res.on('end', () => {
        try {
          resolve({ statusCode: res.statusCode, data: JSON.parse(body) });
        } catch (e) {
          resolve({ statusCode: res.statusCode, data: body });
        }
      });
    });
    req.on('error', reject);
    if (data) req.write(typeof data === 'string' ? data : JSON.stringify(data));
    req.end();
  });
}

async function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, (response) => {
      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        return downloadFile(response.headers.location, dest).then(resolve).catch(reject);
      }
      response.pipe(file);
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

async function generateWithMeshy() {
  console.log('🚀 Sending generation task to Meshy API...');

  // Step 1: Create Task
  const createRes = await request('https://api.meshy.ai/openapi/v2/text-to-3d', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Content-Type': 'application/json',
    },
  }, {
    mode: 'preview',
    prompt: prompt,
    art_style: 'cartoon',
    should_remesh: true,
  });

  if (createRes.statusCode !== 200 && createRes.statusCode !== 202) {
    console.error('❌ Failed to start generation:', createRes.data);
    return;
  }

  const taskId = createRes.data.result;
  console.log(`⏳ Task ID: ${taskId}. Generating 3D mesh (takes ~30s)...`);

  // Step 2: Poll status
  let modelUrl = null;
  for (let i = 0; i < 60; i++) {
    await new Promise((r) => setTimeout(r, 4000));
    const statusRes = await request(`https://api.meshy.ai/openapi/v2/text-to-3d/${taskId}`, {
      headers: { 'Authorization': `Bearer ${API_KEY}` },
    });

    const status = statusRes.data.status;
    const progress = statusRes.data.progress || 0;
    process.stdout.write(`\r⏳ Progress: ${progress}% [${status}]`);

    if (status === 'SUCCEEDED') {
      modelUrl = statusRes.data.model_urls?.glb;
      break;
    } else if (status === 'FAILED' || status === 'EXPIRED') {
      console.error('\n❌ Generation failed:', statusRes.data.task_error);
      return;
    }
  }

  if (modelUrl) {
    console.log(`\n📥 Downloading GLB model to ${outputPath}...`);
    await downloadFile(modelUrl, outputPath);
    console.log(`✅ Success! 3D Model saved as public/models/${modelName}.glb`);
  }
}

generateWithMeshy().catch(console.error);
