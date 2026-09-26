# STALKER G.A.M.M.A. Linux & Cross-Platform Downloader, Installer & MO2 Engine

A modular, lightweight, and transparent toolkit for downloading, managing, and running **S.T.A.L.K.E.R. G.A.M.M.A.** and **STALKER Anomaly 1.5.3** on Linux and Windows (via WSL/Git Bash).

---

## 🌟 Features & Highlights

- **ModDB Cloudflare & Mirror Bypass:** Automatically resolves direct download links for Anomaly 1.5.3 using proper Firefox headers (`User-Agent` + `Referer`).
- **Cloud & Local Storage Streaming:** Stream downloads directly into local folders or `rclone` remotes (Google Drive, S3, WebDAV) with zero-disk buffer options.
- **Native MO2 Compatibility:** Fully compatible with Mod Organizer 2's native text formats (`modlist.txt`, `meta.ini`, `categories.dat`).
- **Declarative Snapshots:** Export and restore MO2 profiles as human-readable JSON/YAML snapshots with optional SHA256 integrity hashsums for safe tinkering and rollbacks.
- **Hardlink Merged Game Directory:** Create a unified game folder (`Anomaly-GAMMA-Merged`) using Linux hardlinks (`cp -ral`) or copies — zero extra disk usage, faster game startup, and no USVFS/virtual filesystem hooks needed.

---

## 🛠️ Repository Scripts Reference

All operational scripts live inside the `scripts/` directory:

### 1. `scripts/resolve_and_download.sh`
*ModDB direct download resolver & Cloudflare bypass streamer.*
- Resolves ModDB direct mirrors dynamically.
- Streams downloads to local path or `rclone` remotes (`rclone copyurl`).
- **Usage:**
  ```bash
  ./scripts/resolve_and_download.sh /path/to/destination_folder
  ./scripts/resolve_and_download.sh remote:STALKER_GAMMA/Archives/
  ```

### 2. `scripts/mo2_snapshot.py`
*Mod Organizer 2 Profile Engine & Declarative Snapshot Manager.*
- Under **150 lines of clean Python 3**, requiring zero external dependencies.
- Exports MO2 `modlist.txt` into JSON/YAML snapshots with file-level SHA256 hashes.
- Restores profiles back to `modlist.txt` in 100% native MO2 format.
- **Usage:**
  ```bash
  # Export snapshot (with file integrity hashes)
  python3 scripts/mo2_snapshot.py export /path/to/MO2/profiles/GAMMA /path/to/MO2/mods snapshot.json --hashes

  # Restore profile from snapshot
  python3 scripts/mo2_snapshot.py restore /path/to/MO2/profiles/GAMMA /path/to/MO2/mods snapshot.json
  ```

### 3. `scripts/gamma_installer.sh`
*Universal extractor and setup script for Anomaly + GAMMA.*
- Extracts `Anomaly-1.5.3-Full.2.7z` and `G.A.M.M.A._Launcher_v8.6.7z`.
- Initializes default MO2 profiles and sets up directory structures.
- **Usage:**
  ```bash
  ./scripts/gamma_installer.sh ~/gamma_setup
  ```

### 4. `scripts/gamma_merge.sh`
*Hardlink-based directory merge engine for Linux players.*
- Merges base Anomaly with enabled mods according to MO2 `modlist.txt` priority.
- Uses Linux hardlinks (`cp -ral`) to create a single uncompressed game folder in seconds without consuming extra disk space.
- Allows running `AnomalyDX11.exe` directly via Wine/Proton without Mod Organizer 2 overhead.
- **Usage:**
  ```bash
  ./scripts/gamma_merge.sh ~/gamma_setup
  ```

---

## 🎮 Wine / Bottles / Proton-GE Setup (Linux)

To run STALKER Anomaly and G.A.M.M.A. on Linux with optimal performance and compatibility:

### Required Winetricks Dependencies

Inside your Wine prefix or Bottles container (using **Proton-GE** or **Wine-GE**):

```bash
WINEPREFIX=/path/to/your/prefix winetricks -q \
  cmd d3dx9 dx8vb d3dcompiler_42 d3dcompiler_43 \
  d3dcompiler_46 d3dcompiler_47 d3dx10_43 d3dx10 \
  d3dx11_42 d3dx11_43 vcrun2022 dxvk quartz
```

---

## 📁 Repository Structure

```
.
├── README.md                          # Full documentation
└── scripts/
    ├── resolve_and_download.sh        # ModDB Cloudflare bypass downloader
    ├── mo2_snapshot.py                # MO2 profile engine & JSON snapshot manager
    ├── gamma_installer.sh             # Universal archive extractor & profile setup
    └── gamma_merge.sh                 # Linux hardlink-based directory merge engine
```

---

## 📄 License

MIT License. Free for all Stalkers in the Zone!
