# scripts/

Scripts personales del operador. Se enlazan a `~/scripts/` (vía install.sh).

## Inventario

_(pendiente de poblar)_

## Convenciones

- **Idempotencia obligatoria:** ejecutar dos veces no debe romper nada.
- **Sin credenciales hardcodeadas:** usar variables de entorno o `~/.config/secrets.env`.
- **Header descriptivo:** primera línea de comentarios = qué hace y cómo se usa.
- **`set -euo pipefail`** al inicio de scripts bash.
- **Cada script documentado aquí** cuando se añada.

## Plantilla

```bash
#!/usr/bin/env bash
# =============================================================================
# script-name.sh · Descripción de una línea
# Uso: script-name.sh [args]
# =============================================================================

set -euo pipefail

# ... lógica
```
