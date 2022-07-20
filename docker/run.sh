#!/bin/bash

set -e

BASE_DIR=$(dirname "$0")

BIN="$BASE_DIR/bin"
COMMANDS="$BASE_DIR/commands"
HELPERS="$BASE_DIR/helpers"

# Bin sources
source "$BIN/os.sh"
source "$BIN/print.sh"
source "$BIN/dir.sh"
source "$BIN/package.sh"
source "$BIN/execute.sh"

# Helpers sources
source "$HELPERS/check-ports.sh"
source "$HELPERS/check-if-installed.sh"
source "$HELPERS/latest-version.sh"
source "$HELPERS/check-version.sh"
source "$HELPERS/set-env.sh"

# Commands sources
source "$COMMANDS/install.sh"
source "$COMMANDS/update.sh"
source "$COMMANDS/stop.sh"

INPUT=$1
shift

COMMAND=$(echo "$INPUT" | awk '{print tolower($0)}')

info "Fonoster Docker-backed Infrastructure Management 📦 • Current OS: $OS"

case $COMMAND in
install | setup | init | start)
  install "$@"
  ;;
upgrade | update)
  update "$@"
  ;;
stop)
  stop "$@"
  ;;  
*)
  error "Unknown command: $COMMAND"
  ;;
esac
