#!/usr/bin/env bash
# ==============================================================================
# build-in-docker.sh - Script de compilación ejecutado dentro del contenedor Ubuntu 24.04
# Dzulux Linux 2.0 - Diseñado por Alfredo Dzul
# ==============================================================================

set -euo pipefail

EDITION="${1:-desktop}"
echo "==> Compilando Dzulux Linux 2.0 (${EDITION}) en contenedor Ubuntu 24.04 LTS..."
cd /workspace
bash ./scripts/build.sh "$EDITION"
cd /workspace/output
sha256sum *.iso > sha256sum.txt
echo "==> [✓] ¡Compilación completada exitosamente!"
ls -lh /workspace/output
