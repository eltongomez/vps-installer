#!/bin/bash
set -e

# Ensure we are in the project root
if [ ! -f "setup-vps.sh" ]; then
    echo "❌ Error: Please run this script from the project root directory."
    echo "Usage: ./packaging/build-deb.sh"
    exit 1
fi

# Configuration
PACKAGE_NAME="vps-installer"
# Try to extract version from script, default to 2.0.0
VERSION=$(grep "Versão:" setup-vps.sh 2>/dev/null | awk '{print $3}' || echo "2.0.0")
ARCH="all"
MAINTAINER="Agenda Viva AI <contato@agendaviva.ai>"
DESCRIPTION="Professional VPS Installer with Docker Stacks
 Automated installer for Traefik, Chatwoot, Odoo, n8n, Evolution API and more.
 Features:
 - Interactive and Non-Interactive modes
 - Automatic Backup and Restore
 - Security Hardening (SSH, Firewall)
 - Health Checks and Monitoring"

# Build paths
BUILD_ROOT="packaging/build"
PACKAGE_DIR="${BUILD_ROOT}/${PACKAGE_NAME}_${VERSION}_${ARCH}"
BIN_DIR="${PACKAGE_DIR}/usr/local/bin"
DOC_DIR="${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}"
DEBIAN_DIR="${PACKAGE_DIR}/DEBIAN"

echo "📦 Starting build for ${PACKAGE_NAME} v${VERSION}..."

# Clean up
rm -rf "$BUILD_ROOT"
mkdir -p "$BIN_DIR" "$DOC_DIR" "$DEBIAN_DIR"

# 1. Install Binary
echo "-> Installing binary..."
cp setup-vps.sh "${BIN_DIR}/${PACKAGE_NAME}"
chmod 755 "${BIN_DIR}/${PACKAGE_NAME}"

# 2. Install Documentation
echo "-> Installing documentation..."
cp README.md LICENSE "${DOC_DIR}/" 2>/dev/null || true
cp *.md "${DOC_DIR}/" 2>/dev/null || true

# 3. Create Control File
echo "-> Generating control file..."
cat > "${DEBIAN_DIR}/control" <<EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash (>= 4.0), curl, git, docker.io | docker-ce, docker-compose | docker-compose-plugin
Maintainer: ${MAINTAINER}
Description: ${DESCRIPTION}
EOF

# 4. Build Package
echo "-> Building .deb package..."
dpkg-deb --build "$PACKAGE_DIR"

# 5. Verify
DEB_FILE="${BUILD_ROOT}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
if [ -f "$DEB_FILE" ]; then
    echo "✅ Build successful!"
    echo "   File: $DEB_FILE"
    echo "   Size: $(du -h "$DEB_FILE" | cut -f1)"
else
    echo "❌ Build failed."
    exit 1
fi