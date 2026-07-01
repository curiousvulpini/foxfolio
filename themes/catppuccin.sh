#!/usr/bin/env bash
# catppuccin.sh - Catppuccin (Mocha) theme for Foxfolio
#
# Just overrides the FOX_COLOR_* aliases from colors.sh. Palette: https://github.com/catppuccin/catppuccin

FOX_COLOR_PRIMARY="$(fox::rgb 137 180 250)"   # blue      #89b4fa
FOX_COLOR_BORDER="$(fox::rgb 116 199 236)"    # sapphire  #74c7ec
FOX_COLOR_ACCENT="$(fox::rgb 203 166 247)"    # mauve     #cba6f7
FOX_COLOR_SUCCESS="$(fox::rgb 166 227 161)"   # green     #a6e3a1
FOX_COLOR_WARNING="$(fox::rgb 249 226 175)"   # yellow    #f9e2af
FOX_COLOR_ERROR="$(fox::rgb 243 139 168)"     # red       #f38ba8
FOX_COLOR_MUTED="$(fox::rgb 108 112 134)"     # overlay0  #6c7086
FOX_COLOR_TEXT="$(fox::rgb 205 214 244)"      # text      #cdd6f4
