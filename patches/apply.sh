#!/usr/bin/env bash
# Переналожить локальные патчи на vendor/ (клон Hermes) после переустановки/обновления.
# Идемпотентно: пропускает уже наложенные патчи.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR="$ROOT/vendor"
PATCHES="$ROOT/patches"

for p in "$PATCHES"/*.patch; do
  [ -e "$p" ] || continue
  name="$(basename "$p")"
  if git -C "$VENDOR" apply --reverse --check "$p" >/dev/null 2>&1; then
    echo "= уже наложен: $name"
  elif git -C "$VENDOR" apply --check "$p" >/dev/null 2>&1; then
    git -C "$VENDOR" apply "$p" && echo "+ наложен: $name"
  else
    echo "! не накладывается (конфликт?): $name — проверь вручную" >&2
  fi
done
echo "Готово. Перезапусти: sudo systemctl restart hermes-gateway"
