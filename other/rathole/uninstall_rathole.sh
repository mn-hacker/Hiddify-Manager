#!/bin/bash

# Rathole Core Uninstaller
# This script removes the rathole binary and related files

set -e

RATHOLE_DIR="/opt/hiddify-manager/other/rathole"

echo "Uninstalling Rathole..."

# Stop all rathole services
for service in /etc/systemd/system/rathole-*.service; do
    if [ -f "$service" ]; then
        service_name=$(basename "$service")
        echo "Stopping $service_name..."
        systemctl stop "$service_name" 2>/dev/null || true
        systemctl disable "$service_name" 2>/dev/null || true
        rm -f "$service" 2>/dev/null || true
    fi
done

# Reload systemd
systemctl daemon-reload 2>/dev/null || true

# Remove rathole binary
if [ -f "$RATHOLE_DIR/rathole" ]; then
    rm -f "$RATHOLE_DIR/rathole"
    echo "Rathole binary removed."
fi

# Remove config files
rm -f "$RATHOLE_DIR"/*.toml 2>/dev/null || true

echo "Rathole uninstalled successfully!"
exit 0
