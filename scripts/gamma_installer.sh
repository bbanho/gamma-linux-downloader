#!/usr/bin/env bash
# gamma_installer.sh - Simple GAMMA installer for Linux and Windows (with WSL/Git Bash)
#
# This script assumes you have already placed the following archives in the current directory:
#   - Anomaly-1.5.3-Full.2.7z
#   - G.A.M.M.A._Launcher_v8.6.7z
#
# It will extract them, set up a MO2 profile, and optionally create a merged game directory.
#
# Usage:
#   ./gamma_installer.sh /path/to/gamma_installation
#
# The script will create the following structure:
#   <install_dir>/
#       Anomaly/                  # Extracted base game
#       GAMMA/                    # Extracted GAMMA launcher and mods
#       MO2_profiles/
#           GAMMA/
#               modlist.txt       # Default enabled mods from GAMMA launcher
#       merged/                   # Optional: merged game directory (hardlinks/copies)
#
# Requirements:
#   - 7z (for extraction)
#   - bash
#   - Optional: rclone if you want to fetch from remote (not implemented here)
#
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <installation_directory>"
    echo "Example: $0 ~/gamma_setup"
    exit 1
fi

INSTALL_DIR=$(realpath "$1")
ANOMALY_ARCHIVE="Anomaly-1.5.3-Full.2.7z"
GAMMA_ARCHIVE="G.A.M.M.A._Launcher_v8.6.7z"

echo "=== STALKER GAMMA Simple Installer ==="
echo "Installation directory: $INSTALL_DIR"

# Check for archives
if [[ ! -f "$INSTALL_DIR/$ANOMALY_ARCHIVE" ]]; then
    echo "Error: $ANOMALY_ARCHIVE not found in $INSTALL_DIR"
    echo "Please place the archive here or download it first."
    exit 1
fi

if [[ ! -f "$INSTALL_DIR/$GAMMA_ARCHIVE" ]]; then
    echo "Error: $GAMMA_ARCHIVE not found in $INSTALL_DIR"
    echo "Please place the archive here or download it first."
    exit 1
fi

# Create directories
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "[1] Extracting Anomaly base..."
7z x -y "$ANOMALY_ARCHIVE" -oAnomaly 2>&1 | tail -5

echo "[2] Extracting GAMMA launcher..."
7z x -y "$GAMMA_ARCHIVE" -oGAMMA 2>&1 | tail -5

# Set up MO2 profile
MO2_PROFILE_DIR="$INSTALL_DIR/MO2_profiles/GAMMA"
MO2_MODS_DIR="$INSTALL_DIR/GAMMA"  # We'll consider the GAMMA folder as the mods source

echo "[3] Setting up MO2 profile at $MO2_PROFILE_DIR"
mkdir -p "$MO2_PROFILE_DIR"

# Copy the default modlist from the GAMMA launcher resources
DEFAULT_MODLIST="$INSTALL_DIR/GAMMA/resources/profiles_files/modlist.txt"
if [[ -f "$DEFAULT_MODLIST" ]]; then
    cp "$DEFAULT_MODLIST" "$MO2_PROFILE_DIR/modlist.txt"
    echo "   Copied default modlist from GAMMA launcher."
else
    echo "   Warning: Default modlist not found in launcher archive. Creating empty modlist."
    touch "$MO2_PROFILE_DIR/modlist.txt"
fi

# Create a basic meta.ini for the profile (optional)
cat > "$MO2_PROFILE_DIR/meta.ini" <<EOI
[General]
name=GAMMA
version=1.0
author=STALKER GAMMA Team
EOI

echo "[4] Installation complete!"
echo ""
echo "Next steps:"
echo "  1. To launch with Mod Organizer 2:"
echo "     - Point MO2 to the profile: $MO2_PROFILE_DIR"
echo "     - Set the game directory to: $INSTALL_DIR/Anomaly"
echo "     - Launch the game via MO2."
echo ""
echo "  2. To use the merged game directory (Linux only, faster startup):"
echo "     - Run the merge script: ./gamma_merge.sh $INSTALL_DIR"
echo "     - Then launch the game directly from: $INSTALL_DIR/merged/AnomalyDX11.exe"
echo ""
echo "Enjoy the Zone, Stalker!"
