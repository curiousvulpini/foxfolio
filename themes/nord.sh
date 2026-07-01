#!/usr/bin/env bash
# nord.sh - Nord theme for Foxfolio
#
# Just overrides the FOX_COLOR_* aliases from colors.sh. Palette: https://www.nordtheme.com/docs/colors-and-palettes

FOX_COLOR_PRIMARY="$(fox::rgb 136 192 208)"   # nord8  frost cyan     #88c0d0
FOX_COLOR_BORDER="$(fox::rgb 129 161 193)"    # nord9  frost blue     #81a1c1
FOX_COLOR_ACCENT="$(fox::rgb 180 142 173)"    # nord15 aurora purple  #b48ead
FOX_COLOR_SUCCESS="$(fox::rgb 163 190 140)"   # nord14 aurora green   #a3be8c
FOX_COLOR_WARNING="$(fox::rgb 235 203 139)"   # nord13 aurora yellow  #ebcb8b
FOX_COLOR_ERROR="$(fox::rgb 191 97 106)"      # nord11 aurora red     #bf616a
FOX_COLOR_MUTED="$(fox::rgb 76 86 106)"       # nord3  polar night    #4c566a
FOX_COLOR_TEXT="$(fox::rgb 216 222 233)"      # nord4  snow storm     #d8dee9
