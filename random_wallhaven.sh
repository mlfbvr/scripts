#!/bin/bash

# Install dependencies: feh, curl, jq
FEH=$(which feh)
CURL=$(which curl)
JQ=$(which jq)
XARGS=$(which xargs)

if [ -z "$FEH" ] || [ -z "$CURL" ] || [ -z "$JQ" ] || [ -z "$XARGS" ]; then
    echo "Please install feh, curl, jq, and xargs to use this script."
    exit 1
fi
set -ueo pipefail

# Set CONFIG file path to ${HOME}/.random_wallhaven if $1 is not provided
CONFIG_FILE="${1:-${HOME}/.random_wallhaven}"
if [[ -f "${CONFIG_FILE}" ]]; then 
	source ${CONFIG_FILE}
fi

BASE_URL="https://wallhaven.cc/api/v1/search"
API_KEY="${WALLHAVEN_API_KEY:-}"
RESOLUTIONS="${WALLHAVEN_RESOLUTIONS:-3440x1440,2560x1080}"
CATEGORIES="${WALLHAVEN_CATEGORIES:-111}" # General/Anime/People
SORT="${WALLHAVEN_SORT:-random}" # random, date_added, views, favorites, toplist
PURITY="${WALLHAVEN_PURITY:-110}" # SFW/Sketchy/NSFW
QUERY="${WALLHAVEN_QUERY:-}" # Optional search query

# Build the IMG_URL
INDEX=0
IMG_URL="${BASE_URL}?"

# Add the optional query to IMG_URL if it is defined
if [ -n "$QUERY" ]; then
    IMG_URL="${IMG_URL}q=${QUERY}&"
fi

# Add the apiKey argument if it is defined
# The API KEY is optional, but must be supplied for PURITY values ending with 1 (NSFW)
if [ -n "$API_KEY" ]; then
    IMG_URL="${IMG_URL}apikey=${API_KEY}&"
elif [[ "$PURITY" == *"1" ]]; then
        echo "Error: WALLHAVEN_API_KEY must be set for NSFW purity settings."
        exit 1
fi

# Append other parameters
IMG_URL="${IMG_URL}resolutions=${RESOLUTIONS}&categories=${CATEGORIES}&sorting=${SORT}&purity=${PURITY}"

#${CURL} -s ${IMG_URL} | ${JQ} .data[${INDEX}].path | xargs feh #--bg-fill 
IMG_PATH=$(${CURL} -s ${IMG_URL} | ${JQ} .data[${INDEX}].path)
echo "Selected wallpaper URL: ${IMG_PATH}"

echo ${IMG_PATH} | ${XARGS} ${FEH} --bg-fill
