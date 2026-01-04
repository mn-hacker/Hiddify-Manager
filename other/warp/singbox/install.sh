
if ! [ -f "wgcf-account.toml" ];then
    # mv wgcf-account.toml wgcf-account.toml.backup
    TAR="https://api.github.com/repos/ViRb3/wgcf/releases/latest"
    ARCH=$(dpkg --print-architecture)
    URL=$(curl --connect-timeout 10 -fsSL ${TAR} | grep 'browser_download_url' | cut -d'"' -f4 | grep linux | grep "${ARCH}")
    if [ -n "$URL" ]; then
        curl --connect-timeout 10 -fsSL "${URL}" -o ./wgcf && chmod +x ./wgcf && mv ./wgcf /usr/bin
    else
        echo "WARP: wgcf download URL not found, skipping"
    fi
fi



ARCHITECTURE=$(dpkg --print-architecture)

# Download warp-go with error handling
latest=$(curl --connect-timeout 10 -q https://gitlab.com/api/v4/projects/ProjectWARP%2Fwarp-go/releases 2>/dev/null | awk -F '"' '{for (i=0; i<NF; i++) if ($i=="tag_name") {print $(i+2); exit}}' | sed "s/v//")
latest=${latest:-'1.0.8'}

if curl --connect-timeout 10 -o /tmp/warp-go.tar.gz "https://raw.githubusercontent.com/fscarmen/warp/main/warp-go/warp-go_${latest}_linux_${ARCHITECTURE}.tar.gz" 2>/dev/null; then
    if tar xzf /tmp/warp-go.tar.gz -C /tmp/ warp-go 2>/dev/null; then
        chmod +x /tmp/warp-go
        mv /tmp/warp-go .
        rm -f /tmp/warp-go.tar.gz
        echo "WARP: warp-go installed successfully"
    else
        echo "WARP: Failed to extract warp-go (may not be gzip format)"
        rm -f /tmp/warp-go.tar.gz
    fi
else
    echo "WARP: Failed to download warp-go"
fi