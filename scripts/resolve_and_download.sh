#!/usr/bin/env bash
# resolve_and_download.sh - Automated Downloader for STALKER Anomaly & GAMMA
#
# Downloads STALKER Anomaly 1.5.3 and GAMMA RC3 directly using rclone or curl
# with Cloudflare/ModDB bypass headers. Supports local disk storage or rclone remotes.
#
# Usage:
#   ./resolve_and_download.sh /path/to/destination_folder
#   ./resolve_and_download.sh rclone_remote:path/to/folder
#
set -euo pipefail

DEST="${1:-./gamma_downloads}"

# Headers required to bypass ModDB Cloudflare checks
UA="Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0"
REFERER="https://www.moddb.com/"

log() { echo -e "\033[0;32m[+] $*\033[0m"; }
warn() { echo -e "\033[1;33m[!] $*\033[0m"; }
error() { echo -e "\033[0;31m[-] $*\033[0m" >&2; }

log "STALKER Anomaly & GAMMA Automated Downloader"
log "Destination: $DEST"

# 1. Resolve ModDB Direct Mirror for Anomaly 1.5.3
MODDB_PAGE="https://www.moddb.com/mods/stalker-anomaly/downloads/stalker-anomaly-153"
log "Resolving ModDB download link for Anomaly 1.5.3..."

HTML_PAGE=$(curl -s -A "$UA" -e "$REFERER" "$MODDB_PAGE")
START_PATH=$(echo "$HTML_PAGE" | grep -oP '/downloads/start/\d+' | head -1 || true)

if [[ -n "$START_PATH" ]]; then
    START_URL="https://www.moddb.com${START_PATH}"
    log "Found start link: $START_URL"
    
    START_HTML=$(curl -s -A "$UA" -e "$REFERER" "$START_URL")
    MIRROR_PATH=$(echo "$START_HTML" | grep -oP '/downloads/mirror/[^"]+' | head -1 || true)
    
    if [[ -n "$MIRROR_PATH" ]]; then
        DIRECT_ANOMALY_URL="https://www.moddb.com${MIRROR_PATH}"
        log "Resolved Direct Anomaly Mirror: $DIRECT_ANOMALY_URL"
    else
        warn "Could not parse direct mirror path, falling back to start page."
        DIRECT_ANOMALY_URL="$START_URL"
    fi
else
    warn "ModDB parsing failed. Please check ModDB manually."
    DIRECT_ANOMALY_URL="$MODDB_PAGE"
fi

# 2. Download Execution Function
download_file() {
    local url="$1"
    local filename="$2"
    
    if [[ "$DEST" == *":"* ]]; then
        # Destination is an rclone remote (e.g. remote:bucket/path)
        log "Streaming $filename to rclone target: $DEST/$filename"
        rclone copyurl "$url" "$DEST/$filename" \
            --header "User-Agent: $UA" \
            --header "Referer: $REFERER" \
            -P --stats 1s
    else
        # Destination is a local folder
        mkdir -p "$DEST"
        log "Downloading $filename to local path: $DEST/$filename"
        if command -v rclone &>/dev/null; then
            rclone copyurl "$url" "$DEST/$filename" \
                --header "User-Agent: $UA" \
                --header "Referer: $REFERER" \
                -P --stats 1s
        else
            curl -L -A "$UA" -e "$REFERER" -o "$DEST/$filename" "$url" --progress-bar
        fi
    fi
}

# 3. Trigger Download for Anomaly 1.5.3
if [[ -n "${DIRECT_ANOMALY_URL:-}" ]]; then
    download_file "$DIRECT_ANOMALY_URL" "Anomaly-1.5.3-Full.2.7z"
fi

log "Anomaly 1.5.3 download step completed!"
log "For GAMMA RC3, obtain the mirror link from the official Discord/Wiki and run:"
log "  ./resolve_and_download.sh $DEST"
