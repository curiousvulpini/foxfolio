#!/usr/bin/env bash
# ascii.sh - banner loading for Foxfolio
#
# Loads and renders the ASCII banner. Checked in order:
#   1. FOX_BANNER_PATH  - an explicit file path (highest priority)
#   2. FOX_BANNER_NAME   - a named banner in assets/banners/<name>.txt
#   3. built-in default  - always available, never fails
# Drop a new .txt file into assets/banners/ and point FOX_BANNER_NAME at
# it (no extension) to add custom artwork — no code changes needed.

FOX_DEFAULT_BANNER_UNICODE='
  ▄████  ▄██████▄  ▀████▀
 ██▀  ██ ██▀  ▀██   ▐██
 ██      ██    ██   ▐██
 ██▄  ██ ██▄  ▄██   ▐██
  ▀████  ▀██████▀  ▄████▄
       F O X F O L I O
'

# ASCII fallback for terminals/locales without a working UTF-8 charset.
FOX_DEFAULT_BANNER_ASCII='
  +-------------------+
  |      FOXFOLIO      |
  +-------------------+
'

# fox::banner_list
# Names every available banner (one per line), from .txt filenames in
# assets/banners/. "default" (the built-in banner) always comes first.
fox::banner_list() {
    printf 'default\n'

    local dir="${FOX_ROOT_DIR:-.}/assets/banners"
    [[ -d "$dir" ]] || return 0

    local file
    for file in "$dir"/*.txt; do
        [[ -e "$file" ]] || continue
        basename "$file" .txt
    done
}

# fox::load_banner [path]
# Resolves banner text: an explicit [path] arg (or FOX_BANNER_PATH) wins;
# otherwise FOX_BANNER_NAME is looked up in assets/banners/; otherwise the
# built-in default (Unicode or ASCII, per FOX_UNICODE_SUPPORTED). Never
# fails — a missing/unreadable file just falls through to the next option.
fox::load_banner() {
    local path="${1:-${FOX_BANNER_PATH:-}}"

    if [[ -n "$path" && -f "$path" && -r "$path" ]]; then
        cat "$path"
        return 0
    fi

    local name="${FOX_BANNER_NAME:-}"
    if [[ -n "$name" && "$name" != "default" ]]; then
        local named_path="${FOX_ROOT_DIR:-.}/assets/banners/$name.txt"
        if [[ -f "$named_path" && -r "$named_path" ]]; then
            cat "$named_path"
            return 0
        fi
    fi

    if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
        printf '%s' "$FOX_DEFAULT_BANNER_UNICODE"
    else
        printf '%s' "$FOX_DEFAULT_BANNER_ASCII"
    fi
}

# fox::render_banner [path]
# Prints the banner in the primary theme color.
fox::render_banner() {
    local path="${1:-}"
    local banner
    banner="$(fox::load_banner "$path")"
    fox::color_println "$FOX_COLOR_PRIMARY" "$banner"
}
