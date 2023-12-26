#!/bin/bash

WAL_FILE="$HOME/.cache/wal/colors.sh"
KONSOLE_FILE="$HOME/.local/share/konsole/pywal.colorscheme"
KONSOLE_COLOR_SCHEME="$HOME/.cache/wal/colors-konsole.colorscheme"
PLASMA_FILE="pywal"
PLASMA_COLORS_DIR="$HOME/.local/share/color-schemes/"
PLASMA_SHELL_EXECUTABLE="plasmashell"

pywal_get() {
    echo "[func: pywal_get] >> wal -i ${1}"
    wal -i "$1" -e
    return 1
}

copy_konsole_colorscheme() {
    sed -i -e "s/Opacity=.*/Opacity=0.95/g" $KONSOLE_COLOR_SCHEME
    cp -f $KONSOLE_COLOR_SCHEME $KONSOLE_FILE
}

merge_xresources_color() {
    xrdb -merge $HOME/.cache/wal/colors.Xresources
}

get_xres_rgb() {
    hex=$(xrdb -query | grep "$1" | awk '{print $2}' | cut -d# -f2)
    printf "%d,%d,%d\n" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

plasma_color_scheme() {

    [[ -d "$PLASMA_COLORS_DIR" ]] || mkdir -pv "$PLASMA_COLORS_DIR"

    output="$(
        cat <<THEME
[ColorEffects:Disabled]
Color=$(get_xres_rgb color9:)

[ColorEffects:Inactive]
Color=$(get_xres_rgb color9:)

[Colors:Button]
BackgroundNormal=$(get_xres_rgb color8:)
ForegroundNormal=$(get_xres_rgb background:)

[Colors:Complementary]

[Colors:Selection]
BackgroundAlternate=
BackgroundNormal=$(get_xres_rgb color2:)
DecorationFocus=
DecorationHover=
ForegroundActive=
ForegroundInactive=
ForegroundLink=
ForegroundNegative=
ForegroundNeutral=
ForegroundNormal=$(get_xres_rgb foreground:)
ForegroundPositive=
ForegroundVisited=

[Colors:Tooltip]
BackgroundAlternate=
BackgroundNormal=$(get_xres_rgb color2:)
DecorationFocus=
DecorationHover=
ForegroundActive=
ForegroundInactive=
ForegroundLink=
ForegroundNegative=
ForegroundNeutral=
ForegroundNormal=$(get_xres_rgb foreground:)
ForegroundPositive=
ForegroundVisited=

[Colors:View]
# BackgroundAlternate=
BackgroundNormal=$(get_xres_rgb color0:)
# DecorationFocus=
# DecorationHover=
# ForegroundActive=
# ForegroundInactive=
# ForegroundLink=
# ForegroundNegative=
# ForegroundNeutral=
ForegroundNormal=$(get_xres_rgb foreground:)
# ForegroundPositive=
# ForegroundVisited=

[Colors:Window]
# BackgroundAlternate=
BackgroundNormal=$(get_xres_rgb color0:)
# DecorationFocus=
# DecorationHover=
# ForegroundActive=
# ForegroundInactive=
# ForegroundLink=
# ForegroundNegative=
# ForegroundNeutral=
ForegroundNormal=$(get_xres_rgb foreground:)
# ForegroundPositive=
# ForegroundVisited=

[General]
ColorScheme=${PLASMA_FILE}
Name=${PLASMA_FILE}
shadeSortColumn=true

[KDE]
contrast=0

[WM]
activeBackground=$(get_xres_rgb background:)
activeForeground=$(get_xres_rgb foreground:)
inactiveBackground=$(get_xres_rgb background:)
inactiveForeground=$(get_xres_rgb color15:)
THEME
    )"
    printf '%s' "$output" >"${PLASMA_COLORS_DIR}${PLASMA_FILE}.colors"
    plasma-apply-colorscheme BreezeDark
    sleep 0.2s
    plasma-apply-colorscheme pywal
}

if [[ -x "$(which wal)" ]]; then
    if [[ "$1" ]]; then
        pywal_get "$1"
        if [[ -e "$WAL_FILE" ]]; then
            . "$WAL_FILE"
        else
            echo 'Color file does not exist, exiting...'
            echo '1) Is ImageMagick installed?'
            echo '2) Try to run wal --> f.e. wal -i ~/Pictures/<yourimage>.jpg'
            echo 'should result in ~/.cache/wal dir being filled with files (also the color.sh file)'
            exit 1
        fi
        BG=$(printf "%s\n" "$background")
        FG=$(printf "%s\n" "$foreground")
        AC1=$(printf "%s\n" "$color1")
        AC2=$(printf "%s\n" "$color2")
        AC3=$(printf "%s\n" "$color3")
        AC4=$(printf "%s\n" "$color4")
        AC5=$(printf "%s\n" "$color5")
        AC6=$(printf "%s\n" "$color6")
        AC7=$(printf "%s\n" "$color7")
        AC8=$(printf "%s\n" "$color8")
        AC9=$(printf "%s\n" "$color9")
        AC10=$(printf "%s\n" "$color10")
        AC11=$(printf "%s\n" "$color11")
        AC12=$(printf "%s\n" "$color12")
        AC13=$(printf "%s\n" "$color13")
        AC14=$(printf "%s\n" "$color14")
        AC15=$(printf "%s\n" "$color15")
        AC66=$(printf "%s\n" "$color66")
        merge_xresources_color
        if [ -x "$(which ${PLASMA_SHELL_EXECUTABLE})" ]; then
            plasma_color_scheme
            copy_konsole_colorscheme
        else
            echo "ERROR plasmashell is NOT installed! Cannot set plasma's (kde) color scheme"
        fi
        sleep 0.1s
        if [[ -x "$(which pywalfox)" ]]; then
            pywalfox update
        else
            echo "[!] 'pywalfox' is not installed. https://github.com/Frewacom/pywalfox"
        fi
    else
        echo -e "[!] Please enter the path to wallpaper. \n"
        echo "Usage : ./pywal.sh path/to/image"
    fi
else
    echo "[!] 'pywal' is not installed. https://github.com/the404devs/pywal-kde"
fi
