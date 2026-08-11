#!/usr/bin/env bash
# Print the cached wttr.in line for the status bar.
# Never blocks: prints whatever is cached and refreshes in the background
# at most once per $TTL seconds.

LOCATION="${1:-Amsterdam}"
TTL="${TTL:-120}"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux"
CACHE="$CACHE_DIR/weather-$LOCATION"
LOCK="$CACHE.lock"

mkdir -p "$CACHE_DIR"

fetch() {
    # mkdir is atomic: only one refresher runs even if several panes redraw at once.
    mkdir "$LOCK" 2>/dev/null || return
    trap 'rmdir "$LOCK" 2>/dev/null' EXIT

    local out
    if out=$(curl -sf --max-time 10 "wttr.in/${LOCATION}?format=3") && [ -n "$out" ]; then
        printf '%s\n' "$out" >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
    else
        # Failed fetch: touch the cache so we back off for another TTL
        # instead of hammering wttr.in on every redraw.
        [ -f "$CACHE" ] && touch "$CACHE"
    fi
}

age=$(( $(date +%s) - $(stat -c %Y "$CACHE" 2>/dev/null || echo 0) ))

if [ "$age" -ge "$TTL" ]; then
    fetch &
    disown 2>/dev/null
fi

# Print the cache if we have one; on the very first run it may not exist yet.
cat "$CACHE" 2>/dev/null || printf '%s: ...\n' "$LOCATION"
