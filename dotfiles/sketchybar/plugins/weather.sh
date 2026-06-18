#!/usr/bin/env bash
# Fetches local weather from wttr.in using geocoordinates extracted from the native macOS Weather app cache database (falling back to ~/.weather_location).

LOCATION=""

DB_PATH="$HOME/Library/Containers/com.apple.weather/Data/Library/Caches/com.apple.weather/Cache.db"
if [ -f "$DB_PATH" ]; then
  URL=$(sqlite3 "$DB_PATH" "SELECT request_key FROM cfurl_cache_response WHERE request_key LIKE '%weatherkit.apple.com/api/v2/weather%' AND request_key LIKE '%locationInfo%' ORDER BY entry_ID DESC LIMIT 1;" 2>/dev/null)
  if [[ "$URL" =~ weather/[a-zA-Z-]+/([0-9.-]+)/([0-9.-]+) ]]; then
    LOCATION="${BASH_REMATCH[1]},${BASH_REMATCH[2]}"
  fi
fi

if [ -z "$LOCATION" ] && [ -f "$HOME/.weather_location" ]; then
  LOCATION=$(cat "$HOME/.weather_location" | xargs)
fi

WEATHER_DATA=$(curl -s --connect-timeout 3 --max-time 5 "wttr.in/${LOCATION}?format=%c+%t" 2>/dev/null)

if [ -n "$WEATHER_DATA" ] && [[ ! "$WEATHER_DATA" =~ "html" ]] && [[ ! "$WEATHER_DATA" =~ "Error" ]] && [[ ! "$WEATHER_DATA" =~ "Gateway" ]]; then
  WEATHER_DATA=$(echo "$WEATHER_DATA" | xargs)
  WEATHER_DATA=${WEATHER_DATA//+/}
  sketchybar --set "$NAME" label="$WEATHER_DATA"
else
  sketchybar --set "$NAME" label=" N/A"
fi
