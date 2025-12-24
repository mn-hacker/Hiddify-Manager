#!/bin/bash
# Remove deprecated components from Hiddify Manager
# This script is called during installation to clean up old/unused services

echo "Cleaning up deprecated components..."

# ShadowTLS
systemctl stop --now shadowtls >/dev/null 2>&1
systemctl disable shadowtls >/dev/null 2>&1
rm -rf /opt/hiddify-manager/other/shadowtls/

# sniproxy (replaced by HAProxy)
systemctl stop --now hiddify-sniproxy >/dev/null 2>&1
systemctl disable hiddify-sniproxy >/dev/null 2>&1
pkill -9 sniproxy >/dev/null 2>&1

# Trojan-go (replaced by Xray trojan)
systemctl stop --now trojan-go >/dev/null 2>&1
systemctl disable trojan-go >/dev/null 2>&1

# Caddy (replaced by Nginx)
systemctl stop --now caddy >/dev/null 2>&1
systemctl disable caddy >/dev/null 2>&1

# Clash server
systemctl stop --now clash >/dev/null 2>&1
systemctl disable clash >/dev/null 2>&1

# Monitoring/Netdata
systemctl stop --now netdata >/dev/null 2>&1
systemctl disable netdata >/dev/null 2>&1

echo "Deprecated components cleanup completed."