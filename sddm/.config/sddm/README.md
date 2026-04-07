# sddm/

Tema minimalista custom para SDDM y config drop-in.

**Esta carpeta NO se gestiona con Stow** — SDDM busca sus archivos en
rutas del sistema (`/usr/share/sddm/themes/`, `/etc/sddm.conf.d/`) que
requieren permisos de root.

## Contenido

```
sddm/
├── themes/
│   └── stormdot/
│       ├── Main.qml           # QML del tema (reloj + password + fondo Nord)
│       ├── metadata.desktop   # Descriptor del tema
│       └── theme.conf         # Config interna del tema (vacía por ahora)
└── sddm.conf                  # Config global de SDDM que activa el tema
```

## Instalación

`install.sh` hace automáticamente:

```bash
# Copiar el tema
sudo cp -r sddm/themes/stormdot /usr/share/sddm/themes/

# Copiar la config
sudo mkdir -p /etc/sddm.conf.d
sudo cp sddm/sddm.conf /etc/sddm.conf.d/stormdot.conf

# Habilitar SDDM si no lo está
sudo systemctl enable sddm
```

## Probar el tema sin reiniciar

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/stormdot
```

## Personalización

- **Colores:** edita `Main.qml`, sección con los `color: "#..."` (paleta Nord)
- **Fuente:** cambia `font.family` en `Main.qml` y `Font` en `sddm.conf`
- **Fondo:** el color base es `#2e3440`. Si quieres imagen, añade un
  `Image { source: "background.jpg"; anchors.fill: parent }` al inicio
  del `Rectangle` raíz en `Main.qml`.
