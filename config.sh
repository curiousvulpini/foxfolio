#!/usr/bin/env bash
# config.sh - your Foxfolio settings
#
# This is the file you'll actually want to open and edit. foxfolio.sh
# sources it once at startup, so any change here takes effect the next
# time you run the script.

# --- Appearance --------------------------------------------------------------
FOX_THEME="tokyo-night"          # tokyo-night | catppuccin | nord | dracula | default
FOX_ANIMATIONS_ENABLED=true      # set false to turn off spinners/typewriter/wipes
FOX_ANIMATION_SPEED="normal"     # slow | normal | fast
FOX_USE_NERD_FONT=false          # set true if your terminal font has Nerd Font glyphs

# Icons and borders adapt automatically: Nerd Font glyphs when enabled
# above, otherwise plain Unicode symbols, or plain ASCII if your locale
# isn't set to UTF-8. Nothing to configure here — Foxfolio detects it.

# --- Author info ---------------------------------------------------------------
FOX_AUTHOR_NAME="Your name! Change in config.sh (nano config.sh)"
FOX_AUTHOR_TITLE="Your Title"
FOX_AUTHOR_BIO="A short bio about yourself goes here."

# --- Links -----------------------------------------------------------------------
FOX_LINK_GITHUB="https://github.com/yourusername"
FOX_LINK_WEBSITE="https://example.com"
FOX_LINK_EMAIL="you@example.com"
FOX_LINK_LINKEDIN="https://linkedin.com/in/yourusername"

# --- Content pages -----------------------------------------------------------
# Each array below feeds one page. Add or remove entries freely — zero
# is fine too, the page just shows a "nothing here yet" message. The
# format each line expects:
#   FOX_SKILLS   "Category|comma, separated, skills"
#   FOX_PROJECTS "Name|Short description|URL"
#   FOX_SERVICES "Service name|Short description"
#   FOX_GITHUB_REPOS "Repo name|Short description"

FOX_SKILLS=(
    "Languages|Bash, Python, JavaScript"
    "Tools|Git, Docker, Linux"
    "Other|Terminal UI design, technical writing"
)

FOX_PROJECTS=(
    "A small command-line application that solves
     a practical problem.
     Repository:
     https://github.com/example/example-cli"
)

FOX_SERVICES=(
    "Web Development|Building fast, accessible websites and web apps."
    "Automation Scripting|Bash/Python tooling to automate repetitive work."
)

FOX_GITHUB_REPOS=(
    "foxfolio|The project you're looking at right now! Replace with your
     repo link!"
)

# --- Banner --------------------------------------------------------------------
# Want a different banner? Set FOX_BANNER_NAME to one of the bundled
# options — "minimal", "fox", or "block" (see assets/banners/README.md).
# Leave it empty (or set it to "default") to use the built-in banner.
FOX_BANNER_NAME=""

# Or point FOX_BANNER_PATH at your own file outside this folder — it
# wins over FOX_BANNER_NAME if you set both.
FOX_BANNER_PATH=""
