cd $(dirname -- "$0")
source ./utils.sh
activate_python_venv

domains=$(cat ../current.json | jq -r '.domains[] | .domain' | tr '\n' ' ')


# Loop over the .crt files
shopt -s nullglob  # Prevent errors when no files match
for f in /opt/hiddify-manager/ssl/*.crt; do
    # Get the basename without the .crt extension
    d=$(basename "$f" .crt)
    # Check if $d is not in the list of domains
    if [[ ! " ${domains[@]} " =~ " ${d} " ]]; then
        # If $d is not in domains, remove the file
        rm -f "/opt/hiddify-manager/ssl/$d.crt" 2>/dev/null || true
        rm -f "/opt/hiddify-manager/ssl/$d.crt.key" 2>/dev/null || true
    fi
done
shopt -u nullglob

# we need at least one ssl certificate to be able to run haproxy
for d in $domains; do
    (bash /opt/hiddify-manager/acme.sh/generate_self_signed_cert.sh $d >/dev/null 2>&1)
done

# /opt/hiddify-manager/.venv313/bin/python -c "import json5;import jinja2" || uv pip install json5 jinja2
# rm -f /opt/hiddify-manager/singbox/configs/*.json
rm -f /opt/hiddify-manager/xray/configs/05_inbounds_10*.json*
rm -f /opt/hiddify-manager/xray/configs/05_inbounds_h2*.json*
rm -f /opt/hiddify-manager/xray/configs/05_inbounds_02_realitygrpc*.json*
rm -f /opt/hiddify-manager/xray/configs/05_inbounds_02_realityh2*.json*
rm -f /opt/hiddify-manager/singbox/configs/05_inbounds_2071_realitygrpc_main.json*
rm -f /opt/hiddify-manager/singbox/configs/05_inbounds_20[123][1234]*.json*


/opt/hiddify-manager/common/jinja.py $MODE
