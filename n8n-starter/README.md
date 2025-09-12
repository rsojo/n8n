# n8n starter (Docker)

Este proyecto levanta n8n con Docker y contiene un workflow de ejemplo para agendar citas desde WhatsApp hacia Google Calendar.

## Requisitos
- Docker y docker-compose
- Credenciales de Google (OAuth2) para Google Calendar
- Token y Phone Number ID de WhatsApp Cloud API (Meta)

## Cómo iniciar
```bash
# desde la raíz del repo
docker-compose -f n8n-starter/docker-compose.yml up -d
# UI de n8n
http://localhost:5678
```

## Variables de entorno (`n8n-starter/.env`)
- `GCAL_CALENDAR_ID` (ej. `primary`)
- `WABA_PHONE_NUMBER_ID`
- `WABA_TOKEN` (referencia para crear la credencial HTTP)
- Recomendadas: `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true`, `DB_SQLITE_POOL_SIZE=5`, `N8N_RUNNERS_ENABLED=true`, `N8N_BLOCK_ENV_ACCESS_IN_NODE=false`
- CORS/UI local: `N8N_CORS_ALLOW_ORIGIN=http://localhost:5678`, `N8N_EDITOR_BASE_URL=http://localhost:5678`

## Credenciales en n8n (UI)
1. Google Calendar OAuth2
   - Settings → Credentials → New → "Google Calendar OAuth2 API"
   - Nombre: `Google_Calendar_Account`
   - Completar Client ID/Secret y flujo OAuth
2. WhatsApp Cloud API (HTTP Header Auth)
   - Settings → Credentials → New → "HTTP Header Auth"
   - Nombre: `WhatsApp_Cloud_API`
   - Header: `Authorization: Bearer <TU_WABA_TOKEN>`

## Workflow incluido
- Archivo: `workflows/whatsapp-gcal.json`
- Importado y activado con ID: `lmMfAJXcPnUaLRuV`
- Webhook (POST): `http://localhost:5678/webhook/whatsapp/inbound`

## Pruebas rápidas
Con fecha:
```bash
curl -sS -X POST 'http://localhost:5678/webhook/whatsapp/inbound' \
  -H 'Content-Type: application/json' \
  -d @- <<'JSON'
{
  "entry": [
    {
      "changes": [
        {
          "value": {
            "messages": [
              { "from": "573001112233", "type": "text", "text": { "body": "Agendar 2025-09-13 10:00" } }
            ],
            "contacts": [
              { "wa_id": "573001112233", "profile": { "name": "Juan Perez" } }
            ]
          }
        }
      ]
    }
  ]
}
JSON
```
Sin fecha:
```bash
curl -sS -X POST 'http://localhost:5678/webhook/whatsapp/inbound' \
  -H 'Content-Type: application/json' \
  -d @- <<'JSON'
{
  "entry": [
    {
      "changes": [
        {
          "value": {
            "messages": [
              { "from": "573001112233", "type": "text", "text": { "body": "Quiero una cita" } }
            ],
            "contacts": [
              { "wa_id": "573001112233", "profile": { "name": "Juan Perez" } }
            ]
          }
        }
      ]
    }
  ]
}
JSON
```

## Troubleshooting
- "Connection lost" al abrir la UI: asegúrate de `N8N_CORS_ALLOW_ORIGIN` y `N8N_EDITOR_BASE_URL` apuntando a `http://localhost:5678`, y reinicia el contenedor.
- Warnings de permisos: usa `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true`.
- GCal/WhatsApp fallan: revisa Executions para ver el error exacto y confirma credenciales y variables.
