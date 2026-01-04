# Only enable/restart if service file exists
if [ -f "/etc/systemd/system/hiddify-ss-faketls.service" ]; then
    systemctl daemon-reload
    systemctl enable hiddify-ss-faketls.service
    systemctl restart hiddify-ss-faketls.service
fi
