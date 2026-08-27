#!/usr/bin/env bash
# ==============================================================================
# build-in-docker.sh - Script de compilación ejecutado dentro del contenedor
# Dzulux Linux - Diseñado por Alfredo Dzul
# ==============================================================================

set -euo pipefail

echo "==> [1/5] Inicializando llaves y firmas de seguridad de Arch Linux..."
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm archlinux-keyring

echo "==> [2/5] Configurando servidores espejo Geo-DNS de alta velocidad..."
cat << 'EOF' > /etc/pacman.d/mirrorlist
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
EOF

echo "==> [3/5] Instalando archiso, grub y herramientas del sistema..."
pacman -Syu --noconfirm archiso grub git squashfs-tools dosfstools libisoburn mtools

echo "==> [4/5] Compilando imagen ISO de Dzulux Linux (mkarchiso)..."
mkdir -p /tmp/archiso-work /workspace/output
mkarchiso -v -w /tmp/archiso-work -o /workspace/output /workspace/iso-profile

echo "==> [5/5] Generando sumas de comprobación SHA256..."
cd /workspace/output
sha256sum *.iso > sha256sum.txt

echo "==> [✓] ¡Compilación completada exitosamente!"
ls -lh /workspace/output
