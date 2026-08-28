#!/usr/bin/env bash
# shellcheck disable=SC2034
# Profile definition for Dzulux Linux
# Designed and Crafted by Alfredo Dzul

iso_name="dzulux"
iso_label="DZULUX_$(date +%Y%m)"
iso_publisher="Alfredo Dzul <https://github.com/Alfredo2364/Linux>"
iso_application="Dzulux Linux Live/Installer OS (Beta)"
iso_version="1.1-beta"
install_dir="dzulux"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.grub')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/liveuser"]="0:0:440"
  ["/root"]="0:0:750"
  ["/home/liveuser"]="1000:1000:755"
  ["/home/liveuser/Desktop"]="1000:1000:755"
  ["/home/liveuser/Desktop/dzulux-installer.desktop"]="1000:1000:755"
  ["/home/liveuser/Desktop/hw-detect.desktop"]="1000:1000:755"
  ["/usr/local/bin/dzulux-installer"]="0:0:755"
  ["/usr/local/bin/hw-detect"]="0:0:755"
  ["/usr/local/bin/switch-mode"]="0:0:755"
  ["/usr/local/bin/dzulux-welcome"]="0:0:755"
  ["/usr/local/bin/dzulux-drivers"]="0:0:755"
  ["/usr/local/bin/dzulux-apps"]="0:0:755"
  ["/usr/local/bin/dzulux-snapshots"]="0:0:755"
  ["/usr/local/bin/dzulux-rescue"]="0:0:755"
  ["/usr/local/bin/dzulux-battery"]="0:0:755"
  ["/usr/local/bin/dzulux-stealth"]="0:0:755"
  ["/usr/local/bin/dzulux-looks"]="0:0:755"
  ["/usr/local/bin/dzulux-performance"]="0:0:755"
  ["/usr/local/bin/dzulux-update"]="0:0:755"
  ["/usr/local/bin/dzulux-live-init"]="0:0:755"
)
