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
- El runbook end-to-end vive en `automatizacion-facturas/ai/plans/staging_runbook.md`

## Inicio rápido

```bash
npm run up:local
```

UI local:

- `http://127.0.0.1:5678`

La UI queda enlazada solo a loopback en Docker Compose para no exponer `n8n` a la red local. Publicar `n8n` por túnel debe ser una excepción temporal para OAuth o debugging.

Documentación detallada:

- `n8n-starter/README.md`

## Comandos operativos

- `npm run prepare:env`: crea `n8n-starter/.env` si no existe
- `npm run up:local`: levanta n8n local
- `npm run down:local`: detiene n8n local
- `npm run verify:local`: smoke test local
- `npm run validate:staging`: valida `N8N_STAGING_ENV_FILE` antes del deploy
- `npm run deploy:staging`: despliegue remoto por SSH
- `npm run verify:staging`: smoke test de staging
