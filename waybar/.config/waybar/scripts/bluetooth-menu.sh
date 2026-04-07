#!/usr/bin/env bash
# =============================================================================
# bluetooth-menu.sh · Gestión de dispositivos Bluetooth
# Requiere: bluez, bluez-utils, rofi, (opcional) blueman
# =============================================================================

set -euo pipefail

if ! command -v bluetoothctl &>/dev/null; then
    notify-send "Bluetooth" "bluez-utils no está instalado"
    exit 1
fi

# ── Helpers ─────────────────────────────────────────────────────────────────
bt_is_on() { bluetoothctl show | grep -q "Powered: yes"; }

# Lista "MAC\tnombre\tconnected|disconnected" de dispositivos emparejados
get_paired_devices() {
    bluetoothctl devices Paired | while read -r _ mac rest; do
        if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
            printf '%s\t%s\tconnected\n'    "$mac" "$rest"
        else
            printf '%s\t%s\tdisconnected\n' "$mac" "$rest"
        fi
    done
}

rofi_theme='
    window   { width: 300px; border-radius: 8px; }
    listview { spacing: 5px; }
    element  { padding: 8px 12px; border-radius: 4px; }
'

# ── Menú principal ──────────────────────────────────────────────────────────
if bt_is_on; then
    TOGGLE="  Desactivar Bluetooth"
else
    TOGGLE="  Activar Bluetooth"
fi

OPTIONS="$TOGGLE
  Dispositivos emparejados
  Escanear dispositivos
  Configuración"

CHOSEN=$(printf '%s' "$OPTIONS" | rofi -dmenu -i -p "Bluetooth" -theme-str "$rofi_theme")

case "$CHOSEN" in
    *"Activar Bluetooth"*)
        bluetoothctl power on >/dev/null
        notify-send "Bluetooth" "Activado"
        ;;

    *"Desactivar Bluetooth"*)
        bluetoothctl power off >/dev/null
        notify-send "Bluetooth" "Desactivado"
        ;;

    *"Dispositivos emparejados"*)
        DEVICES_DATA=$(get_paired_devices)
        if [[ -z "$DEVICES_DATA" ]]; then
            notify-send "Bluetooth" "No hay dispositivos emparejados"
            exit 0
        fi

        MENU=""
        while IFS=$'\t' read -r mac name status; do
            if [[ "$status" == connected ]]; then
                MENU+="  $name (conectado)"$'\n'
            else
                MENU+="  $name"$'\n'
            fi
        done <<< "$DEVICES_DATA"

        SEL=$(printf '%s' "$MENU" | rofi -dmenu -i -p "Dispositivos" -theme-str "$rofi_theme")
        [[ -z "${SEL:-}" ]] && exit 0

        SEL_NAME=$(echo "$SEL" | sed 's/^[^ ]* *//' | sed 's/ (conectado)$//')
        MAC=$(echo "$DEVICES_DATA" | awk -F'\t' -v n="$SEL_NAME" '$2==n {print $1; exit}')

        if [[ -n "$MAC" ]]; then
            if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
                bluetoothctl disconnect "$MAC" >/dev/null
                notify-send "Bluetooth" "Desconectado de $SEL_NAME"
            else
                if bluetoothctl connect "$MAC" >/dev/null; then
                    notify-send "Bluetooth" "Conectado a $SEL_NAME"
                else
                    notify-send "Bluetooth" "Error al conectar a $SEL_NAME"
                fi
            fi
        fi
        ;;

    *"Escanear dispositivos"*)
        notify-send "Bluetooth" "Escaneando 15s..."

        # --timeout hace scan síncrono y libera el adapter solo. Sin &, sin kill manual.
        bluetoothctl --timeout 15 scan on >/dev/null 2>&1 || true

        # Dispositivos vistos pero NO emparejados
        ALL_DEVICES=$(bluetoothctl devices | awk '{mac=$2; $1=""; $2=""; sub(/^  /,""); print mac"\t"$0}')
        PAIRED_MACS=$(bluetoothctl devices Paired | awk '{print $2}')

        NEW=""
        while IFS=$'\t' read -r mac name; do
            [[ -z "${mac:-}" ]] && continue
            if ! echo "$PAIRED_MACS" | grep -q "$mac"; then
                NEW+="$mac"$'\t'"$name"$'\n'
            fi
        done <<< "$ALL_DEVICES"

        if [[ -z "$NEW" ]]; then
            notify-send "Bluetooth" "Sin dispositivos nuevos"
            exit 0
        fi

        MENU=""
        while IFS=$'\t' read -r _ name; do
            [[ -z "${name:-}" ]] && continue
            MENU+="  $name"$'\n'
        done <<< "$NEW"

        SEL=$(printf '%s' "$MENU" | rofi -dmenu -i -p "Nuevo dispositivo" -theme-str "$rofi_theme")
        [[ -z "${SEL:-}" ]] && exit 0

        SEL_NAME=$(echo "$SEL" | sed 's/^[^ ]* *//')
        MAC=$(echo "$NEW" | awk -F'\t' -v n="$SEL_NAME" '$2==n {print $1; exit}')

        if [[ -n "$MAC" ]]; then
            notify-send "Bluetooth" "Emparejando con $SEL_NAME..."
            if bluetoothctl pair "$MAC" >/dev/null && \
               bluetoothctl trust "$MAC" >/dev/null && \
               bluetoothctl connect "$MAC" >/dev/null; then
                notify-send "Bluetooth" "Conectado a $SEL_NAME"
            else
                notify-send "Bluetooth" "Error al emparejar con $SEL_NAME"
            fi
        fi
        ;;

    *Configuración*)
        if command -v blueman-manager &>/dev/null; then
            blueman-manager &
        else
            notify-send "Bluetooth" "blueman no está instalado"
        fi
        ;;
esac
