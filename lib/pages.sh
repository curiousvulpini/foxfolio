#!/usr/bin/env bash
# pages.sh - content pages for Foxfolio
#
# Renders the six content pages (About, Skills, Projects, Services,
# Contact, GitHub) from data in config.sh. They all share one layout,
# fox::page_scrollable, which paginates long content and always returns
# to the menu cleanly. Navigation itself lives in lib/menu.sh.

# fox::page_scrollable <title> <lines_array_name>
# Renders <title> and the given lines inside a box, paginating
# automatically once there's more content than fits on one screen.
# Blocks until the user returns to the menu.
fox::page_scrollable() {
    local title="$1"
    local -n _fox_page_lines="$2"

    local width
    width="$(fox::box_width)"

    local per_page=12
    local total=${#_fox_page_lines[@]}
    local pages=$(( (total + per_page - 1) / per_page ))
    (( pages < 1 )) && pages=1
    local page=1
    local redraw=true

    while true; do
        if [[ "$redraw" == true ]]; then
            fox::box_top "$width"
            fox::box_line_centered "$width" "$title" "${FOX_BOLD}${FOX_COLOR_PRIMARY}"
            fox::box_divider "$width"

            if (( total == 0 )); then
                fox::box_line "$width" "Nothing here yet — edit config.sh to add content." "$FOX_COLOR_MUTED"
            else
                local start=$(( (page - 1) * per_page ))
                local end=$(( start + per_page - 1 ))
                (( end >= total )) && end=$(( total - 1 ))
                local i
                for (( i = start; i <= end; i++ )); do
                    fox::box_line "$width" "${_fox_page_lines[i]}"
                done
            fi

            if (( pages > 1 )); then
                fox::box_divider "$width"
                fox::box_line_centered "$width" "Page $page / $pages" "$FOX_COLOR_MUTED"
            fi

            fox::box_bottom "$width"
        fi

        if (( pages > 1 )); then
            fox::color_print "$FOX_COLOR_MUTED" "[n]ext  [p]revious  [enter] return: "
            local key
            read -r key
            case "$key" in
                n|N)
                    if (( page < pages )); then
                        page=$(( page + 1 ))
                        fox::anim_clear_transition
                        redraw=true
                    else
                        redraw=false
                    fi
                    ;;
                p|P)
                    if (( page > 1 )); then
                        page=$(( page - 1 ))
                        fox::anim_clear_transition
                        redraw=true
                    else
                        redraw=false
                    fi
                    ;;
                *)
                    return 0
                    ;;
            esac
        else
            fox::press_enter_to_continue
            return 0
        fi
    done
}

# fox::page_about
fox::page_about() {
    fox::anim_progress_run 0.35 "Loading About"

    local width wrap_width
    width="$(fox::box_width)"
    wrap_width=$(( width - 6 ))

    local lines=()
    lines+=("${FOX_AUTHOR_NAME:-Anonymous}")
    [[ -n "${FOX_AUTHOR_TITLE:-}" ]] && lines+=("${FOX_AUTHOR_TITLE}")
    lines+=("")

    local bio_lines=()
    fox::text_wrap "${FOX_AUTHOR_BIO:-No bio provided yet — set FOX_AUTHOR_BIO in config.sh.}" "$wrap_width" bio_lines
    lines+=("${bio_lines[@]}")

    fox::page_scrollable "About" lines
}

# fox::page_skills
fox::page_skills() {
    fox::anim_progress_run 0.35 "Loading Skills"

    local width wrap_width
    width="$(fox::box_width)"
    wrap_width=$(( width - 6 ))

    local lines=()
    if (( ${#FOX_SKILLS[@]} == 0 )); then
        lines+=("No skills listed yet — add entries to FOX_SKILLS in config.sh.")
    else
        local entry category skill_list wrapped
        for entry in "${FOX_SKILLS[@]}"; do
            category="${entry%%|*}"
            skill_list="${entry#*|}"
            lines+=("$FOX_CHAR_MARKER ${category}")
            wrapped=()
            fox::text_wrap "$skill_list" "$wrap_width" wrapped
            lines+=("${wrapped[@]}")
            lines+=("")
        done
    fi

    fox::page_scrollable "Skills" lines
}

# fox::page_projects
fox::page_projects() {
    fox::anim_progress_run 0.35 "Loading Projects"

    local width wrap_width
    width="$(fox::box_width)"
    wrap_width=$(( width - 6 ))

    local lines=()
    if (( ${#FOX_PROJECTS[@]} == 0 )); then
        lines+=("No projects listed yet — add entries to FOX_PROJECTS in config.sh.")
    else
        local entry name desc url wrapped
        for entry in "${FOX_PROJECTS[@]}"; do
            IFS='|' read -r name desc url <<< "$entry"
            lines+=("$FOX_CHAR_MARKER ${name}")
            wrapped=()
            fox::text_wrap "$desc" "$wrap_width" wrapped
            lines+=("${wrapped[@]}")
            [[ -n "$url" ]] && lines+=("  ${url}")
            lines+=("")
        done
    fi

    fox::page_scrollable "Projects" lines
}

# fox::page_services
fox::page_services() {
    fox::anim_progress_run 0.35 "Loading Services"

    local width wrap_width
    width="$(fox::box_width)"
    wrap_width=$(( width - 6 ))

    local lines=()
    if (( ${#FOX_SERVICES[@]} == 0 )); then
        lines+=("No services listed yet — add entries to FOX_SERVICES in config.sh.")
    else
        local entry name desc wrapped
        for entry in "${FOX_SERVICES[@]}"; do
            name="${entry%%|*}"
            desc="${entry#*|}"
            lines+=("$FOX_CHAR_MARKER ${name}")
            wrapped=()
            fox::text_wrap "$desc" "$wrap_width" wrapped
            lines+=("${wrapped[@]}")
            lines+=("")
        done
    fi

    fox::page_scrollable "Services" lines
}

# fox::page_contact
fox::page_contact() {
    fox::anim_progress_run 0.35 "Loading Contact"

    local lines=()
    lines+=("$(fox::icon contact) Email      ${FOX_LINK_EMAIL:-not set}")
    lines+=("$(fox::icon github)  GitHub     ${FOX_LINK_GITHUB:-not set}")
    lines+=("$(fox::icon link)    Website    ${FOX_LINK_WEBSITE:-not set}")
    lines+=("$(fox::icon link)    LinkedIn   ${FOX_LINK_LINKEDIN:-not set}")

    fox::page_scrollable "Contact" lines
}

# fox::page_github
fox::page_github() {
    fox::anim_progress_run 0.35 "Loading GitHub"

    local width wrap_width
    width="$(fox::box_width)"
    wrap_width=$(( width - 6 ))

    local lines=()
    lines+=("Profile: ${FOX_LINK_GITHUB:-not set}")
    lines+=("")

    if (( ${#FOX_GITHUB_REPOS[@]} == 0 )); then
        lines+=("Add FOX_GITHUB_REPOS entries in config.sh to feature")
        lines+=("specific repositories here.")
    else
        local entry name desc wrapped
        for entry in "${FOX_GITHUB_REPOS[@]}"; do
            name="${entry%%|*}"
            desc="${entry#*|}"
            lines+=("$FOX_CHAR_MARKER ${name}")
            wrapped=()
            fox::text_wrap "$desc" "$wrap_width" wrapped
            lines+=("${wrapped[@]}")
            lines+=("")
        done
    fi

    fox::page_scrollable "GitHub" lines
}
