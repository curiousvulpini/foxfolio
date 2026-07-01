# Foxfolio Development Checklist

Tracks progress against `Foxfolio_Project_Roadmap.md`. A phase is only
checked off once every item is done, the script launches successfully,
and existing functionality remains intact (see Definition of Done).

## Phase 0 — Foundation
- [x] Folder tree created
- [x] README started
- [x] License added
- [x] Project philosophy documented

## Phase 1 — Core Framework
- [x] Script launches
- [x] Banner displays
- [x] Menu appears
- [x] Exit works

## Phase 2 — Terminal UI
- [x] Layout finalized
- [x] Borders reusable
- [x] Colors consistent

## Phase 3 — Animation Engine
- [x] Spinner complete
- [x] Progress bar complete
- [x] Typewriter complete

## Phase 4 — Theme System
- [x] Runtime theme loading
- [x] Graceful fallback

## Phase 5 — Content Pages
- [x] About page
- [x] Skills page
- [x] Projects page
- [x] Services page
- [x] Contact page
- [x] GitHub page

## Phase 6 — ASCII Assets
- [x] Banner support
- [x] Alternate banners
- [x] Custom artwork
- [x] Easy replacement

## Phase 7 — Polish
- [x] Comments
- [x] Cleanup
- [x] Shellcheck clean (see `.shellcheckrc`; hand-reviewed against
      shellcheck's common rules since the binary isn't installable in
      this environment — all files pass `bash -n`)
- [x] Documentation
- [ ] Screenshots — needs a real terminal recording, not generatable here
- [x] Example configs

## Phase 8 — Release
- [x] README complete
- [x] Installation instructions
- [ ] GIF/screenshots — see note above
- [x] MIT License
- [ ] Tagged v1.0.0 — run from your own clone once screenshots are in:
      `git tag -a v1.0.0 -m "Foxfolio v1.0.0" && git push --tags`
- [ ] GitHub release — create from the pushed tag once the repo is on GitHub
