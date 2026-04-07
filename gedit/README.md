# Gedit settings

Gedit guarda su configuración en **dconf** (la base de datos de GNOME),
no en un archivo de texto plano. Por eso no hay un `gedit.conf` que
versionar directamente.

## Workflow

### Exportar settings actuales al repo

```bash
dconf dump /org/gnome/gedit/ > ~/stormdot/gedit/gedit-settings
```

Esto vuelca todo bajo `/org/gnome/gedit/` (preferencias, plugins,
encoding, etc.) a un archivo de texto plano que SÍ se puede commitear.

### Restaurar settings desde el repo

```bash
dconf load /org/gnome/gedit/ < ~/stormdot/gedit/gedit-settings
```

`install.sh` hará esto automáticamente si detecta el archivo.

## Settings recomendados (aplicar a mano una vez, luego exportar)

Abre gedit → Preferences → y configura:

| Sección | Setting | Valor |
|---|---|---|
| View → Display | Show line numbers | ✓ |
| View → Display | Highlight current line | ✓ |
| View → Display | Highlight matching brackets | ✓ |
| View → Display | Right margin at column | 100 |
| Editor → Tab stops | Tab width | 4 |
| Editor → Tab stops | Insert spaces instead of tabs | ✓ |
| Editor → Auto-save | Create backup copy | ✗ |
| Font & Colors | Use the system fixed width font | ✗ |
| Font & Colors | Editor font | JetBrainsMono Nerd Font 11 |
| Font & Colors | Color scheme | Oblivion (lo más cercano a Nord disponible por defecto) |

Una vez configurado a tu gusto, exporta con el comando de arriba y
commitea el archivo `gedit-settings` resultante.

## Plugin recomendado

`gedit-plugins` (paquete de Arch): añade snippets, soporte git,
multi-edit, color picker, file browser.

```bash
sudo pacman -S gedit-plugins
```

Después actívalos en Preferences → Plugins.
