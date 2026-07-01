#!/usr/bin/env bash
# A bare-bones, fast-loading setup. Copy it over config.sh to use it:
#   cp examples/config.minimal.sh config.sh

# --- Appearance --------------------------------------------------------------
FOX_THEME="default"
FOX_ANIMATIONS_ENABLED=false     # instant, no spinners/typewriter/wipes
FOX_ANIMATION_SPEED="fast"
FOX_USE_NERD_FONT=false

# --- Author info ---------------------------------------------------------------
FOX_AUTHOR_NAME="Jane Doe"
FOX_AUTHOR_TITLE="Backend Engineer"
FOX_AUTHOR_BIO="I build reliable systems and enjoy a fast terminal."

# --- Links -----------------------------------------------------------------------
FOX_LINK_GITHUB="https://github.com/janedoe"
FOX_LINK_WEBSITE="https://janedoe.dev"
FOX_LINK_EMAIL="jane@janedoe.dev"
FOX_LINK_LINKEDIN="https://linkedin.com/in/janedoe"

# --- Content pages -----------------------------------------------------------
FOX_SKILLS=(
    "Languages|Go, Bash, SQL"
    "Infrastructure|Kubernetes, Terraform, AWS"
)

FOX_PROJECTS=(
    "queue-runner|A lightweight job queue written in Go.|https://github.com/janedoe/queue-runner"
)

FOX_SERVICES=()
FOX_GITHUB_REPOS=()

# --- Banner ------------------------------------------------------------------------
FOX_BANNER_NAME="minimal"
FOX_BANNER_PATH=""
