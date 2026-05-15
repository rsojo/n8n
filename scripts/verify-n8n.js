const baseUrl = process.env.N8N_BASE_URL || 'http://localhost:5678';

async function main() {
  const response = await fetch(baseUrl);
  if (!response.ok) {
    throw new Error(`n8n returned ${response.status}`);
  }
  console.log(JSON.stringify({ ok: true, status: response.status, baseUrl }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
