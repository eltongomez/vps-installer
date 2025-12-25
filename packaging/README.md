# Packaging Guide

This directory contains scripts and configurations for packaging the VPS Installer for various package managers.

## Debian/Ubuntu (.deb)

The `build-deb.sh` script creates a standard Debian package.

### Prerequisites

- `dpkg-deb` (part of `dpkg`)
- `bash`

### Build Instructions

Run the build script from the project root:

```bash
./packaging/build-deb.sh
```

**Output:** `packaging/build/vps-installer_<VERSION>_all.deb`

### Installation Test

```bash
sudo dpkg -i packaging/build/vps-installer_*.deb
sudo apt-get install -f  # Fix dependencies if needed
```

## Homebrew (macOS/Linux)

The Formula is located in `Formula/vps-installer.rb`.

### Update Process

1. Create a new GitHub Release (tag `vX.Y.Z`).
2. Update the `url` and `sha256` in `Formula/vps-installer.rb`.
3. Test locally: `brew install --build-from-source Formula/vps-installer.rb`.