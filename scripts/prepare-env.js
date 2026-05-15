const fs = require('node:fs');
const path = require('node:path');

const source = path.join(__dirname, '..', 'n8n-starter', '.env.example');
const target = path.join(__dirname, '..', 'n8n-starter', '.env');

if (!fs.existsSync(target)) {
  fs.copyFileSync(source, target);
  console.log(`Created ${target} from .env.example`);
} else {
  console.log(`${target} already exists`);
}
