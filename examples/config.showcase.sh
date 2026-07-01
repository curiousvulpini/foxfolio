#!/usr/bin/env bash
# A fully-populated example with every section filled in — handy as a
# reference when writing your own. Copy it over config.sh to use it:
#   cp examples/config.showcase.sh config.sh

# --- Appearance --------------------------------------------------------------
FOX_THEME="catppuccin"
FOX_ANIMATIONS_ENABLED=true
FOX_ANIMATION_SPEED="normal"
FOX_USE_NERD_FONT=true           # requires a Nerd Font in your terminal

# --- Author info ---------------------------------------------------------------
FOX_AUTHOR_NAME="Alex Rivera"
FOX_AUTHOR_TITLE="Full-Stack Developer & Open Source Maintainer"
FOX_AUTHOR_BIO="I design and build developer tools, with a soft spot for \
terminal UIs and anything that makes a workflow feel a little more fun."

# --- Links -----------------------------------------------------------------------
FOX_LINK_GITHUB="https://github.com/alexrivera"
FOX_LINK_WEBSITE="https://alexrivera.dev"
FOX_LINK_EMAIL="alex@alexrivera.dev"
FOX_LINK_LINKEDIN="https://linkedin.com/in/alexrivera"

# --- Content pages -----------------------------------------------------------
FOX_SKILLS=(
    "Languages|Bash, TypeScript, Python, Rust"
    "Frontend|React, Vue, Tailwind CSS"
    "Backend|Node.js, PostgreSQL, Redis"
    "DevOps|Docker, GitHub Actions, Terraform"
)

FOX_PROJECTS=(
    "Foxfolio|An interactive, themeable terminal portfolio written in Bash.|https://github.com/alexrivera/foxfolio"
    "dotstash|A fast, tag-based dotfiles manager.|https://github.com/alexrivera/dotstash"
    "cli-weather|A minimal weather CLI with ASCII forecasts.|https://github.com/alexrivera/cli-weather"
)

FOX_SERVICES=(
    "Web Development|End-to-end web app design and development."
    "Technical Consulting|Architecture reviews and code audits."
    "CLI Tooling|Custom command-line tools for internal workflows."
)

FOX_GITHUB_REPOS=(
    "foxfolio|The project you're looking at right now."
    "dotstash|Tag-based dotfiles manager with rollback support."
)

# --- Banner ------------------------------------------------------------------------
FOX_BANNER_NAME="fox"
FOX_BANNER_PATH=""
