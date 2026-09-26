# STALKER G.A.M.M.A. Linux Helper & Downloader

Automated download resolver, preparation scripts, and Wine/Bottles setup instructions for running **S.T.A.L.K.E.R. G.A.M.M.A.** natively on Linux.

## Overview

Installing STALKER G.A.M.M.A. on Linux usually presents two main hurdles:
1. **ModDB Cloudflare & Mirror Restrictions:** Direct downloads or automated scripts hit `403 Forbidden` errors if headers (`User-Agent`, `Referer`) are not handled correctly.
2. **Directory & Archive Extraction:** Handling large `.7z` archives (~150GB+ uncompressed total) requires clean folder structures and reliable 7-Zip extraction tools.

This repository provides clean Bash & Python scripts designed for Linux players to resolve direct download mirrors, bypass Cloudflare headers, prepare game directories, and launch G.A.M.M.A. via Wine/Bottles/Proton.

---

## Features

- **ModDB Resolver & Downloader:** Bypasses Cloudflare 403 checks automatically using proper Firefox headers.
- **Rclone & Local Storage Support:** Stream downloads directly to any local directory or `rclone` remote storage.
- **Linux Dependency Checklist:** Verifies required dependencies (`7z`, `unrar`, `wine`/`bottles`, `curl`, `rclone`).
- **Wine Prefix & Winetricks Setup Guide:** Ready-to-use commands for setting up DirectX, Visual C++ Redistributables, and MO2 dependencies on Linux.

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/bbanho/gamma-linux-downloader.git
cd gamma-linux-downloader
chmod +x scripts/*.sh
```

### 2. Download Anomaly 1.5.3 Automatically

Pass your desired download folder as an argument (local path or rclone remote):

```bash
# Download to a local folder
./scripts/resolve_and_download.sh ~/Downloads/STALKER_Setup

# Or stream directly to an rclone remote/drive
./scripts/resolve_and_download.sh myremote:STALKER_Setup
```

---

## Wine / Bottles Prefix Configuration

To run STALKER Anomaly and G.A.M.M.A. on Linux with optimal performance and compatibility:

### Required Winetricks Dependencies

Inside your Wine prefix or Bottles container (using **Proton-GE** or **Wine-GE**):

```bash
WINEPREFIX=/path/to/your/prefix winetricks -q \
  cmd d3dx9 dx8vb d3dcompiler_42 d3dcompiler_43 \
  d3dcompiler_46 d3dcompiler_47 d3dx10_43 d3dx10 \
  d3dx11_42 d3dx11_43 vcrun2022 dxvk quartz
```

### Mod Organizer 2 & Launcher Setup

1. Extract `Anomaly-1.5.3-Full.2.7z` into an `Anomaly` directory.
2. Extract `GAMMA RC3.7z` into a separate `GAMMA` directory.
3. Run `AnomalyLauncher.exe` once inside your Wine/Proton prefix, click **Play**, reach the main menu, and exit.
4. Run `G.A.M.M.A. Launcher.exe` from `GAMMA/.Grok's Modpack Installer/`.
5. Perform **First Install Initialization**, point MO2 to the `Anomaly` folder, and click **Install / Update GAMMA**.

---

## Repository Structure

```
.
├── README.md
└── scripts/
    └── resolve_and_download.sh    # ModDB resolver and automated download script
```

---

## Requirements

- `bash`, `curl`, `grep`, `sed`
- `7z` (p7zip)
- `rclone` (optional, for streaming downloads)
- `wine` / `bottles` / `proton-ge`

---

## License

MIT License. Free for all Stalkers in the Zone!
