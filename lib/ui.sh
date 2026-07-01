#!/usr/bin/env bash
# ui.sh - reusable terminal UI primitives for Foxfolio
#
# Boxes, headers, status lines, icons, spacing. Page content is Phase 5's
# job (lib/pages.sh); navigation is menu.sh's.

# --- Glyphs -------------------------------------------------------------------
# Every symbol Foxfolio draws has a plain-ASCII fallback for terminals/
# locales that don't report UTF-8 (see FOX_UNICODE_SUPPORTED in colors.sh).
if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
    FOX_CHAR_TOP_LEFT='╭'
    FOX_CHAR_TOP_RIGHT='╮'
    FOX_CHAR_BOTTOM_LEFT='╰'
    FOX_CHAR_BOTTOM_RIGHT='╯'
    FOX_CHAR_HORIZONTAL='─'
    FOX_CHAR_VERTICAL='│'
    FOX_CHAR_DIVIDER_LEFT='├'
    FOX_CHAR_DIVIDER_RIGHT='┤'
    FOX_CHAR_MARKER='▸'
    FOX_CHAR_ELLIPSIS='…'
else
    FOX_CHAR_TOP_LEFT='+'
    FOX_CHAR_TOP_RIGHT='+'
    FOX_CHAR_BOTTOM_LEFT='+'
    FOX_CHAR_BOTTOM_RIGHT='+'
    FOX_CHAR_HORIZONTAL='-'
    FOX_CHAR_VERTICAL='|'
    FOX_CHAR_DIVIDER_LEFT='+'
    FOX_CHAR_DIVIDER_RIGHT='+'
    FOX_CHAR_MARKER='>'
    FOX_CHAR_ELLIPSIS='...'
fi

# --- Terminal sizing ---------------------------------------------------------

# fox::term_width
# Current terminal width, falling back to 80 when it can't be read
# (piped/non-interactive output).
fox::term_width() {
    local cols
    cols="$(tput cols 2>/dev/null)"
    if [[ -z "$cols" || "$cols" -lt 20 ]]; then
        cols=80
    fi
    printf '%s' "$cols"
}

# fox::box_width
# Terminal width minus a small margin, capped so boxes stay readable on
# very wide terminals.
fox::box_width() {
    local term_w width
    term_w="$(fox::term_width)"
    width=$(( term_w - 4 ))
    (( width > 78 )) && width=78
    (( width < 20 )) && width=20
    printf '%s' "$width"
}

# fox::repeat_char <char> <count>
# Pure-bash repeat (tr mangles multi-byte Unicode characters like ─ or █,
# so it's not used here).
fox::repeat_char() {
    local char="$1"
    local count="$2"
    (( count < 0 )) && count=0
    local out="" i
    for (( i = 0; i < count; i++ )); do
        out+="$char"
    done
    printf '%s' "$out"
}

# --- Boxes -------------------------------------------------------------------
# Rounded corners in Unicode mode, plain +/- corners in ASCII mode — always
# drawn in FOX_COLOR_BORDER so borders stay visually consistent.

# fox::box_top <width>
fox::box_top() {
    local width="$1"
    printf '%b%s%s%s%b\n' "$FOX_COLOR_BORDER" \
        "$FOX_CHAR_TOP_LEFT" "$(fox::repeat_char "$FOX_CHAR_HORIZONTAL" $((width - 2)))" "$FOX_CHAR_TOP_RIGHT" \
        "$FOX_RESET"
}

# fox::box_bottom <width>
fox::box_bottom() {
    local width="$1"
    printf '%b%s%s%s%b\n' "$FOX_COLOR_BORDER" \
        "$FOX_CHAR_BOTTOM_LEFT" "$(fox::repeat_char "$FOX_CHAR_HORIZONTAL" $((width - 2)))" "$FOX_CHAR_BOTTOM_RIGHT" \
        "$FOX_RESET"
}

# fox::box_divider <width>
fox::box_divider() {
    local width="$1"
    printf '%b%s%s%s%b\n' "$FOX_COLOR_BORDER" \
        "$FOX_CHAR_DIVIDER_LEFT" "$(fox::repeat_char "$FOX_CHAR_HORIZONTAL" $((width - 2)))" "$FOX_CHAR_DIVIDER_RIGHT" \
        "$FOX_RESET"
}

