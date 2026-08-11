#!/usr/bin/env bash
# Print a Nerd Font battery glyph + charge percentage for the status bar.
# Reads sysfs directly, so it's cheap enough to run on every redraw.

BAT="${1:-BAT0}"
# PSDIR is overridable so the glyph buckets can be tested against a fake tree.
SYS="${PSDIR:-/sys/class/power_supply}/$BAT"

# All of these live in the Font Awesome range (U+F0E7, U+F1E6, U+F240-F244),
# which sits at the same codepoints in Nerd Fonts v2 and v3. They're literal
# UTF-8 bytes, so keep this file UTF-8 if you edit it.
GLYPH_FULL=''
GLYPH_THREE_QUARTERS=''
GLYPH_HALF=''
GLYPH_QUARTER=''
GLYPH_EMPTY=''
GLYPH_BOLT=''
GLYPH_PLUG=''

# No battery (desktop, or a differently named pack): show a plug and stop.
if [ ! -r "$SYS/capacity" ]; then
    printf '%s\n' "$GLYPH_PLUG"
    exit 0
fi

capacity=$(<"$SYS/capacity")
status=$(<"$SYS/status")

if   [ "$capacity" -ge 90 ]; then glyph=$GLYPH_FULL
elif [ "$capacity" -ge 65 ]; then glyph=$GLYPH_THREE_QUARTERS
elif [ "$capacity" -ge 35 ]; then glyph=$GLYPH_HALF
elif [ "$capacity" -ge 10 ]; then glyph=$GLYPH_QUARTER
else                              glyph=$GLYPH_EMPTY
fi

# "Not charging" means plugged in but holding at a charge limit, so it gets
# no bolt -- only an actively charging pack does.
case "$status" in
    Charging) glyph="$GLYPH_BOLT$glyph" ;;
esac

printf '%s %s%%\n' "$glyph" "$capacity"
