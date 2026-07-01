#!/usr/bin/env bash
# colors.sh - ANSI color constants and print helpers for Foxfolio
#
# Raw ANSI codes and small print helpers only — layout lives in ui.sh.

# --- Reset / styles ---------------------------------------------------------
FOX_RESET='\033[0m'
FOX_BOLD='\033[1m'
FOX_DIM='\033[2m'
FOX_ITALIC='\033[3m'
FOX_UNDERLINE='\033[4m'

# --- Standard foreground colors ---------------------------------------------
FOX_FG_BLACK='\033[30m'
FOX_FG_RED='\033[31m'
FOX_FG_GREEN='\033[32m'
FOX_FG_YELLOW='\033[33m'
FOX_FG_BLUE='\033[34m'
FOX_FG_MAGENTA='\033[35m'
FOX_FG_CYAN='\033[36m'
FOX_FG_WHITE='\033[37m'

# --- Bright foreground colors -------------------------------------------------
FOX_FG_BRIGHT_BLACK='\033[90m'
FOX_FG_BRIGHT_RED='\033[91m'
FOX_FG_BRIGHT_GREEN='\033[92m'
FOX_FG_BRIGHT_YELLOW='\033[93m'
FOX_FG_BRIGHT_BLUE='\033[94m'
FOX_FG_BRIGHT_MAGENTA='\033[95m'
FOX_FG_BRIGHT_CYAN='\033[96m'
FOX_FG_BRIGHT_WHITE='\033[97m'

# --- Semantic aliases --------------------------------------------------------
# Reference these, not the raw codes above — theme.sh swaps them at runtime.
FOX_COLOR_PRIMARY="$FOX_FG_CYAN"
FOX_COLOR_BORDER="$FOX_FG_CYAN"
FOX_COLOR_ACCENT="$FOX_FG_MAGENTA"
FOX_COLOR_SUCCESS="$FOX_FG_GREEN"
FOX_COLOR_WARNING="$FOX_FG_YELLOW"
FOX_COLOR_ERROR="$FOX_FG_RED"
FOX_COLOR_MUTED="$FOX_FG_BRIGHT_BLACK"
FOX_COLOR_TEXT="$FOX_FG_WHITE"

# "default" means the built-in palette above; theme.sh overrides this.
FOX_ACTIVE_THEME="default"

# fox::rgb <r> <g> <b>
# 24-bit truecolor escape sequence, used by themes/*.sh to set exact colors.
fox::rgb() {
    printf '\033[38;2;%d;%d;%dm' "$1" "$2" "$3"
}

# fox::color_print <color> <text...>
# Prints text in a color, then resets. No trailing newline.
fox::color_print() {
    local color="$1"
    shift
    printf '%b%s%b' "$color" "$*" "$FOX_RESET"
}

# fox::color_println <color> <text...>
fox::color_println() {
    fox::color_print "$@"
    printf '\n'
}

# fox::supports_color
# True if stdout is a TTY and TERM isn't "dumb".
fox::supports_color() {
    [[ -t 1 ]] && [[ "${TERM:-dumb}" != "dumb" ]]
}

# fox::unicode_supported
# True if the locale claims UTF-8. Everything that draws a box, bullet,
# spinner, or icon checks FOX_UNICODE_SUPPORTED (set once below) instead
# of calling this directly, and falls back to plain ASCII when it's false.
fox::unicode_supported() {
    local locale="${LC_ALL:-${LC_CTYPE:-${LANG:-}}}"
    locale="${locale,,}"
    [[ "$locale" == *utf-8* || "$locale" == *utf8* ]]
}

if fox::unicode_supported; then
    FOX_UNICODE_SUPPORTED=true
else
    FOX_UNICODE_SUPPORTED=false
fi