# fox::box_line <width> <text> [color]
# One left-aligned line of content, padded to fill the box.
fox::box_line() {
    local width="$1"
    local text="$2"
    local color="${3:-$FOX_COLOR_TEXT}"
    local inner=$(( width - 4 ))
    local text_len=${#text}

    if (( text_len > inner )); then
        local ell_len=${#FOX_CHAR_ELLIPSIS}
        text="${text:0:$((inner - ell_len))}${FOX_CHAR_ELLIPSIS}"
        text_len=${#text}
    fi

    local pad_right=$(( inner - text_len ))
    printf '%b%s%b %b%s%b%*s %b%s%b\n' \
        "$FOX_COLOR_BORDER" "$FOX_CHAR_VERTICAL" "$FOX_RESET" \
        "$color" "$text" "$FOX_RESET" \
        "$pad_right" '' \
        "$FOX_COLOR_BORDER" "$FOX_CHAR_VERTICAL" "$FOX_RESET"
}

# fox::box_line_centered <width> <text> [color]
fox::box_line_centered() {
    local width="$1"
    local text="$2"
    local color="${3:-$FOX_COLOR_TEXT}"
    local inner=$(( width - 4 ))
    local text_len=${#text}

    if (( text_len > inner )); then
        local ell_len=${#FOX_CHAR_ELLIPSIS}
        text="${text:0:$((inner - ell_len))}${FOX_CHAR_ELLIPSIS}"
        text_len=${#text}
    fi

    local total_pad=$(( inner - text_len ))
    local left_pad=$(( total_pad / 2 ))
    local right_pad=$(( total_pad - left_pad ))

    printf '%b%s%b %*s%b%s%b%*s %b%s%b\n' \
        "$FOX_COLOR_BORDER" "$FOX_CHAR_VERTICAL" "$FOX_RESET" \
        "$left_pad" '' \
        "$color" "$text" "$FOX_RESET" \
        "$right_pad" '' \
        "$FOX_COLOR_BORDER" "$FOX_CHAR_VERTICAL" "$FOX_RESET"
}

# fox::box_blank <width>
fox::box_blank() {
    fox::box_line "$1" ""
}

# --- Composite components -----------------------------------------------------

# fox::header <title>
# Full-width box with a centered, bold title.
fox::header() {
    local title="$1"
    local width
    width="$(fox::box_width)"

    fox::box_top "$width"
    fox::box_line_centered "$width" "$title" "${FOX_BOLD}${FOX_COLOR_PRIMARY}"
    fox::box_bottom "$width"
}

# fox::section_title <text>
# A lightweight, non-boxed heading for sub-sections within a page.
fox::section_title() {
    local text="$1"
    fox::color_print "$FOX_COLOR_ACCENT" "$FOX_CHAR_MARKER "
    fox::color_println "${FOX_BOLD}${FOX_COLOR_TEXT}" "$text"
}

# fox::status <type> <message>
# type: success | warning | error | info
fox::status() {
    local type="$1"
    local message="$2"
    local icon color

    if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
        case "$type" in
            success) icon="✔"; color="$FOX_COLOR_SUCCESS" ;;
            warning) icon="⚠"; color="$FOX_COLOR_WARNING" ;;
            error)   icon="✖"; color="$FOX_COLOR_ERROR" ;;
            info)    icon="ℹ"; color="$FOX_COLOR_PRIMARY" ;;
            *)       icon="•"; color="$FOX_COLOR_TEXT" ;;
        esac
    else
        case "$type" in
            success) icon="[OK]"; color="$FOX_COLOR_SUCCESS" ;;
            warning) icon="[!]";  color="$FOX_COLOR_WARNING" ;;
            error)   icon="[X]";  color="$FOX_COLOR_ERROR" ;;
            info)    icon="[i]";  color="$FOX_COLOR_PRIMARY" ;;
            *)       icon="*";    color="$FOX_COLOR_TEXT" ;;
        esac
    fi

    fox::color_print "$color" "$icon "
    fox::color_println "$FOX_COLOR_TEXT" "$message"
}

# fox::spacer [lines]
fox::spacer() {
    local lines="${1:-1}"
    local i
    for (( i = 0; i < lines; i++ )); do
        printf '\n'
    done
}

# fox::text_wrap <text> <width> <out_array_name>
# Pure-bash word wrap (no external tools, keeping Foxfolio dependency-free
# by default). Fills <out_array_name> (via nameref) with one line per
# element, collapsing all whitespace in <text> to single spaces.
fox::text_wrap() {
    local text="$1"
    local width="$2"
    local -n _fox_wrap_out="$3"
    _fox_wrap_out=()

    (( width < 1 )) && width=1

    local line="" word
    for word in $text; do
        if [[ -z "$line" ]]; then
            line="$word"
        elif (( ${#line} + 1 + ${#word} <= width )); then
            line="$line $word"
        else
            _fox_wrap_out+=("$line")
            line="$word"
        fi
    done
    [[ -n "$line" ]] && _fox_wrap_out+=("$line")
    (( ${#_fox_wrap_out[@]} == 0 )) && _fox_wrap_out=("")
}

# fox::press_enter_to_continue [message]
# Shared "return to menu" prompt so wording/spacing stays consistent
# across every content page.
fox::press_enter_to_continue() {
    local message="${1:-Press Enter to return to the menu...}"
    fox::spacer
    fox::color_println "$FOX_COLOR_MUTED" "$message"
    read -r
}

# fox::icon <name>
# Three tiers, checked in order: a Nerd Font glyph (FOX_USE_NERD_FONT=true
# on a Unicode-capable terminal), a plain Unicode symbol, or a bracketed
# ASCII fallback. No emoji at any tier — those render inconsistently
# across terminals and fonts.
fox::icon() {
    local name="$1"
    local nerd="${FOX_USE_NERD_FONT:-false}"

    if [[ "$nerd" == true && "$FOX_UNICODE_SUPPORTED" == true ]]; then
        case "$name" in
            about)    printf '\uf007' ;;
            skills)   printf '\uf0ad' ;;
            projects) printf '\uf1c9' ;;
            services) printf '\uf0eb' ;;
            contact)  printf '\uf0e0' ;;
            github)   printf '\uf09b' ;;
            link)     printf '\uf0c1' ;;
            exit)     printf '\uf011' ;;
            *)        printf '\uf111' ;;
        esac
        return
    fi

    if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
        case "$name" in
            about)    printf '◆' ;;
            skills)   printf '⚙' ;;
            projects) printf '▣' ;;
            services) printf '✦' ;;
            contact)  printf '✉' ;;
            github)   printf '◈' ;;
            link)     printf '↗' ;;
            exit)     printf '⏻' ;;
            *)        printf '•' ;;
        esac
        return
    fi

    case "$name" in
        about)    printf '[@]' ;;
        skills)   printf '[#]' ;;
        projects) printf '[P]' ;;
        services) printf '[S]' ;;
        contact)  printf '[C]' ;;
        github)   printf '[G]' ;;
        link)     printf '[L]' ;;
        exit)     printf '[X]' ;;
        *)        printf '*' ;;
    esac
}
