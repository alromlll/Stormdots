# ⚡ Stormdot

> Dotfiles para Arch Linux + Hyprland — solo lo necesario, nada más.

Configuración personal de entorno de escritorio minimalista para Arch Linux,
gestionada con [GNU Stow](https://www.gnu.org/software/stow/) y reproducible
desde cero con un único script tras una reinstalación limpia.

---

## Filosofía

**Minimalismo funcional.** Cada herramienta tiene un propósito claro. Si no aporta, no entra.

El objetivo no es tener el setup más bonito de r/unixporn — es tener un
entorno que no se interponga entre el operador y el trabajo. Wayland nativo,
tiling dinámico, theming coherente y restaurable en minutos tras una
reinstalación.

---

## Stack

| Capa | Herramienta | Por qué |
|------|-------------|---------|
| Compositor | [Hyprland](https://hyprland.org/) | Tiling dinámico Wayland, config declarativa |
| Shell | Fish | Autocompletado out-of-the-box, sin configurar nada |
| Prompt | Starship | Cross-shell, rápido, configurable en TOML |
| Terminal | Kitty | GPU-accelerated, ligero |
| Editor | Neovim (kickstart-based) | LSP + Treesitter + Telescope |
| Editor ligero | Gedit | Para notas rápidas |
| Barra | Waybar | Modular, CSS puro |
| Launcher | Rofi | Rápido, scriptable |
| Notificaciones | Dunst | Minimalista, configurable en texto plano |
| Gestor de archivos | Dolphin | El único que no da problemas con MTP/SMB |
| Browser | Brave | Lista de extensiones versionada (sin datos de perfil) |
| Display manager | SDDM | Estándar Wayland |
| Wallpapers | swww | Transiciones animadas, nativo Wayland |
| Audio | PipeWire + WirePlumber | Estándar moderno |
| Bloqueo | hyprlock + hypridle | Nativos de Hyprland |
| Tema | Nord | Paleta única en kitty/waybar/dunst/nvim/starship |

---

## Estructura del repositorio

Cada carpeta de primer nivel es un **paquete de Stow**: su contenido se
replica tal cual desde `$HOME` mediante symlinks.

```
Stormdot/
├── README.md
├── LICENSE
├── .gitignore
├── install.sh                  # Punto de entrada — léelo primero
│
├── hypr/                       # Hyprland (compositor)
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── monitors.conf
│       ├── keybinds.conf
│       └── scripts/
│
├── waybar/                     # Barra de estado
│   └── .config/waybar/
│       ├── config
│       ├── style.css
│       └── scripts/
│
├── kitty/                      # Terminal
│   └── .config/kitty/kitty.conf
│
├── fish/                       # Shell
│   └── .config/fish/
│       ├── config.fish
│       ├── conf.d/abbr.fish    # 100+ abbreviations
│       └── functions/          # Funciones personalizadas
│
├── starship/                   # Prompt
│   └── .config/starship.toml
│
├── dunst/                      # Notificaciones
│   └── .config/dunst/dunstrc
│
├── nvim/                       # Editor
│   └── .config/nvim/init.lua   # Basado en kickstart.nvim
│
├── git/                        # Git
│   ├── .gitconfig
│   └── .gitignore_global
│
├── bash/                       # Bash (fallback shell)
│   ├── .bashrc
│   └── .bash_profile
│
├── gedit/                      # NO stowable — solo dconf settings
│   ├── README.md
│   └── gedit-settings          # exportado vía dconf dump
│
├── brave/                      # NO stowable — solo lista de extensiones
│   └── extensions.txt
│
└── scripts/                    # Scripts personales del usuario
    └── README.md
```

---

## Instalación

### Requisitos previos

Arch Linux con `git`, `base-devel` y `stow` instalados.

```bash
sudo pacman -S --needed git base-devel stow
```

### Clonar y ejecutar

```bash
git clone https://github.com/alromlll/Stormdot.git ~/Stormdot
cd ~/Stormdot
chmod +x install.sh
./install.sh
```

### Qué hace `install.sh`

1. Verifica dependencias (`git`, `stow`, `yay`).
2. Instala paquetes base con `pacman` y AUR con `yay`.
3. Hace **backup** automático de configs existentes que entrarían en conflicto.
4. Ejecuta `stow` para todos los paquetes stowables.
5. Restaura ajustes de gedit con `dconf load`.
6. Habilita servicios systemd necesarios.
7. Imprime un resumen al final.

El script es **idempotente** — ejecutarlo varias veces no rompe nada.

### Stow manualmente

Si solo quieres aplicar un paquete sin correr todo `install.sh`:

```bash
cd ~/Stormdot

# Aplicar
stow --target="$HOME" hypr

# Re-aplicar (después de cambios)
stow --target="$HOME" --restow hypr

# Eliminar (quitar symlinks, no borra el repo)
stow --target="$HOME" --delete hypr

# Aplicar todos los stowables a la vez
stow --target="$HOME" hypr waybar kitty fish starship dunst nvim git bash
```

---

## Convenciones

- **Un paquete por herramienta.** No mezclar configs de apps distintas.
- **Comentarios obligatorios** en cualquier keybind o setting no obvio.
- **Cero secrets en el repo.** Claves SSH, tokens, IPs privadas → variables de entorno locales o `.gitignore`. Si lo ves hardcodeado, es un bug.
- **Scripts idempotentes.** Todo lo que está en `scripts/` puede ejecutarse múltiples veces sin efectos secundarios.

---

## Contexto

Este repo es parte de **Proyecto Argus** — homelab personal sobre Proxmox.
Algunos scripts en `scripts/` interactúan con la infraestructura del homelab
(Raspberry Pi gateway, VMs vía SSH, sync de vault Obsidian via rsync).
Las credenciales y direcciones de red son siempre externas al repo.

---

## Lo que NO está aquí

- Datos de perfil del navegador.
- Claves SSH o tokens.
- IPs o hostnames del homelab.
- Temas o wallpapers de terceros con licencia restrictiva.

---

## Licencia

Unlicense — dominio público. Úsalo, fórkalo, rómpelo. Sin restricciones.
