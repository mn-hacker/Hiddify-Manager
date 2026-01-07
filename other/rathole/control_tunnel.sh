#!/bin/bash

# Rathole Tunnel Control
# Controls tunnel service (start/stop/restart/status)
# Usage: control_tunnel.sh <action> <type> <tunnel_port>
# Actions: start, stop, restart, status
# Example: control_tunnel.sh start kharej 8080

set -e

ACTION="$1"
TYPE="$2"
TUNNEL_PORT="$3"

if [ -z "$ACTION" ] || [ -z "$TYPE" ] || [ -z "$TUNNEL_PORT" ]; then
    echo "Error: Usage: control_tunnel.sh <action> <type> <tunnel_port>"
    echo "Actions: start, stop, restart, status"
    exit 1
fi

SERVICE_NAME="rathole-${TYPE}${TUNNEL_PORT}"

case "$ACTION" in
    start)
        systemctl start "${SERVICE_NAME}.service"
        echo "Tunnel ${TYPE}${TUNNEL_PORT} started."
        ;;
    stop)
        systemctl stop "${SERVICE_NAME}.service"
        echo "Tunnel ${TYPE}${TUNNEL_PORT} stopped."
        ;;
    restart)
        systemctl restart "${SERVICE_NAME}.service"
        echo "Tunnel ${TYPE}${TUNNEL_PORT} restarted."
        ;;
    status)
        if systemctl is-active --quiet "${SERVICE_NAME}.service"; then
            echo "active"
        else
            echo "inactive"
        fi
        ;;
    enable)
        systemctl enable "${SERVICE_NAME}.service"
        systemctl start "${SERVICE_NAME}.service"
        echo "Tunnel ${TYPE}${TUNNEL_PORT} enabled and started."
        ;;
    disable)
        systemctl stop "${SERVICE_NAME}.service"
        systemctl disable "${SERVICE_NAME}.service"
        echo "Tunnel ${TYPE}${TUNNEL_PORT} disabled and stopped."
        ;;
    *)
        echo "Error: Unknown action '$ACTION'. Use: start, stop, restart, status, enable, disable"
        exit 1
        ;;
esac

exit 0
