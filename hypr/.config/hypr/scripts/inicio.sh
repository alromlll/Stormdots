#!/usr/bin/env bash
# =============================================================================
# inicio.sh · Script de arranque de Hyprland
# Lanzado por exec-once en hyprland.conf
# =============================================================================
#
# Aquí van apps y ajustes que se ejecutan UNA vez al arrancar la sesión.
# Los daemons importantes (waybar, swww, polkit, cliphist) ya están en
# hyprland.conf — esto es para extras del usuario.

set -euo pipefail

# Autowindows-Anki-Kitty-Obsidian-Dolphin-Brave
hyprctl dispatch workspace 1
sleep 0.5
anki &
sleep 0.5
obsidian &
brave &
sleep 3
hyprctl dispatch workspace 2
sleep 0.5
hyprctl dispatch workspace 3
dolphin &
sleep 0.5
kitty &
sleep 0.5
gedit &

# Ejemplo: lanzar apps en workspaces específicos
# hyprctl dispatch exec "[workspace 1 silent] kitty"
# hyprctl dispatch exec "[workspace 2 silent] brave"

# Ejemplo: ajustar teclado a un layout custom después del arranque
# setxkbmap -layout es

# Ejemplo: aplicar GTK theme con gsettings (si nwg-look no basta)
# gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# ─── Tu lógica de arranque aquí ───
