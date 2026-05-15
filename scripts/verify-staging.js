const baseUrl = process.env.N8N_STAGING_BASE_URL;

if (!baseUrl) {
  throw new Error('Missing N8N_STAGING_BASE_URL');
}

async function main() {
  const response = await fetch(baseUrl);
  if (!response.ok) {
    throw new Error(`n8n staging returned ${response.status}`);
  }
  console.log(JSON.stringify({ ok: true, status: response.status, baseUrl }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
