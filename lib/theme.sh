#!/usr/bin/env bash
# theme.sh - runtime theme loading for Foxfolio
#
# Discovers and loads theme files from themes/, falling back gracefully
# to the built-in default palette (colors.sh) when a theme is missing
# or invalid. Theme files only ever set FOX_COLOR_* variables — no
# functions, no side effects — so sourcing one is always safe.

# fox::theme_list
# Names every available theme (one per line) from the .sh files in
# FOX_THEME_DIR. "default" always comes first.
fox::theme_list() {
    printf 'default\n'

    local dir="${FOX_THEME_DIR:-}"
    [[ -d "$dir" ]] || return 0

    local file
    for file in "$dir"/*.sh; do
        [[ -e "$file" ]] || continue
        basename "$file" .sh
    done
}

# fox::theme_load [name]
# Sources themes/<name>.sh, overriding the default FOX_COLOR_* values.
# "default" (or empty) keeps the built-in palette as-is.
#
# Returns 0 and sets FOX_ACTIVE_THEME on success. On a missing/unreadable
# theme, leaves the default palette untouched, sets FOX_ACTIVE_THEME to
# "default", and returns 1 — a misspelled theme name should never stop
# Foxfolio from starting.
fox::theme_load() {
    local name="${1:-${FOX_THEME:-default}}"

    if [[ -z "$name" || "$name" == "default" ]]; then
        FOX_ACTIVE_THEME="default"
        return 0
    fi

    local dir="${FOX_THEME_DIR:-}"
    local path="$dir/$name.sh"

    if [[ -n "$dir" && -f "$path" && -r "$path" ]]; then
        # shellcheck source=/dev/null
        source "$path"
        FOX_ACTIVE_THEME="$name"
        return 0
    fi

    FOX_ACTIVE_THEME="default"
    return 1
}
