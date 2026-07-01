# Banners

Drop a plain-text `.txt` file in this folder to add a new banner — no
code changes required.

## Using a bundled banner

Set `FOX_BANNER_NAME` in `config.sh` to the filename without its
extension:

```bash
FOX_BANNER_NAME="fox"      # loads assets/banners/fox.txt
```

Bundled options:

- `minimal` — a compact one-line banner for narrow terminals
- `fox` — a small fox-face ASCII drawing
- `block` — bold block-letter wordmark

Leave `FOX_BANNER_NAME` empty (or set it to `"default"`) to use the
built-in banner defined in `lib/ascii.sh`.

## Adding your own

1. Create `assets/banners/yourname.txt` with any ASCII/Unicode art.
2. Set `FOX_BANNER_NAME="yourname"` in `config.sh`.

That's it — `fox::load_banner` (in `lib/ascii.sh`) picks it up
automatically. Keep it under ~78 columns wide so it doesn't wrap on
smaller terminals.

## Full file override

For a banner stored outside this folder entirely, set
`FOX_BANNER_PATH` in `config.sh` to an absolute path. `FOX_BANNER_PATH`
takes priority over `FOX_BANNER_NAME` when both are set.
