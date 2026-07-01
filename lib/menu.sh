#!/usr/bin/env bash
# menu.sh - main menu rendering and navigation for Foxfolio
#
# The main menu box and the top-level navigation loop. Page content
# lives in lib/pages.sh — this file just decides which page to call.

FOX_MENU_ITEMS=(
    "about:About"
    "skills:Skills"
    "projects:Projects"
    "services:Services"
    "contact:Contact"
    "github:GitHub"
    "exit:Exit"
)

# fox::menu_render
# Draws the main menu in a box, one item per line.
fox::menu_render() {
    local width
    width="$(fox::box_width)"

    fox::box_top "$width"
    fox::box_line_centered "$width" "Main Menu" "${FOX_BOLD}${FOX_COLOR_PRIMARY}"
    fox::box_divider "$width"

    local i=1
    local entry key label icon
    for entry in "${FOX_MENU_ITEMS[@]}"; do
        key="${entry%%:*}"
        label="${entry#*:}"
        icon="$(fox::icon "$key")"
        fox::box_line "$width" "  $i) $icon  $label"
        (( i++ ))
    done

    fox::box_bottom "$width"
}

# fox::menu_dispatch <key>
# Calls the matching fox::page_* function. Falls back to a "coming soon"
# notice if one doesn't exist yet, so an incomplete config never crashes.
fox::menu_dispatch() {
    local key="$1"
    local func="fox::page_${key}"

    if declare -F "$func" > /dev/null 2>&1; then
        "$func"
    else
        local width
        width="$(fox::box_width)"
        fox::box_top "$width"
        fox::box_line_centered "$width" "$key" "${FOX_BOLD}${FOX_COLOR_PRIMARY}"
        fox::box_divider "$width"
        fox::box_line "$width" "This page isn't available yet." "$FOX_COLOR_MUTED"
        fox::box_bottom "$width"
        fox::press_enter_to_continue
    fi
}

# fox::menu_loop
# Renders the banner + menu, reads a choice, dispatches to that page
# (or exits cleanly).
fox::menu_loop() {
    local choice key

    while true; do
        fox::anim_clear_transition
        fox::render_banner
        fox::spacer
        fox::menu_render
        fox::spacer

        fox::color_print "$FOX_COLOR_ACCENT" "Select an option [1-${#FOX_MENU_ITEMS[@]}]: "
        read -r choice

        if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#FOX_MENU_ITEMS[@]} )); then
            fox::status warning "Please enter a number between 1 and ${#FOX_MENU_ITEMS[@]}."
            sleep 1
            continue
        fi

        key="${FOX_MENU_ITEMS[$((choice - 1))]%%:*}"

        case "$key" in
            exit)
                return 0
                ;;
            *)
                fox::anim_clear_transition
                fox::menu_dispatch "$key"
                ;;
        esac
    done
}
