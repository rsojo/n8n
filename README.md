# n8n - Invoice Automation Starter

Repositorio de infraestructura y starter de `n8n` para la demo de automatización de facturas.

## Propósito

- Levantar una instancia local o de staging de `n8n`
- Importar automáticamente el workflow de ingreso de facturas
- Integrarse con el backend API del proyecto `automatizacion-facturas`

## Estructura

- `n8n-starter/`: starter listo para Docker Compose
- `n8n-starter/workflows/`: workflows versionados para importar
- `n8n-starter/n8n-data/init.sh`: hook de importación inicial

## Workflow principal

- `invoice-gmail-to-backend.json`
- Orquesta clasificación, creación de caso, validación y notificación

## Seguridad

- No almacenar llaves privadas, bases de datos ni credenciales exportadas en el repo
- Usar `.env` local a partir de `.env.example`

## Inicio rápido

```bash
docker compose --env-file n8n-starter/.env -f n8n-starter/docker-compose.yml up -d
```

UI local:

- `http://localhost:5678`

Documentación detallada:

- `n8n-starter/README.md`
