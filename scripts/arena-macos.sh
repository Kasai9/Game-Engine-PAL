#!/usr/bin/env bash
# Run from any folder: ./scripts/arena-macos.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != 'Darwin' ]]; then
  echo 'This launcher is intended for macOS.' >&2
  exit 1
fi
if ! command -v alr >/dev/null 2>&1; then
  echo 'Alire (alr) is missing from PATH.' >&2
  exit 1
fi

# Use Homebrew SDL3 when installed; also accepts pkg-config-managed SDL3.
SDL_LIB=''
if command -v brew >/dev/null 2>&1 && brew --prefix sdl3 >/dev/null 2>&1; then
  SDL_LIB="$(brew --prefix sdl3)/lib"
elif command -v pkg-config >/dev/null 2>&1 && pkg-config --exists sdl3; then
  SDL_LIB="$(pkg-config --variable=libdir sdl3)"
fi
if [[ -z "$SDL_LIB" || ! -d "$SDL_LIB" ]]; then
  echo 'SDL3 library not detected. Install SDL3 with Homebrew or configure pkg-config.' >&2
  exit 1
fi

export YARLIB_HOST_OS='macos'
export LIBRARY_PATH="$SDL_LIB${LIBRARY_PATH:+:$LIBRARY_PATH}"
export DYLD_FALLBACK_LIBRARY_PATH="$SDL_LIB${DYLD_FALLBACK_LIBRARY_PATH:+:$DYLD_FALLBACK_LIBRARY_PATH}"

cd "$ROOT"
echo 'Building YARLib (macOS)...'
alr build
cd "$ROOT/showcase"
echo 'Building showcase...'
alr build
echo 'Launching Arena...'
./bin/arena
