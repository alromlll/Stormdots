#!/usr/bin/env bash
# =============================================================================
# power-menu.sh · Menú de apagado/reinicio/suspend/logout/lock con rofi
# =============================================================================

set -euo pipefail

OPTIONS="  Apagar
  Reiniciar
  Suspender
  Cerrar sesión
  Bloquear"

CHOSEN=$(printf '%s' "$OPTIONS" | rofi -dmenu -i -p "Power")

case "$CHOSEN" in
    *Apagar*)          systemctl poweroff ;;
    *Reiniciar*)       systemctl reboot ;;
    *Suspender*)       systemctl suspend ;;
    *"Cerrar sesión"*) hyprctl dispatch exit ;;
    *Bloquear*)        hyprlock ;;
esac
