# Changelog

All notable changes to Foxfolio are documented here. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## [1.0.0] - Unreleased

### Added
- **Phase 5 — Content Pages:** real About, Skills, Projects, Services,
  Contact, and GitHub pages (`lib/pages.sh`), populated from `config.sh`
  and rendered through a shared, paginated `fox::page_scrollable`
  layout that always returns cleanly to the main menu.
- **Phase 6 — ASCII Assets:** named banner support (`FOX_BANNER_NAME`)
  with three bundled banners (`minimal`, `fox`, `block`) in
  `assets/banners/`, plus the existing `FOX_BANNER_PATH` override for
  fully custom artwork. See `assets/banners/README.md`.
- `fox::text_wrap` and `fox::press_enter_to_continue` helpers in
  `lib/ui.sh`, shared by every content page.
- Example configs in `examples/` (`config.minimal.sh`,
  `config.showcase.sh`) demonstrating a bare-bones and a fully
  populated setup.
- `.shellcheckrc` for consistent linting.

### Changed
- `lib/menu.sh` now dispatches to real page functions
  (`fox::menu_dispatch`) instead of the Phase 1–4 placeholder page.
- `config.sh` gained a Content Pages section (`FOX_SKILLS`,
  `FOX_PROJECTS`, `FOX_SERVICES`, `FOX_GITHUB_REPOS`) and a Banner
  section (`FOX_BANNER_NAME`).
- `foxfolio.sh` defaults the new content arrays to empty when a user's
  `config.sh` omits them, so `set -u` never trips on an older config.

### Fixed
- The exit message no longer reads "my's portfolio" when
  `FOX_AUTHOR_NAME` is unset.

## [0.4.0] - Phases 0–4

Foundation, core framework, terminal UI primitives, animation engine,
and the runtime theme system (Tokyo Night, Catppuccin, Nord, Dracula).
