# ┌─────────────────────────────────────────────────────────────┐
# │  Stormdot · abbr.fish                                       │
# │  Abbreviations: se expanden al pulsar espacio/enter y       │
# │  dejan el comando completo en el historial (mejor que alias)│
# └─────────────────────────────────────────────────────────────┘
#
# Cómo funcionan: escribes `gs` + espacio → se expande a `git status `
# Para añadir una nueva:   abbr -a NOMBRE 'comando completo'
# Para borrar una:         abbr -e NOMBRE
# Para listar todas:       abbr --show


# ══════════════════════════════════════════════════════════════
#   SISTEMA Y NAVEGACIÓN
# ══════════════════════════════════════════════════════════════

# ls moderno con eza si está instalado (fallback a ls)
if command -q eza
    abbr -a l   'eza --icons --group-directories-first'
    abbr -a ll  'eza -l --icons --group-directories-first --git'
    abbr -a la  'eza -la --icons --group-directories-first --git'
    abbr -a lt  'eza --tree --level=2 --icons'
    abbr -a ltt 'eza --tree --level=3 --icons'
else
    abbr -a l   'ls --color=auto'
    abbr -a ll  'ls -lh --color=auto'
    abbr -a la  'ls -lah --color=auto'
end

# cat con bat
command -q bat; and abbr -a cat 'bat --paging=never'

# find con fd
command -q fd; and abbr -a find fd

# Navegación
abbr -a ..    'cd ..'
abbr -a ...   'cd ../..'
abbr -a ....  'cd ../../..'
abbr -a -     'cd -'

# Directorios frecuentes
abbr -a cfg    'cd ~/.config'
abbr -a dot    'cd ~/stormdot'
abbr -a vault  'cd ~/Vault'
abbr -a proj   'cd ~/Projects'
abbr -a dl     'cd ~/Downloads'
abbr -a doc    'cd ~/Documents'
abbr -a pic    'cd ~/Pictures'

# Utilidades
abbr -a mkd   'mkdir -p'
abbr -a h     'history'
abbr -a c     'clear'
abbr -a e     'exit'
abbr -a v     'nvim'
abbr -a sv    'sudo nvim'
abbr -a g     'grep --color=auto'
abbr -a rgf   'rg --files'
abbr -a df    'df -h'
abbr -a du    'du -h --max-depth=1'
abbr -a free  'free -h'
abbr -a path  'echo $PATH | tr " " "\n"'


# ══════════════════════════════════════════════════════════════
#   PACMAN / YAY
# ══════════════════════════════════════════════════════════════

abbr -a pac    'sudo pacman -S'           # Instalar
abbr -a pacu   'sudo pacman -Syu'         # Actualizar todo
abbr -a pacr   'sudo pacman -Rns'         # Eliminar paquete + deps
abbr -a pacs   'pacman -Ss'               # Buscar
abbr -a pacq   'pacman -Qs'               # Listar instalados (grep)
abbr -a pacqi  'pacman -Qi'               # Info paquete instalado
abbr -a pacqe  'pacman -Qe'               # Listar instalados explícitamente
abbr -a pacql  'pacman -Ql'               # Archivos de un paquete
abbr -a pacqo  'pacman -Qo'               # Qué paquete tiene este archivo
abbr -a pacorp 'pacman -Qtdq | sudo pacman -Rns -'  # Limpiar huérfanos
abbr -a pacmir 'sudo reflector --latest 10 --country Spain,France --sort rate --save /etc/pacman.d/mirrorlist'

abbr -a y      'yay -S'                   # Instalar AUR
abbr -a yu     'yay -Syu'                 # Update completo (pacman+AUR)
abbr -a ys     'yay -Ss'                  # Buscar AUR
abbr -a yr     'yay -Rns'                 # Eliminar AUR


# ══════════════════════════════════════════════════════════════
#   GIT
# ══════════════════════════════════════════════════════════════

