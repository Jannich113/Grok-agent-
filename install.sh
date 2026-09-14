#!/usr/bin/env bash
# Option B: portable kit into an app or ~/.grok
# Option C: sandbox contract into a Grok App Builder workspace
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'EOF'
Install the Grok App Builder kit.

Option B (portable — Grok Build CLI / laptop):
  ./install.sh --project /path/to/app    Skills + portable AGENTS.md into an app repo
  ./install.sh --user                    Skills to ~/.grok/skills (all projects)

Option C (Grok App Builder sandbox):
  ./install.sh --sandbox /workspace      Sandbox AGENTS.md + references + skills
  ./install.sh --sandbox /path/to/ws

Option A (Grok Bot / Custom Agent) needs no install — point the agent at:
  https://github.com/Jannich113/Grok-agent-

See README.md and docs/SETUP.md.
EOF
}

die() { echo "error: $*" >&2; exit 1; }

resolve_target() {
  local target="${1:-}"
  [ -n "$target" ] || die "$2 needs a path"
  [ -d "$target" ] || die "not a directory: $target"
  target="$(cd "$target" && pwd)"
  [ "$target" != "$KIT" ] || die "refuse to install the kit into itself"
  printf '%s\n' "$target"
}

copy_skills() {
  local dest="$1"
  mkdir -p "$dest"
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

copy_references() {
  local dest="$1"
  mkdir -p "$dest"
  local f
  for f in "$KIT/sandbox/references"/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$dest/"
  done
  echo "References -> $dest"
}

install_project() {
  local target
  target="$(resolve_target "${1:-}" "--project")"

  copy_skills "$target/.grok/skills"

  if [ ! -f "$target/AGENTS.md" ]; then
    cp "$KIT/AGENTS.md" "$target/AGENTS.md"
    echo "AGENTS.md -> $target/AGENTS.md  (portable / Option B)"
  else
    cp "$KIT/AGENTS.md" "$target/AGENTS.app-builder.md"
    echo "app already has AGENTS.md"
    echo "portable kit -> $target/AGENTS.app-builder.md"
    echo "Add a pointer from AGENTS.md:"
    echo "  App-builder rules: also follow AGENTS.app-builder.md and .grok/skills/."
  fi

  mkdir -p "$target/.grok"
  cp "$KIT/docs/PORTABILITY.md" "$target/.grok/PORTABILITY.md"

  echo
  echo "Done (Option B). In the app repo run:  grok inspect"
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
    cp "$KIT/AGENTS.md" "${HOME}/.grok/AGENTS.app-builder.md"
    echo "portable kit -> ${HOME}/.grok/AGENTS.app-builder.md"
  fi
  echo
  echo "Done (Option B user). Skills load for every Grok Build project on this machine."
}

install_sandbox() {
  local target="${1:-}"
  if [ -z "$target" ] && [ -d /workspace ]; then
    target=/workspace
    echo "defaulting --sandbox target to /workspace"
  fi
  target="$(resolve_target "$target" "--sandbox")"

  copy_skills "$target/.grok/skills"
  copy_references "$target/.grok/references"

  cp "$KIT/sandbox/AGENTS.md" "$target/AGENTS.sandbox.md"
  cp "$KIT/sandbox/DETECT.md" "$target/.grok/DETECT.md"
  cp "$KIT/docs/PORTABILITY.md" "$target/.grok/PORTABILITY.md"

  if [ ! -f "$target/AGENTS.md" ]; then
    cp "$KIT/sandbox/AGENTS.md" "$target/AGENTS.md"
    echo "AGENTS.md -> $target/AGENTS.md  (sandbox / Option C)"
  else
    echo "left existing $target/AGENTS.md in place (platform may own it)"
    echo "sandbox snapshot -> $target/AGENTS.sandbox.md"
    echo "Inside Grok App Builder, follow the STRICTER of AGENTS.md and AGENTS.sandbox.md:"
    echo "  0.0.0.0:8080, startup.sh, npm run dev, PreviewHostBridge, browser-smoke."
  fi

  echo
  echo "Done (Option C). Open sandbox/DETECT.md if you are unsure you belong here."
}

case "${1:-}" in
  --project)  install_project "${2:-}" ;;
  --user)     install_user ;;
  --sandbox)  install_sandbox "${2:-}" ;;
  --help|-h)  usage ;;
  "")         usage; exit 1 ;;
  *)          echo "error: unknown flag: $1" >&2; usage; exit 1 ;;
esac
