const fs = require('node:fs');
const path = require('node:path');

const envFilePath = process.env.N8N_STAGING_ENV_FILE || path.join(__dirname, '..', 'n8n-starter', '.env.staging');

const requiredKeys = [
  'N8N_HOST',
  'N8N_PORT',
  'N8N_PROTOCOL',
  'WEBHOOK_URL',
  'N8N_EDITOR_BASE_URL',
  'N8N_CORS_ALLOW_ORIGIN',
  'N8N_BASIC_AUTH_ACTIVE',
  'N8N_BASIC_AUTH_USER',
  'N8N_BASIC_AUTH_PASSWORD',
  'GENERIC_TIMEZONE',
  'N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS',
  'DB_SQLITE_POOL_SIZE',
  'N8N_RUNNERS_ENABLED',
  'N8N_BLOCK_ENV_ACCESS_IN_NODE',
  'API_BASE_URL',
  'N8N_API_KEY',
  'WORKFLOW_NAME',
];

const placeholderSnippets = ['replace-me', 'change-me', 'example.com'];

function parseEnvFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const entries = {};

  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#')) {
      continue;
    }

    const separatorIndex = line.indexOf('=');
    if (separatorIndex === -1) {
      continue;
    }

    const key = line.slice(0, separatorIndex).trim();
    const value = line.slice(separatorIndex + 1).trim();
    entries[key] = value;
  }

  return entries;
}

function findProblems(entries) {
  const problems = [];

  for (const key of requiredKeys) {
    const value = entries[key];
    if (!value) {
      problems.push(`Missing ${key}`);
      continue;
    }

    if (placeholderSnippets.some((snippet) => value.includes(snippet))) {
      problems.push(`Placeholder value for ${key}`);
    }
  }

  if (entries.N8N_PROTOCOL && !['http', 'https'].includes(entries.N8N_PROTOCOL)) {
    problems.push('N8N_PROTOCOL must be http or https');
  }

  if (entries.WEBHOOK_URL && !entries.WEBHOOK_URL.startsWith(`${entries.N8N_PROTOCOL || 'https'}://`)) {
    problems.push('WEBHOOK_URL must match N8N_PROTOCOL');
  }

  if (entries.API_BASE_URL && !entries.API_BASE_URL.startsWith('http')) {
    problems.push('API_BASE_URL must be an absolute URL');
  }

  return problems;
}

function main() {
  if (!fs.existsSync(envFilePath)) {
    throw new Error(`Missing staging env file: ${envFilePath}`);
  }

  const entries = parseEnvFile(envFilePath);
  const problems = findProblems(entries);

  if (problems.length > 0) {
    throw new Error(`Invalid staging env file ${envFilePath}\n- ${problems.join('\n- ')}`);
  }

  console.log(JSON.stringify({ ok: true, envFilePath, checkedKeys: requiredKeys }, null, 2));
}

main();
