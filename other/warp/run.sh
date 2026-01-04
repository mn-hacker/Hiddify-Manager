#!/bin/bash
# Run warp from the appropriate directory
cd /opt/hiddify-manager/other/warp/wireguard 2>/dev/null && bash run.sh || echo "WARP wireguard directory not found"