abbr -a g         'git'
abbr -a gs        'git status'
abbr -a gss       'git status --short'
abbr -a ga        'git add'
abbr -a gaa       'git add --all'
abbr -a gap       'git add --patch'
abbr -a gc        'git commit'
abbr -a gcm       'git commit -m'
abbr -a gca       'git commit --amend'
abbr -a gcan      'git commit --amend --no-edit'
abbr -a gco       'git checkout'
abbr -a gcb       'git checkout -b'
abbr -a gb        'git branch'
abbr -a gbd       'git branch -d'
abbr -a gbD       'git branch -D'
abbr -a gd        'git diff'
abbr -a gds       'git diff --staged'
abbr -a gl        'git log --oneline --graph --decorate'
abbr -a gla       'git log --oneline --graph --decorate --all'
abbr -a gp        'git push'
abbr -a gpu       'git push -u origin HEAD'
abbr -a gpl       'git pull'
abbr -a gf        'git fetch'
abbr -a gfa       'git fetch --all --prune'
abbr -a gm        'git merge'
abbr -a gr        'git rebase'
abbr -a gri       'git rebase -i'
abbr -a grh       'git reset HEAD'
abbr -a grhh      'git reset --hard HEAD'
abbr -a gst       'git stash'
abbr -a gstp      'git stash pop'
abbr -a gstl      'git stash list'
abbr -a gcl       'git clone'
abbr -a grv       'git remote -v'


# ══════════════════════════════════════════════════════════════
#   DOCKER
# ══════════════════════════════════════════════════════════════

abbr -a d      'docker'
abbr -a dps    'docker ps'
abbr -a dpsa   'docker ps -a'
abbr -a di     'docker images'
abbr -a drm    'docker rm'
abbr -a drmi   'docker rmi'
abbr -a dex    'docker exec -it'
abbr -a dlog   'docker logs -f'
abbr -a dprun  'docker system prune -af'
abbr -a dvol   'docker volume ls'
abbr -a dnet   'docker network ls'

abbr -a dc     'docker compose'
abbr -a dcu    'docker compose up -d'
abbr -a dcd    'docker compose down'
abbr -a dcl    'docker compose logs -f'
abbr -a dcr    'docker compose restart'
abbr -a dcp    'docker compose pull'
abbr -a dcb    'docker compose build'


# ══════════════════════════════════════════════════════════════
#   PYTHON / VENV
# ══════════════════════════════════════════════════════════════

abbr -a py     'python'
abbr -a py3    'python3'
abbr -a pipi   'pip install'
abbr -a pipu   'pip install --upgrade'
abbr -a pipr   'pip install -r requirements.txt'
abbr -a pipf   'pip freeze > requirements.txt'

# venv — crear y activar en una línea
abbr -a venv   'python -m venv .venv && source .venv/bin/activate.fish'
abbr -a va     'source .venv/bin/activate.fish'
abbr -a vd     'deactivate'


# ══════════════════════════════════════════════════════════════
#   SSH / HOMELAB
# ══════════════════════════════════════════════════════════════
#
# ⚠️ Los hostnames deben estar en ~/.ssh/config — nunca IPs hardcodeadas.
# Plantilla para ~/.ssh/config:
#   Host rpigw
#       HostName gateway.local
#       User pi
#       IdentityFile ~/.ssh/id_ed25519
#
# Una vez configurado, estos abbr funcionan solos.

abbr -a srpi   'ssh rpigw'          # Raspberry Pi gateway
abbr -a spve   'ssh pve'            # Proxmox node
abbr -a svm1   'ssh vm1'            # VM genérica 1

# rsync con flags útiles
abbr -a rsy    'rsync -avzhP'
abbr -a rsyd   'rsync -avzhP --delete'


# ══════════════════════════════════════════════════════════════
#   SYSTEMD
# ══════════════════════════════════════════════════════════════

abbr -a sc     'systemctl'
abbr -a scs    'systemctl status'
abbr -a scr    'sudo systemctl restart'
abbr -a scst   'sudo systemctl start'
abbr -a scsp   'sudo systemctl stop'
abbr -a sce    'sudo systemctl enable --now'
abbr -a scd    'sudo systemctl disable --now'
abbr -a jc     'journalctl'
abbr -a jcf    'journalctl -f'
abbr -a jcu    'journalctl -u'
