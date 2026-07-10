#!/usr/bin/env bash
# Fetches local weather from wttr.in using geocoordinates extracted from the native macOS Weather app cache database (falling back to ~/.weather_location).

LOCATION=""

DB_PATH="$HOME/Library/Containers/com.apple.weather/Data/Library/Caches/com.apple.weather/Cache.db"
if [ -f "$DB_PATH" ]; then
  TZ_VAL=""
  if [ -L "/etc/localtime" ]; then
    TZ_VAL=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
  fi
  
  if [ -n "$TZ_VAL" ]; then
    URL=$(sqlite3 "$DB_PATH" "SELECT request_key FROM cfurl_cache_response WHERE request_key LIKE '%weatherkit.apple.com/api/v2/weather%' AND request_key LIKE '%timezone=${TZ_VAL}%' ORDER BY entry_ID DESC LIMIT 1;" 2>/dev/null)
  fi
  
  if [ -z "$URL" ]; then
    URL=$(sqlite3 "$DB_PATH" "SELECT request_key FROM cfurl_cache_response WHERE request_key LIKE '%weatherkit.apple.com/api/v2/weather%' ORDER BY entry_ID DESC LIMIT 1;" 2>/dev/null)
  fi

  if [[ "$URL" =~ weather/[a-zA-Z-]+/([0-9.-]+)/([0-9.-]+) ]]; then
    LOCATION="${BASH_REMATCH[1]},${BASH_REMATCH[2]}"
    echo "$LOCATION" > "$HOME/.weather_location"
  fi
fi

if [ -z "$LOCATION" ] && [ -f "$HOME/.weather_location" ]; then
  LOCATION=$(cat "$HOME/.weather_location" | xargs)
fi

if [ -z "$LOCATION" ]; then
  sketchybar --set "$NAME" label=" N/A"
  exit 0
fi

LAT=${LOCATION%,*}
LON=${LOCATION#*,}

RESPONSE=""
TEMP_C=""
STATION=""

GRID_RESPONSE=$(curl -s -H "User-Agent: (myweatherapp, brandonwalex@pm.me)" "https://api.weather.gov/points/${LAT},${LON}" 2>/dev/null)
STATIONS_URL=$(echo "$GRID_RESPONSE" | jq -r '.properties.observationStations' 2>/dev/null)

if [ -n "$STATIONS_URL" ] && [ "$STATIONS_URL" != "null" ]; then
  STATION_RESPONSE=$(curl -s -H "User-Agent: (myweatherapp, brandonwalex@pm.me)" "$STATIONS_URL" 2>/dev/null)
  STATIONS=$(echo "$STATION_RESPONSE" | jq -r '.features[].properties.stationIdentifier' 2>/dev/null)
  
  count=0
  for st in $STATIONS; do
    [ "$count" -ge 5 ] && break
    count=$((count + 1))
    
    OBS_RESP=$(curl -s -H "User-Agent: (myweatherapp, brandonwalex@pm.me)" "https://api.weather.gov/stations/${st}/observations/latest" 2>/dev/null)
    if [ -n "$OBS_RESP" ] && [[ ! "$OBS_RESP" =~ "error" ]]; then
      T_VAL=$(echo "$OBS_RESP" | jq -r '.properties.temperature.value' 2>/dev/null)
      if [ -n "$T_VAL" ] && [ "$T_VAL" != "null" ]; then
        STATION="$st"
        RESPONSE="$OBS_RESP"
        TEMP_C="$T_VAL"
        break
      fi
    fi
  done
fi

if [ -z "$STATION" ] || [ -z "$TEMP_C" ] || [ "$TEMP_C" = "null" ]; then
  STATION="KDFW"
  RESPONSE=$(curl -s -H "User-Agent: (myweatherapp, brandonwalex@pm.me)" "https://api.weather.gov/stations/${STATION}/observations/latest" 2>/dev/null)
fi

if [ -n "$RESPONSE" ] && [[ ! "$RESPONSE" =~ "error" ]]; then
  TEMP_C=$(echo "$RESPONSE" | jq -r '.properties.temperature.value')
  if [ "$TEMP_C" != "null" ] && [ -n "$TEMP_C" ]; then
    TEMP=$(awk -v tc="$TEMP_C" 'BEGIN { printf "%.0f", (tc * 9 / 5) + 32 }')
  else
    TEMP="N/A"
  fi
  
  ICON_URL=$(echo "$RESPONSE" | jq -r '.properties.icon')
  ICON_BASE="${ICON_URL%%\?*}"
  ICON_CODE="${ICON_BASE##*/}"
  ICON_CODE="${ICON_CODE%%,*}"
  
  case "$ICON_CODE" in
    skc|few)
      if [[ "$ICON_URL" =~ "/night/" ]]; then
        ICON="🌙"
      else
        ICON="☀️"
      fi
      ;;
    sct|bkn) ICON="🌤️" ;;
    ovc) ICON="☁️" ;;
    wind*) ICON="💨" ;;
    fog|smoke|haze|dust) ICON="🌫️" ;;
    rain*|showers*) ICON="🌧️" ;;
    sleet*|snow*|fzra*) ICON="❄️" ;;
    tsra*) ICON="⛈️" ;;
    tornado*) ICON="🌪️" ;;
    *) ICON="" ;;
  esac
  
  if [ "$TEMP" != "N/A" ]; then
    sketchybar --set "$NAME" label="$ICON ${TEMP}°F"
  else
    sketchybar --set "$NAME" label=" N/A"
  fi
else
  sketchybar --set "$NAME" label=" N/A"
fi
