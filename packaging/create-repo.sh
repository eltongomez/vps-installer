#!/bin/bash
set -e

# Ensure we are in the project root
if [ ! -f "setup-vps.sh" ]; then
    echo "❌ Error: Please run this script from the project root directory."
    exit 1
fi

# Check dependencies
if ! command -v reprepro &> /dev/null; then
    echo "❌ Error: 'reprepro' is not installed."
    echo "  Debian/Ubuntu: sudo apt install reprepro"
    echo "  macOS: brew install reprepro"
    exit 1
fi

# Configuration
REPO_ROOT="packaging/repo"
CONF_DIR="$REPO_ROOT/conf"
CODENAME="stable"
ARCHS="amd64 arm64 all"
COMPONENTS="main"
PACKAGE_NAME="vps-installer"

echo "📦 Setting up APT repository structure in $REPO_ROOT..."

# Create directory structure
mkdir -p "$CONF_DIR"

# Generate distributions file
cat > "$CONF_DIR/distributions" <<EOF
Origin: VPS Installer
Label: VPS Installer Repo
Codename: $CODENAME
Architectures: $ARCHS
Components: $COMPONENTS
Description: Official VPS Installer Repository
EOF

# Check for GPG Key for signing
if [ -n "$GPG_KEY" ]; then
    echo "SignWith: $GPG_KEY" >> "$CONF_DIR/distributions"
    echo "🔑 Signing with key: $GPG_KEY"
else
    echo "⚠️  GPG_KEY environment variable not set. Repository will not be signed."
    echo "   To sign: export GPG_KEY=YOUR_KEY_ID"
fi

# Find package
DEB_FILE=$(find packaging/build -name "${PACKAGE_NAME}_*.deb" 2>/dev/null | head -n 1)

if [ -z "$DEB_FILE" ]; then
    echo "❌ No .deb package found in packaging/build/"
    echo "   Run ./packaging/build-deb.sh first."
    exit 1
fi

echo "-> Processing package: $DEB_FILE"

# Remove existing package version to allow overwrite (idempotency)
reprepro -b "$REPO_ROOT" remove "$CODENAME" "$PACKAGE_NAME" 2>/dev/null || true

# Add package to repo
reprepro -b "$REPO_ROOT" includedeb "$CODENAME" "$DEB_FILE"

echo "✅ Repository generated successfully at: $REPO_ROOT"
echo "   Structure: dists/ pool/"