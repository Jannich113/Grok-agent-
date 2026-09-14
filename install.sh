#!/usr/bin/env bash
# Option B installer: copy this kit into an app repo or ~/.grok
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'EOF'
Install the Grok App Builder kit (Option B).

Usage:
  ./install.sh --project /path/to/app    Copy skills + AGENTS.md into an app repo
  ./install.sh --user                    Copy skills to ~/.grok/skills (all projects)
  ./install.sh --help

Option A (Grok Bot / Custom Agent) needs no install — point the agent at:
  https://github.com/Jannich113/Grok-agent-
See README.md and docs/SETUP.md.
EOF
}

copy_skills() {
  local dest="$1"
  mkdir -p "$dest"
  # Copy each skill folder. Overwrite same-name kit skills; leave others alone.
  local name
  for name in "$KIT/.grok/skills"/*; do
    [ -d "$name" ] || continue
    rm -rf "$dest/$(basename "$name")"
    cp -R "$name" "$dest/"
  done
  if [ -f "$KIT/.grok/skills/README.md" ]; then
    cp "$KIT/.grok/skills/README.md" "$dest/README.md"
  fi
  echo "Skills -> $dest"
}

install_project() {
  local target="${1:-}"
  if [ -z "$target" ]; then
    echo "error: --project needs a path" >&2
    exit 1
  fi
  if [ ! -d "$target" ]; then
    echo "error: not a directory: $target" >&2
    exit 1
  fi
  target="$(cd "$target" && pwd)"
  if [ "$target" = "$KIT" ]; then
    echo "error: refuse to install the kit into itself" >&2
    exit 1
  fi

  copy_skills "$target/.grok/skills"

  if [ ! -f "$target/AGENTS.md" ]; then
    cp "$KIT/AGENTS.md" "$target/AGENTS.md"
    echo "AGENTS.md -> $target/AGENTS.md"
  else
    cp "$KIT/AGENTS.md" "$target/AGENTS.app-builder.md"
    echo "app already has AGENTS.md"
    echo "kit contract -> $target/AGENTS.app-builder.md"
    echo "Add a pointer from AGENTS.md:"
    echo "  App-builder rules: also follow AGENTS.app-builder.md and .grok/skills/."
  fi

  mkdir -p "$target/.grok"
  cp "$KIT/docs/PORTABILITY.md" "$target/.grok/PORTABILITY.md"

  echo
  echo "Done. In the app repo run:  grok inspect"
}

install_user() {
  local dest="${HOME}/.grok/skills"
  copy_skills "$dest"
  mkdir -p "${HOME}/.grok"
  if [ ! -f "${HOME}/.grok/AGENTS.md" ]; then
    cp "$KIT/AGENTS.md" "${HOME}/.grok/AGENTS.md"
    echo "AGENTS.md -> ${HOME}/.grok/AGENTS.md"
  else
    echo "left existing ${HOME}/.grok/AGENTS.md in place"
    echo "kit copy at ${HOME}/.grok/AGENTS.app-builder.md"
    cp "$KIT/AGENTS.md" "${HOME}/.grok/AGENTS.app-builder.md"
  fi
  echo
  echo "Done. User skills load for every Grok Build project on this machine."
}

case "${1:-}" in
  --project)
    install_project "${2:-}"
    ;;
  --user)
    install_user
    ;;
  --help|-h|"")
    usage
    [ -n "${1:-}" ] || exit 1
    ;;
  *)
    echo "error: unknown flag: $1" >&2
    usage
    exit 1
    ;;
esac
