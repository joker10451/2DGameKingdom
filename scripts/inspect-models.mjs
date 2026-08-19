import fs from 'fs';

console.log('soldier.glb size:', fs.statSync('public/models/soldier.glb').size);
console.log('character_peasant.glb size:', fs.statSync('public/models/character_peasant.glb').size);
console.log('horse.glb size:', fs.statSync('public/models/horse.glb').size);
