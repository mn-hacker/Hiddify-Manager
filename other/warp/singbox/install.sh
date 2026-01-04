
if ! [ -f "wgcf-account.toml" ];then
    # Download wgcf binary
    TAR="https://api.github.com/repos/ViRb3/wgcf/releases/latest"
    ARCH=$(dpkg --print-architecture)
    URL=$(curl --connect-timeout 10 -fsSL ${TAR} 2>/dev/null | grep 'browser_download_url' | cut -d'"' -f4 | grep linux | grep "${ARCH}")
    if [ -n "$URL" ]; then
        curl --connect-timeout 10 -fsSL "${URL}" -o ./wgcf && chmod +x ./wgcf && mv ./wgcf /usr/bin
    else
        echo "WARP: wgcf download URL not found, skipping"
    fi
fi

ARCHITECTURE=$(dpkg --print-architecture)

# warp-go is optional and often fails to download
# Try multiple sources with proper error handling
download_warp_go() {
    local version=${1:-"1.0.8"}
    local arch=$ARCHITECTURE
    
    # Try direct GitHub release
    local urls=(
        "https://github.com/fscarmen/warp/releases/download/v${version}/warp-go_${version}_linux_${arch}.tar.gz"
        "https://raw.githubusercontent.com/fscarmen/warp/main/warp-go/warp-go_${version}_linux_${arch}.tar.gz"
    )
    
    for url in "${urls[@]}"; do
        if curl --connect-timeout 5 -sL -o /tmp/warp-go.tar.gz "$url" 2>/dev/null; then
            # Check if it's actually a gzip file
            if file /tmp/warp-go.tar.gz | grep -q "gzip"; then
                if tar xzf /tmp/warp-go.tar.gz -C /tmp/ 2>/dev/null; then
                    if [ -f /tmp/warp-go ]; then
                        chmod +x /tmp/warp-go
                        mv /tmp/warp-go .
                        rm -f /tmp/warp-go.tar.gz
                        echo "WARP: warp-go installed successfully"
                        return 0
                    fi
                fi
            fi
        fi
        rm -f /tmp/warp-go.tar.gz
    done
    
    echo "WARP: warp-go download failed (optional component, continuing...)"
    return 1
}

# Try to get latest version, fallback to 1.0.8
latest=$(curl --connect-timeout 5 -sL "https://gitlab.com/api/v4/projects/ProjectWARP%2Fwarp-go/releases" 2>/dev/null | awk -F '"' '{for (i=0; i<NF; i++) if ($i=="tag_name") {print $(i+2); exit}}' | sed "s/v//")
latest=${latest:-"1.0.8"}

download_warp_go "$latest"