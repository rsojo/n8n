# n8n starter (Docker)

Este starter levanta `n8n` con Docker y deja listo el workflow principal de ingreso de facturas desde Gmail hacia el backend del proyecto.

## Requisitos

- Docker y Docker Compose
- Credenciales de Gmail/Google Drive configuradas directamente en la UI de `n8n`
- URL pública o staging del backend API
- API key del servicio `n8n`

## Cómo iniciar

```bash
docker compose -f n8n-starter/docker-compose.yml up -d
```

UI local:

- `http://localhost:5678`

## Variables de entorno

Trabaja desde `n8n-starter/.env`.

```bash
cp n8n-starter/.env.example n8n-starter/.env
docker compose --env-file n8n-starter/.env -f n8n-starter/docker-compose.yml up -d
```

Variables clave:

- `API_BASE_URL`: URL del backend, por ejemplo `https://api-staging.example.com`
- `N8N_API_KEY`: API key del backend para el servicio n8n
- `WEBHOOK_URL`: URL base de n8n
- `N8N_EDITOR_BASE_URL`: URL del editor

## Workflow incluido

- Archivo: `workflows/invoice-gmail-to-backend.json`
- Nombre esperado: `Gmail to Backend Invoice Intake`

## Qué hace el workflow

1. Lee correos con adjuntos desde Gmail.
2. Clasifica si el correo corresponde a una factura.
3. Crea el caso en el backend.
4. Registra adjuntos.
5. Extrae y valida información documental.
6. Detecta duplicados.
7. Sugiere o asigna responsable.
8. Dispara notificación inicial.

## Credenciales a crear en n8n

1. Gmail OAuth2
2. Google Drive OAuth2

El workflow usa `API_BASE_URL` y `N8N_API_KEY` como variables de entorno del contenedor para hablar con el backend.

## Troubleshooting

- Si la UI pierde conexión, revisa `WEBHOOK_URL`, `N8N_EDITOR_BASE_URL` y `N8N_CORS_ALLOW_ORIGIN`.
- Si el workflow no aparece al arrancar, revisa logs del contenedor y el script `n8n-data/init.sh`.
- Si el backend rechaza llamadas, verifica `API_BASE_URL` y `N8N_API_KEY`.
