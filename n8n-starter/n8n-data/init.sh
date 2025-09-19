#!/bin/sh
set -e

# Este script corre antes de que n8n arranque (hook oficial del entrypoint).
# Importa el workflow si no existe y asegura activación única.

WF_FILE="/workflows/whatsapp-gcal.json"

if [ -f "$WF_FILE" ]; then
	echo "[init] Detectado workflow en $WF_FILE"
	# Exportar lista de workflows para ver si ya existe alguno con ese nombre
	if n8n list:workflow --pretty 2>/dev/null | grep -q "WhatsApp ↔ Google Calendar – Agendar Citas"; then
		echo "[init] Workflow ya existe. Evitando duplicados."
	else
		echo "[init] Importando workflow inicial..."
		n8n import:workflow --separate --input="$WF_FILE" || true
	fi

	# Activar el workflow por nombre (si existe) y desactivar cualquier duplicado por nombre
	IDS=$(n8n list:workflow --pretty | awk -F'|' '/WhatsApp ↔ Google Calendar – Agendar Citas/{print $1}')
	COUNT=$(echo "$IDS" | wc -w | tr -d ' ')
	if [ "$COUNT" -gt 1 ]; then
		echo "[init] Encontrados $COUNT duplicados. Desactivando todos menos el primero..."
		FIRST=$(echo "$IDS" | awk '{print $1}')
		for ID in $IDS; do
			if [ "$ID" != "$FIRST" ]; then
				n8n update:workflow --id "$ID" --active=false || true
			fi
		done
		n8n update:workflow --id "$FIRST" --active=true || true
	elif [ "$COUNT" -eq 1 ]; then
		ONE=$(echo "$IDS" | awk '{print $1}')
		n8n update:workflow --id "$ONE" --active=true || true
	else
		echo "[init] No se encontró el workflow tras importar."
	fi
else
	echo "[init] No se encontró $WF_FILE. Saltando import."
fi

exit 0
