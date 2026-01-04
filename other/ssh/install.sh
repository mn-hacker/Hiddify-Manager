source /opt/hiddify-manager/common/utils.sh
source /opt/hiddify-manager/common/package_manager.sh

mkdir -p host_key
version="" #use specific version if needed otherwise it will use the latest
download_package ssh-liberty-bridge ssh-liberty-bridge $version
if [ "$?" == "0"  ] || ! is_installed ./ssh-liberty-bridge; then
    chmod +x ssh-liberty-bridge
    useradd liberty-bridge 2>/dev/null || true
    set_installed_version ssh-liberty-bridge $version
fi
# Only chown if .env files exist
ls .env* >/dev/null 2>&1 && chown liberty-bridge .env* || true