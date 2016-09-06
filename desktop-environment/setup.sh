
CONFIG_ROOT="$(realpath "$1")"

bash "$CONFIG_ROOT/setup-sddm.sh" "$CONFIG_ROOT"
bash "$CONFIG_ROOT/setup-cinnamon.sh" "$CONFIG_ROOT"
