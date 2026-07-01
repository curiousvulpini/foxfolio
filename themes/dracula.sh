#!/usr/bin/env bash
# dracula.sh - Dracula theme for Foxfolio
#
# Just overrides the FOX_COLOR_* aliases from colors.sh. Palette: https://draculatheme.com/contribute

FOX_COLOR_PRIMARY="$(fox::rgb 189 147 249)"   # purple  #bd93f9
FOX_COLOR_BORDER="$(fox::rgb 139 233 253)"    # cyan    #8be9fd
FOX_COLOR_ACCENT="$(fox::rgb 255 121 198)"    # pink    #ff79c6
FOX_COLOR_SUCCESS="$(fox::rgb 80 250 123)"    # green   #50fa7b
FOX_COLOR_WARNING="$(fox::rgb 241 250 140)"   # yellow  #f1fa8c
FOX_COLOR_ERROR="$(fox::rgb 255 85 85)"       # red     #ff5555
FOX_COLOR_MUTED="$(fox::rgb 98 114 164)"      # comment #6272a4
FOX_COLOR_TEXT="$(fox::rgb 248 248 242)"      # fg      #f8f8f2
