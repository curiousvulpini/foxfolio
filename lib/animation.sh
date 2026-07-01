#!/usr/bin/env bash
# animation.sh - animation helpers for Foxfolio
#
# Optional visual effects: typewriter, spinner, progress bar, delays,
# clear transitions. Everything here degrades to an instant, safe
# no-op when animations are disabled or the terminal isn't interactive —
# callers never need to check the mode themselves.

# --- Speed configuration ----------------------------------------------------

# fox::anim_should_animate
# True only when animations are enabled AND stdout is a TTY. Pipes, CI,
# and redirected output always get the instant fallback.
fox::anim_should_animate() {
    [[ "${FOX_ANIMATIONS_ENABLED:-true}" == true ]] && [[ -t 1 ]]
}

# fox::anim_char_delay
# Per-character delay (seconds) for the typewriter effect.
fox::anim_char_delay() {
    case "${FOX_ANIMATION_SPEED:-normal}" in
        slow) printf '0.045' ;;
        fast) printf '0.006' ;;
        *)    printf '0.018' ;;
    esac
}

# fox::anim_frame_delay
# Per-frame delay (seconds) for the spinner.
fox::anim_frame_delay() {
    case "${FOX_ANIMATION_SPEED:-normal}" in
        slow) printf '0.15' ;;
        fast) printf '0.05' ;;
        *)    printf '0.09' ;;
    esac
}

# fox::anim_wipe_delay
# Per-row delay (seconds) for the clear-screen wipe transition.
fox::anim_wipe_delay() {
    case "${FOX_ANIMATION_SPEED:-normal}" in
        slow) printf '0.02' ;;
        fast) printf '0.004' ;;
        *)    printf '0.01' ;;
    esac
}

# fox::_anim_divide <a> <b>
# Small float division (spreads a duration across progress-bar steps).
# Degrades gracefully if awk is missing, keeping Foxfolio dependency-free.
fox::_anim_divide() {
    local a="$1" b="$2" result
    result="$(awk -v a="$a" -v b="$b" 'BEGIN { printf "%.4f", a / b }' 2>/dev/null)"
    [[ -z "$result" ]] && result="0.03"
    printf '%s' "$result"
}

# --- Delays -------------------------------------------------------------------

# fox::anim_delay <seconds>
# Skipped entirely when animations are off/non-TTY, so scripted or piped
# runs never hang on a cosmetic pause.
fox::anim_delay() {
    local seconds="$1"
    fox::anim_should_animate && sleep "$seconds"
}

# --- Typewriter ---------------------------------------------------------------

# fox::anim_typewriter <text> [char_delay_override]
# Prints text one character at a time, or instantly when animations
# are disabled/non-interactive.
fox::anim_typewriter() {
    local text="$1"
    local delay="${2:-$(fox::anim_char_delay)}"

    if ! fox::anim_should_animate; then
        printf '%s\n' "$text"
        return
    fi

    local i char
    for (( i = 0; i < ${#text}; i++ )); do
        char="${text:i:1}"
        printf '%s' "$char"
        sleep "$delay"
    done
    printf '\n'
}

# --- Spinner --------------------------------------------------------------------

FOX_SPINNER_PID=""
if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
    FOX_SPINNER_FRAMES=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
else
    FOX_SPINNER_FRAMES=('|' '/' '-' '\')
fi

# fox::anim_spinner_start [label]
# Starts a spinner on the current line in a background subshell. No-op
# when animations are off/non-interactive, so there's never a dangling
# background job in scripted contexts.
fox::anim_spinner_start() {
    local label="${1:-Loading}"

    fox::anim_should_animate || return 0

    tput civis 2>/dev/null

    (
        local frame_delay
        frame_delay="$(fox::anim_frame_delay)"
        local i=0
        while true; do
            printf '\r%b%s%b %s' \
                "$FOX_COLOR_ACCENT" "${FOX_SPINNER_FRAMES[i % ${#FOX_SPINNER_FRAMES[@]}]}" "$FOX_RESET" "$label"
            i=$(( i + 1 ))
            sleep "$frame_delay"
        done
    ) &
    disown
    FOX_SPINNER_PID=$!
}

# fox::anim_spinner_stop
fox::anim_spinner_stop() {
    if [[ -n "$FOX_SPINNER_PID" ]]; then
        kill "$FOX_SPINNER_PID" 2>/dev/null
        wait "$FOX_SPINNER_PID" 2>/dev/null
        FOX_SPINNER_PID=""
    fi
    printf '\r\033[K'
    tput cnorm 2>/dev/null
}

# --- Progress bar -----------------------------------------------------------------

# fox::anim_progress_bar <percent> [width] [label]
# One deterministic frame at the given percent (0-100). Safe to call even
# with animations disabled — nothing to skip, it's a single print.
fox::anim_progress_bar() {
    local percent="$1"
    local width="${2:-30}"
    local label="${3:-}"

    (( percent < 0 )) && percent=0
    (( percent > 100 )) && percent=100

    local filled=$(( percent * width / 100 ))
    local empty=$(( width - filled ))

    local fill_char empty_char
    if [[ "$FOX_UNICODE_SUPPORTED" == true ]]; then
        fill_char='█'
        empty_char='░'
    else
        fill_char='#'
        empty_char='-'
    fi

    printf '\r%b[%b%s%b%s%b]%b %3d%%%s' \
        "$FOX_COLOR_TEXT" \
        "$FOX_COLOR_PRIMARY" "$(fox::repeat_char "$fill_char" "$filled")" \
        "$FOX_COLOR_MUTED" "$(fox::repeat_char "$empty_char" "$empty")" \
        "$FOX_RESET" \
        "$FOX_RESET" \
        "$percent" \
        "${label:+ $label}"
}

# fox::anim_progress_run <duration_seconds> [label]
# Animates 0 to 100 over roughly the given duration. No-op when
# animations are off/non-interactive — a skipped loading bar has
# nothing meaningful to convey.
fox::anim_progress_run() {
    local duration="${1:-0.6}"
    local label="${2:-Loading}"

    fox::anim_should_animate || return 0

    tput civis 2>/dev/null

    local steps=20
    local step_delay
    step_delay="$(fox::_anim_divide "$duration" "$steps")"

    local i percent
    for (( i = 1; i <= steps; i++ )); do
        percent=$(( i * 100 / steps ))
        fox::anim_progress_bar "$percent" 30 "$label"
        sleep "$step_delay"
    done

    printf '\r\033[K'
    tput cnorm 2>/dev/null
}

# --- Clear transitions ---------------------------------------------------------

# fox::anim_clear_transition
# A brief downward wipe before clearing the screen. Falls back to a
# plain clear when animations are off/non-interactive.
fox::anim_clear_transition() {
    if ! fox::anim_should_animate; then
        clear
        return
    fi

    local rows cols delay row line
    rows="$(tput lines 2>/dev/null)"
    [[ -z "$rows" ]] && rows=24
    cols="$(fox::term_width)"
    delay="$(fox::anim_wipe_delay)"
    line="$(fox::repeat_char "$FOX_CHAR_HORIZONTAL" "$cols")"

    tput civis 2>/dev/null
    for (( row = 0; row < rows; row++ )); do
        tput cup "$row" 0 2>/dev/null
        printf '%b%s%b' "$FOX_COLOR_MUTED" "$line" "$FOX_RESET"
        sleep "$delay"
    done
    tput cnorm 2>/dev/null
    clear
}
