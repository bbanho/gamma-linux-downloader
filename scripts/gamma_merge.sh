#!/usr/bin/env bash
# gamma_merge.sh - Create a merged game directory using hardlinks (if possible) or copies
#
# Usage: ./gamma_merge.sh <install_dir>
#
# This script creates a directory 'merged/Anomaly' that contains the base game
# with all enabled mods from the MO2 profile applied on top.
# It uses hardlinks when possible (same filesystem) to save space, falling back to copies.
#
# Requires: bash, coreutils (cp, ln, find)

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <installation_directory>"
    exit 1
fi

INSTALL_DIR=$(realpath "$1")
BASE_DIR="$INSTALL_DIR/Anomaly"
MO2_PROFILE="$INSTALL_DIR/MO2_profiles/GAMMA"
MODS_SOURCE="$INSTALL_DIR/GAMMA"  # Where the mods are extracted
MERGED_DIR="$INSTALL_DIR/merged/Anomaly"

echo "=== Creating merged game directory ==="
echo "Base game: $BASE_DIR"
echo "Mods source: $MODS_SOURCE"
echo "MO2 profile: $MO2_PROFILE"
echo "Output: $MERGED_DIR"

# Read the modlist to know which mods are enabled
MAP_FILE="/tmp/gamma_mod_priority.$$"
> "$MAP_FILE"
while IFS= read -r line; do
    line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [[ -z "$line" ]]; then continue; fi
    if [[ "$line" == \+* ]]; then
        MOD_NAME="${line#+}"
        echo "+ $MOD_NAME" >> "$MAP_FILE"
    elif [[ "$line" == \-* ]]; then
        MOD_NAME="${line#-}"
        echo "- $MOD_NAME" >> "$MAP_FILE"
    fi
done < "$MO2_PROFILE/modlist.txt"

# Create the merged directory structure
rm -rf "$MERGED_DIR"
mkdir -p "$MERGED_DIR"

# Step 1: Hardlink or copy the base game
echo "[1] Linking base game..."
cp -ral "$BASE_DIR"/ "$MERGED_DIR"/ 2>/dev/null || {
    echo "   Hardlink failed (different filesystem?), falling back to copy."
    cp -r "$BASE_DIR"/ "$MERGED_DIR"/
}

# Step 2: Apply each enabled mod in order
echo "[2] Applying enabled mods..."
while IFS= read -r line; do
    if [[ ! "$line" =~ ^\+ ]]; then continue; fi
    MOD_NAME="${line#+}"
    MOD_PATH="$MODS_SOURCE/$MOD_NAME"
    if [[ ! -d "$MOD_PATH" ]]; then
        echo "   Warning: Mod '$MOD_NAME' not found in $MODS_SOURCE, skipping."
        continue
    fi
    echo "   Applying: $MOD_NAME"
    # Copy the mod files over the merged directory (overwriting)
    cp -rT "$MOD_PATH" "$MERGED_DIR" 2>/dev/null || {
        # If cp -rT fails (older coreutils), use rsync or find+cp
        rsync -a --delete "$MOD_PATH"/ "$MERGED_DIR"/
    }
done < "$MAP_FILE"

# Clean up
rm -f "$MAP_FILE"

echo "[3] Merge complete!"
echo "You can now launch the game directly from:"
echo "  $MERGED_DIR/AnomalyDX11.exe"
echo ""
echo "Note: If you update the modlist, re-run this script to update the merged directory."
