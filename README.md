# Foxfolio

A polished, open-source, dependency-free (by default) interactive terminal
portfolio written in Bash. It's built to be approachable for beginners,
visually appealing, modular, and easy to make your own.

![status](https://img.shields.io/badge/status-release--candidate-orange)
![shell](https://img.shields.io/badge/shell-bash%204%2B-blue)
![license](https://img.shields.io/badge/license-MIT-green)

```
  ▄████  ▄██████▄  ▀████▀
 ██▀  ██ ██▀  ▀██   ▐██
 ██      ██    ██   ▐██
 ██▄  ██ ██▄  ▄██   ▐██
  ▀████  ▀██████▀  ▄████▄
       F O X F O L I O
```

*(Shown here is the Unicode banner — Foxfolio automatically switches to a
plain-ASCII version on terminals/locales that don't support UTF-8.)*

## What is Foxfolio?

Foxfolio turns your terminal into an interactive resume/portfolio site.
Run one script and visitors get a themeable, animated menu with pages for
About, Skills, Projects, Services, Contact, and GitHub — no dependencies
required beyond a standard Bash environment.

## Why Foxfolio?

Most portfolio generators produce websites.
Foxfolio produces a terminal experience.
It's lightweight, customizable, and designed to feel at home over SSH,
inside a local terminal, or anywhere Bash runs.

## Quick Start

```bash
git clone https://github.com/yourusername/foxfolio.git
cd foxfolio
chmod +x foxfolio.sh
./foxfolio.sh
```

Edit `config.sh` to add your own name, bio, and links. Set
`FOX_ANIMATIONS_ENABLED=false` there to disable all animation effects, or
tune `FOX_ANIMATION_SPEED` (`slow` | `normal` | `fast`). Animations also
auto-disable in non-interactive contexts (pipes, CI), so scripted runs
never hang on a cosmetic pause.

## Requirements

- Bash 4.0+
- A terminal that supports ANSI escape codes (most modern terminals do)
- Optional: a [Nerd Font](https://www.nerdfonts.com/) for icon glyphs

Foxfolio has **no required external dependencies**. Optional enhancements
(coming in future releases!) gracefully fall back when unavailable.

## Icons, Borders & Unicode

Foxfolio picks the best-looking icons and borders your terminal can
actually render, without you having to think about it:

1. **Nerd Font glyphs** — used when `FOX_USE_NERD_FONT=true` in
   `config.sh` and your locale supports Unicode.
2. **Plain Unicode symbols** — the default when Unicode is supported but
   Nerd Fonts aren't enabled.
3. **Plain ASCII** — the fallback whenever the detected locale (`LANG`,
   `LC_ALL`, or `LC_CTYPE`) doesn't report UTF-8, so boxes, bullets, the
   spinner, and every icon still render cleanly on older or minimal
   terminals.

No emoji are used anywhere in the UI — they render inconsistently across
terminals and fonts, so Foxfolio sticks to Nerd Font glyphs, standard
Unicode symbols, and ASCII.

## Project Structure

```
foxfolio/
├── foxfolio.sh          # Entry point: startup, libs, menu, exit
├── config.sh            # User-editable configuration
├── lib/
│   ├── colors.sh          # ANSI color constants + helpers
│   ├── theme.sh           # Runtime theme loading + graceful fallback
│   ├── ascii.sh           # Banner loading (built-in, named, or file)
│   ├── ui.sh              # Boxes, headers, status indicators, icons, wrap
│   ├── animation.sh       # Animation helpers (typewriter, spinner, etc.)
│   ├── pages.sh           # About/Skills/Projects/Services/Contact/GitHub
│   └── menu.sh            # Menu rendering + navigation
├── themes/               # tokyo-night, catppuccin, nord, dracula
├── assets/banners/       # Bundled + custom ASCII banners (Phase 6)
├── examples/             # Example config.sh variants
├── CHECKLIST.md          # Development checklist
└── CHANGELOG.md          # Notable changes per release
```

## Themes

Set `FOX_THEME` in `config.sh` to one of: `tokyo-night` (default),
`catppuccin`, `nord`, `dracula`, or `default` (the built-in fallback
palette). If a theme name doesn't match a file in `themes/`, Foxfolio
prints a warning and falls back to the default palette instead of
failing to start.

## Content Pages

About, Skills, Projects, Services, Contact, and GitHub are all driven
by data in `config.sh` — no HTML/templating, just Bash arrays:

```bash
FOX_SKILLS=(
    "Languages|Bash, Python, JavaScript"
    "Tools|Git, Docker, Linux"
)

FOX_PROJECTS=(
    "Foxfolio|An interactive terminal portfolio written in Bash.|https://github.com/you/foxfolio"
)
```

See the comments above each array in `config.sh` (or
`examples/config.showcase.sh` for a fully filled-in reference) for the
exact `Name|Description|URL`-style format each page expects. Any page
long enough to overflow one screen paginates automatically with
`[n]ext` / `[p]revious` prompts.

## Banners

Set `FOX_BANNER_NAME` in `config.sh` to `minimal`, `fox`, or `block` to
use a bundled banner from `assets/banners/`, or drop your own `.txt`
file in that folder and point `FOX_BANNER_NAME` at it — see
`assets/banners/README.md`. `FOX_BANNER_PATH` remains available for a
banner file stored outside the project entirely, and takes priority
over `FOX_BANNER_NAME` when both are set.

## Project Philosophy

- Stable architecture, no feature creep.
- Small, reviewable milestones.
- One responsibility per file.
- Modular library design.
- Optional enhancements gracefully fall back.
- Every completed phase leaves the project in a working state.

## Roadmap Status

| Phase | Description   | Status                                    |
|-------|----------------|-------------------------------------------|
| 0     | Foundation      | Complete                                |
| 1     | Core Framework   | Complete                                |
| 2     | Terminal UI       | Complete                                |
| 3     | Animation Engine   | Complete                                |
| 4     | Theme System        | Complete                                |
| 5     | Content Pages        | Complete                                |
| 6     | ASCII Assets          | Complete                                |
| 7     | Polish                 | Code complete — screenshots pending      |
| 8     | Release                 | Docs complete — tag/GitHub release pending |

See `CHECKLIST.md` for a full breakdown.

## Shell Compatibility

Foxfolio targets **Bash 4.0+**. It is not guaranteed to work under `sh`,
`dash`, `zsh`, or Bash 3.x (e.g. the default `/bin/bash` on older macOS).

## Coding Standards

- One responsibility per file; libraries only expose functions.
- All public functions are prefixed `fox::` (e.g. `fox::header`).
- All exported config/env variables are prefixed `FOX_`.
- No global state mutation outside of `foxfolio.sh` and `config.sh`.
- Every file should pass `shellcheck` (enforced from Phase 7 onward).

## License

MIT — see [LICENSE](LICENSE).

## Contributing

This project follows small, reviewable milestones. See
`Foxfolio_Project_Roadmap.md` for the full phase-by-phase plan before
opening a PR, and `CHANGELOG.md` for what's landed so far.
