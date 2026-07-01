#!/usr/bin/env bash
# foxfolio.sh - Foxfolio entry point
#
# Handles startup, initialization, loading libraries, launching the
# menu, and clean exit. No UI/layout logic lives here.

set -uo pipefail

FOX_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOX_LIB_DIR="$FOX_ROOT_DIR/lib"
FOX_THEME_DIR="$FOX_ROOT_DIR/themes"

# fox::require_bash4
# Fails fast with a clear message on unsupported shells (see Shell
# Compatibility in README.md).
fox::require_bash4() {
    if (( BASH_VERSINFO[0] < 4 )); then
        printf 'Foxfolio requires Bash 4.0 or newer (found %s).\n' "$BASH_VERSION" >&2
        exit 1
    fi
}

# fox::load_libs
# Sources every library in lib/. Order matters: colors before anything
# that prints, ui before menu (menu depends on box helpers).
fox::load_libs() {
    local libs=(colors.sh theme.sh ascii.sh ui.sh animation.sh pages.sh menu.sh)
    local lib path
    for lib in "${libs[@]}"; do
        path="$FOX_LIB_DIR/$lib"
        if [[ ! -f "$path" ]]; then
            printf 'Missing required library: %s\n' "$path" >&2
            exit 1
        fi
        # shellcheck source=/dev/null
        source "$path"
    done
}

# fox::load_config
# Sources the user's config.sh if present. Foxfolio still runs on
# built-in defaults if it's missing.
fox::load_config() {
    local config_path="$FOX_ROOT_DIR/config.sh"
    if [[ -f "$config_path" ]]; then
        # shellcheck source=/dev/null
        source "$config_path"
    fi

    # Content arrays are optional in a user's config.sh — default them to
    # empty so `set -u` never trips on a missing declaration, and every
    # page falls back to its own "nothing here yet" message.
    declare -p FOX_SKILLS       &>/dev/null || FOX_SKILLS=()
    declare -p FOX_PROJECTS     &>/dev/null || FOX_PROJECTS=()
    declare -p FOX_SERVICES     &>/dev/null || FOX_SERVICES=()
    declare -p FOX_GITHUB_REPOS &>/dev/null || FOX_GITHUB_REPOS=()
}

# fox::cleanup
# Runs on exit to leave the terminal in a clean state.
fox::cleanup() {
    printf '%b' "$FOX_RESET" 2>/dev/null || true
    tput cnorm 2>/dev/null || true
}

# fox::main
fox::main() {
    fox::require_bash4
    fox::load_libs
    fox::load_config

    trap fox::cleanup EXIT

    local theme_fallback=false
    fox::theme_load "${FOX_THEME:-default}" || theme_fallback=true

    fox::anim_spinner_start "Initializing Foxfolio"
    fox::anim_delay 0.6
    fox::anim_spinner_stop

    if [[ "$theme_fallback" == true ]]; then
        fox::status warning "Theme '${FOX_THEME}' not found — using default colors."
        fox::anim_delay 1.2
    fi

    fox::menu_loop

    clear
    if [[ -n "${FOX_AUTHOR_NAME:-}" ]]; then
        fox::color_println "$FOX_COLOR_PRIMARY" "Thanks for stopping by ${FOX_AUTHOR_NAME}'s portfolio. Goodbye!"
    else
        fox::color_println "$FOX_COLOR_PRIMARY" "Thanks for stopping by. Goodbye!"
    fi
}

fox::main "$@"
