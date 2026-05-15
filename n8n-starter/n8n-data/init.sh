#!/bin/sh
set -e

# Este script corre antes de que n8n arranque.
# Importa workflows del directorio /workflows y activa el principal si existe.

WORKFLOW_DIR="/workflows"
WORKFLOW_NAME="${WORKFLOW_NAME:-Gmail to Backend Invoice Intake}"

if [ -d "$WORKFLOW_DIR" ]; then
	echo "[init] Revisando workflows en $WORKFLOW_DIR"
	for WF_FILE in "$WORKFLOW_DIR"/*.json; do
		if [ ! -f "$WF_FILE" ]; then
			continue
		fi

		WF_BASENAME=$(basename "$WF_FILE")
		echo "[init] Detectado workflow $WF_BASENAME"
		if n8n export:workflow --all --output=/tmp/exported-workflows >/dev/null 2>&1; then
			if grep -q '"name": "'"$WORKFLOW_NAME"'"' /tmp/exported-workflows/*.json 2>/dev/null; then
				echo "[init] Workflow principal ya existe. Evitando duplicados."
			else
				echo "[init] Importando $WF_BASENAME..."
				n8n import:workflow --separate --input="$WF_FILE" || true
			fi
		else
			echo "[init] Importando $WF_BASENAME..."
			n8n import:workflow --separate --input="$WF_FILE" || true
		fi
	done

	IDS=$(n8n list:workflow --pretty | awk -F'|' -v name="$WORKFLOW_NAME" '$0 ~ name {gsub(/ /, "", $1); print $1}')
	COUNT=$(echo "$IDS" | wc -w | tr -d ' ')
	if [ "$COUNT" -gt 1 ]; then
		echo "[init] Encontrados $COUNT duplicados del workflow principal."
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
		echo "[init] No se encontró el workflow principal tras importar."
	fi
else
	echo "[init] No se encontró $WORKFLOW_DIR. Saltando import."
fi

exit 0
