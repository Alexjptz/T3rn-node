#!/bin/bash

tput reset
tput civis

# VARS
ENV_FILE="$HOME/t3rn/.env"

# SYSTEM FUNCS
show_orange() { echo -e "\e[33m$1\e[0m"; }
show_blue() { echo -e "\e[34m$1\e[0m"; }
show_green() { echo -e "\e[32m$1\e[0m"; }
show_red() { echo -e "\e[31m$1\e[0m"; }
show_cyan() { echo -e "\e[36m$1\e[0m"; }
show_purple() { echo -e "\e[35m$1\e[0m"; }
show_gray() { echo -e "\e[90m$1\e[0m"; }
show_white() { echo -e "\e[97m$1\e[0m"; }
show_blink() { echo -e "\e[5m$1\e[0m"; }

exit_script() {
    echo
    show_red   "🚫 Script terminated by user"
    show_gray  "────────────────────────────────────────────────────────────"
    show_orange "⚠️  All processes stopped. Returning to shell..."
    show_green "Goodbye, Agent. Stay legendary."
    echo
    sleep 1
    exit 0
}

incorrect_option() {
    echo
    show_red   "⛔️  Invalid option selected"
    show_orange "🔄  Please choose a valid option from the menu"
    show_gray  "Tip: Use numbers shown in brackets [1] [2] [3]..."
    echo
    sleep 1
}

process_notification() {
    local message="$1"
    local delay="${2:-1}"  # пауза в секундах, по умолчанию 1

    echo
    show_gray  "────────────────────────────────────────────────────────────"
    show_orange "🔔  $message"
    show_gray  "────────────────────────────────────────────────────────────"
    echo
    sleep "$delay"
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        show_green "✅ Success"
    else
        sleep 1
        show_red "❌ Error while executing command"
    fi

    echo
}

installation_completed() {
    echo
    show_gray  "────────────────────────────────────────────────────────────"
    show_green "🎯 Executor node installed successfully!"
    show_gray  "────────────────────────────────────────────────────────────"
    show_orange "⚡ IF REQUIRED:"
    show_cyan   "   ➤ Go to [🛠️  Configure] menu and change options"
    show_cyan   "   ➤ This includes keys, endpoints, modes and networks"
    show_gray   "────────────────────────────────────────────────────────────"
    echo
}

# MENU FUNC
menu_header() {
    local node_status
    if systemctl is-active --quiet t3rn-executor; then
        node_status="🟢 RUNNING (systemd)"
    else
        node_status="🔴 STOPPED"
    fi

    show_gray  "────────────────────────────────────────────────────────────"
    show_cyan  "     ⚙️ LEGENDS GROUP T3RN CONTROL INTERFACE"
    show_gray  "────────────────────────────────────────────────────────────"
    echo
    show_orange "Agent: $(whoami)     🕒 $(date +"%H:%M:%S")     🗓️  $(date +"%Y-%m-%d")"
    show_green  "Service Status: $node_status"
    echo
    sleep 0.3
}

menu_item() {
    local num="$1"
    local icon="$2"
    local title="$3"
    local description="$4"


    local formatted_line
    formatted_line=$(printf "  [%-1s] %-2s %-20s - %s" "$num" "$icon" "$title" "$description")
    show_blue "$formatted_line"
}

show_support_menu() {
    clear
    menu_header
    process_notification "🆘 HELP & SUPPORT PANEL"
    show_orange "📬 Contact:"
    echo -e "   \e[4m\e[36mhttps://t.me/LegendsGroupSupportBot\e[0m"
    echo
    show_gray  "────────────────────────────────────────────────────────────"
    echo

    read -p "$(show_gray '↩️  Press Enter to return to the main menu...')"
    clear
}

print_logo() {
    clear
    tput civis

    local logo_lines=(
        " .___________. ____   .______      .__   __. "
        " |           ||___ \  |   _  \     |  \ |  | "
        "  ---|  |----   __) | |  |_)  |    |   \|  | "
        "     |  |      |__ <  |      /     |  .    | "
        "     |  |      ___) | |  |\  \----.|  |\   | "
        "     |__|     |____/  | _|  ._____||__| \__| "
    )

    local messages=(
        ">> Booting secure layer..."
        ">> Establishing encrypted handshake..."
        ">> Loading neural agent module..."
        ">> Syncing with core network..."
        ">> Activating smart protocols..."
        ">> Checking agent credentials..."
        ">> Terminal integrity: OK"
        ">> Injecting virtual keys..."
    )

    echo
    show_cyan "🛰️ INITIALIZING MODULE: \c"
    show_purple "LEGENDS GROUP"
    show_gray "────────────────────────────────────────────────────────────"
    echo
    sleep 0.5

    show_gray "Loading: \c"
    for i in {1..30}; do
        echo -ne "\e[32m█\e[0m"
        sleep 0.02
    done
    show_green " [100%]"
    echo
    sleep 0.3

    for msg in "${messages[@]}"; do
        show_gray "$msg"
        sleep 0.15
    done
    echo
    sleep 0.5

    for line in "${logo_lines[@]}"; do
        show_cyan "$line"
        sleep 0.08
    done

    echo
    show_green "⚙️  SYSTEM STATUS: ACTIVE"
    show_orange ">> ACCESS GRANTED. WELCOME, AGENT OF LEGENDS."
    show_gray "[LEGENDS-CORE v1.0.0 / Secure Terminal Session]"
    echo

    echo -ne "\e[1;37mAwaiting commands"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.4
    done
    echo -e "\e[0m"
    sleep 0.5

    tput cnorm
}

# NODE FUNCS

confirm_prompt() {
    local prompt="$1"
    read -p "$prompt (y/N): " response
    response=$(echo "$response" | xargs)
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

prompt_input() {
    local prompt="$1"
    local var
    read -p "$prompt" var
    echo "$var" | xargs
}

is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

initialize_dynamic_network_data() {
    unset network_names executor_ids expected_chain_ids rpcs
    declare -gA network_names executor_ids expected_chain_ids rpcs

    for key in "${!networks[@]}"; do
        IFS="|" read -r name chain_id urls executor_id <<<"${networks[$key]}"
        network_names[$key]="$name"
        executor_ids[$key]="${executor_id:-$key}"
        expected_chain_ids[$key]="$chain_id"
        rpcs[$key]="$urls"
    done
}

declare -A networks=(
    # Testnets
    [l2rn]="B2N Testnet|334|https://b2n.rpc.caldera.xyz/http|l2rn"
    [arbt]="Arbitrum Sepolia|421614|https://arbitrum-sepolia-rpc.publicnode.com https://sepolia-rollup.arbitrum.io/rpc|arbitrum-sepolia"
    [bast]="Base Sepolia|84532|https://base-sepolia-rpc.publicnode.com https://sepolia.base.org|base-sepolia"
    [blst]="Blast Sepolia|168587773|https://rpc.ankr.com/blast_testnet_sepolia https://sepolia.blast.io|blast-sepolia"
    [opst]="Optimism Sepolia|11155420|https://optimism-sepolia-rpc.publicnode.com https://sepolia.optimism.io|optimism-sepolia"
    [unit]="Unichain Sepolia|1301|https://unichain-sepolia-rpc.publicnode.com https://sepolia.unichain.org|unichain-sepolia"
    [mont]="Monad Testnet|10143|https://testnet-rpc.monad.xyz|monad-testnet"
    [seit]="Sei Testnet|1328|https://evm-rpc-testnet.sei-apis.com|sei-testnet"
    [bsct]="BNB Testnet|97|https://bnb-testnet.api.onfinality.io/public https://bsc-testnet-rpc.publicnode.com|binance-testnet"
    [gnot]="Gnosis Testnet|10200|https://gnosis-chiado-rpc.publicnode.com|gnosis-testnet"
    [lskt]="Lisk Sepolia|4202|https://rpc.sepolia-api.lisk.com|lisk-sepolia"
    [lint]="Linea Sepolia|59141|https://rpc.sepolia.linea.build https://linea-sepolia-rpc.publicnode.com|linea-sepolia"
    [abst]="Abstract Sepolia|11124|https://api.testnet.abs.xyz|abstract-sepolia"
    [bert]="Berachain Bepolia|80069|https://bepolia.rpc.berachain.com|berachain-bepolia"

    # Mainnet
    [opmn]="Optimism Mainnet|10|https://optimism-rpc.publicnode.com|optimism"
    [arbm]="Arbitrum Mainnet|42161|https://arbitrum-one-rpc.publicnode.com|arbitrum"
    [basm]="Base Mainnet|8453|https://base-rpc.publicnode.com|base"
)

load_env_file() {
    if [[ -f "$ENV_FILE" ]]; then
        show_orange "📥 Loading environment variables from .env..."

        # 🔁 Очистка старых переменных
        set +a
        local vars_to_unset
        vars_to_unset=$(grep -o '^[A-Z_][A-Z0-9_]*' "$ENV_FILE" | xargs)
        [[ -n "$vars_to_unset" ]] && unset $vars_to_unset

        # 🔄 Загрузка переменных из файла
        set -a
        source "$ENV_FILE"
        set +a

        # 🌐 Обработка RPC_ENDPOINTS
        if [[ -n "$RPC_ENDPOINTS" ]]; then
            if echo "$RPC_ENDPOINTS" | jq empty 2>/dev/null; then
                for key in $(echo "$RPC_ENDPOINTS" | jq -r 'keys[]'); do
                    urls=$(echo "$RPC_ENDPOINTS" | jq -r ".$key | @sh" | sed "s/'//g")
                    rpcs[$key]="$urls"
                done
                show_green "✅ RPC_ENDPOINTS loaded from .env."
            else
                show_orange "⚠️ RPC_ENDPOINTS is invalid JSON. Skipping import."
            fi
        else
            show_orange "ℹ️ No RPC_ENDPOINTS found. Using defaults."
            initialize_dynamic_network_data
        fi
    else
        show_orange "ℹ️ .env file not found. Using defaults."
        initialize_dynamic_network_data
    fi
}

get_executor_wallet_address() {
    grep -E '^\#?\s*EXECUTOR_WALLET_ADDRESS=' "$HOME/t3rn/.env" | cut -d= -f2
}

rebuild_rpc_endpoints() {
    show_orange "🔧 Rebuilding RPC_ENDPOINTS variable..."

    local rpc_json
    rpc_json=$(jq -n '{}')  # Пустой объект JSON

    for key in "${!rpcs[@]}"; do
        # Преобразуем список URL в JSON-массив
        local urls_json
        urls_json=$(printf '%s\n' ${rpcs[$key]} | jq -R . | jq -s .)

        # Добавляем к итоговому объекту
        rpc_json=$(echo "$rpc_json" | jq --arg k "$key" --argjson v "$urls_json" '. + {($k): $v}')
    done

    export RPC_ENDPOINTS="$rpc_json"
    show_green "✅ RPC_ENDPOINTS rebuilt and exported."
}

wait_for_wallet_log_and_save() {
    local env_file="$HOME/t3rn/.env"
    local start_time=$(date +%s)
    local timeout=10

    process_notification "📡 Waiting for wallet address from logs..."

    while true; do
        address=$(journalctl -u t3rn-executor --no-pager -n 50 -r |
            grep '✅ Wallet loaded' |
            sed -n 's/.*\({.*\)/\1/p' |
            jq -r '.address' 2>/dev/null |
            grep -E '^0x[a-fA-F0-9]{40}' |
            head -n 1)

        if [[ -n "$address" ]]; then
            if grep -q 'EXECUTOR_WALLET_ADDRESS=' "$env_file"; then
                show_blue "ℹ️ Wallet address already noted in .env."
            else
                echo "# EXECUTOR_WALLET_ADDRESS=$address" >>"$env_file"
                show_green "✅ Wallet address saved to .env: $address"
            fi
            break
        fi

        local current_time
        current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        ((elapsed > timeout)) && {
            show_orange "⏳ Timeout reached. Wallet address not found in logs."
            break
        }

        sleep 1
    done
}

install_executor_latest() {
    echo
    process_notification "🌐 Fetching latest Executor version from GitHub..."

    TAG=$(curl -s --max-time 5 --connect-timeout 3 https://api.github.com/repos/t3rn/executor-release/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')

    if [[ -z "$TAG" ]]; then
        show_red "❌ Failed to fetch latest version from GitHub."
        return
    fi

    show_green "✅ Latest version found: $TAG"
    sleep 0.5
    run_executor_install "$TAG"
}

install_executor_specific() {
    echo
    process_notification "🔢 Install Executor - Specific Version"

    local input_version
    input_version=$(prompt_input "🛠️ Enter version (e.g. 0.70.0):")

    if [[ -z "$input_version" ]]; then
        show_orange "↩️ No version entered. Returning to previous menu."
        return
    fi

    local TAG="v${input_version#v}"
    show_cyan "🎯 Selected version: $TAG"
    sleep 0.5

    run_executor_install "$TAG"
}

validate_config_before_start() {
    echo
    show_orange "🧪 VALIDATING CONFIGURATION..."

    local error=false
    local bin_path="$HOME/t3rn/executor/executor/bin/executor"

    if [[ -z "$PRIVATE_KEY_LOCAL" || ! "$PRIVATE_KEY_LOCAL" =~ ^[a-fA-F0-9]{64}$ ]]; then
        show_red "❌ Invalid PRIVATE_KEY_LOCAL. Must be a 64-char hex string."
        error=true
    fi

    if [[ -z "$RPC_ENDPOINTS" ]]; then
        show_red "❌ RPC_ENDPOINTS is empty."
        error=true
    elif ! echo "$RPC_ENDPOINTS" | jq empty &>/dev/null; then
        show_red "❌ RPC_ENDPOINTS is not valid JSON."
        error=true
    fi

    if [[ -z "$EXECUTOR_ENABLED_NETWORKS" ]]; then
        show_red "❌ No networks enabled. Check NETWORKS_DISABLED or config menu."
        error=true
    fi

    if [[ ! -f "$bin_path" ]]; then
        show_red "❌ Executor binary not found at: $bin_path"
        error=true
    elif [[ ! -x "$bin_path" ]]; then
        show_red "❌ Executor binary is not executable. Run: chmod +x $bin_path"
        error=true
    fi

    for flag in EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API EXECUTOR_PROCESS_ORDERS_API_ENABLED; do
        [[ "${!flag}" != "true" && "${!flag}" != "false" ]] && {
            show_red "❌ $flag must be 'true' or 'false'."
            error=true
        }
    done

    local available_space
    available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if ((available_space < 500000)); then
        show_orange "⚠️ Less than 500MB free space on disk."
    fi

    ! command -v systemctl &>/dev/null && {
        show_red "❌ systemctl not found. Required to manage service."
        error=true
    }

    ! sudo -n true 2>/dev/null && {
        show_orange "⚠️ Sudo password may be required during executor setup."
    }

    if [[ "$error" == true ]]; then
        show_red "❌ Configuration invalid. Please fix errors above."
        return 1
    else
        show_green "✅ Configuration is valid and ready to run."
        return 0
    fi
}

save_env_file() {
    mkdir -p "$HOME/t3rn"

    local wallet_comment=""
    [[ -f "$ENV_FILE" ]] && wallet_comment=$(grep '^# EXECUTOR_WALLET_ADDRESS=' "$ENV_FILE")

    rebuild_network_lists

    show_orange "💾 Saving environment to .env file..."

    cat >"$ENV_FILE" <<EOF
# ⚠️ Your PRIVATE KEY is stored at the bottom. DO NOT SHARE this file.

ENVIRONMENT=${ENVIRONMENT:-testnet}
LOG_LEVEL=${LOG_LEVEL:-debug}
LOG_PRETTY=${LOG_PRETTY:-false}

EXECUTOR_PROCESS_BIDS_ENABLED=${EXECUTOR_PROCESS_BIDS_ENABLED:-true}
EXECUTOR_PROCESS_ORDERS_ENABLED=${EXECUTOR_PROCESS_ORDERS_ENABLED:-true}
EXECUTOR_PROCESS_CLAIMS_ENABLED=${EXECUTOR_PROCESS_CLAIMS_ENABLED:-true}
EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=${EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API:-true}
EXECUTOR_PROCESS_ORDERS_API_ENABLED=${EXECUTOR_PROCESS_ORDERS_API_ENABLED:-true}
EXECUTOR_MAX_L3_GAS_PRICE=${EXECUTOR_MAX_L3_GAS_PRICE:-1000}
EXECUTOR_PROCESS_BIDS_API_INTERVAL_SEC=${EXECUTOR_PROCESS_BIDS_API_INTERVAL_SEC:-30}
EXECUTOR_MIN_BALANCE_THRESHOLD_ETH=${EXECUTOR_MIN_BALANCE_THRESHOLD_ETH:-1}
PROMETHEUS_ENABLED=${PROMETHEUS_ENABLED:-false}

# Example: eth,t3eth,t3mon,t3sei,mon,sei
# EXECUTOR_ENABLED_ASSETS=

EXECUTOR_ENABLED_NETWORKS=${EXECUTOR_ENABLED_NETWORKS}
NETWORKS_DISABLED=${NETWORKS_DISABLED}

# Available Networks (examples):
# l2rn,arbitrum-sepolia,base-sepolia,unichain-sepolia,optimism-sepolia,blast-sepolia,sei-testnet,monad-testnet
# Mainnet Options: optimism,arbitrum,base

RPC_ENDPOINTS='${RPC_ENDPOINTS}'

PRIVATE_KEY_LOCAL=${PRIVATE_KEY_LOCAL:-""}
EOF

    if [[ -n "$wallet_comment" ]]; then
        echo "$wallet_comment" >>"$ENV_FILE"
    fi

    show_green "✅ .env file saved at: $ENV_FILE"
}


create_systemd_unit() {
    local unit_path="/etc/systemd/system/t3rn-executor.service"
    local exec_path="$HOME/t3rn/executor/executor/bin/executor"

    show_orange "🛠️ Creating systemd service..."

    sudo bash -c "cat > $unit_path" <<EOF
[Unit]
Description=Executor Installer Service
After=network.target

[Service]
Type=simple
User=${SUDO_USER:-$USER}
WorkingDirectory=$(dirname "$exec_path")
EnvironmentFile=$ENV_FILE
ExecStart=$exec_path
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now t3rn-executor

    echo
    if systemctl is-active --quiet t3rn-executor; then
        show_green "🚀 Executor systemd unit created and running."
    else
        show_red "❌ Executor failed to start. Please check logs via:"
        show_cyan "   ➤ journalctl -u t3rn-executor -f"
    fi
}

rebuild_network_lists() {
    local default_disabled=(
        optimism
        arbitrum
        base
        gnosis-testnet
        lisk-sepolia
        linea-sepolia
        abstract-sepolia
        berachain-bepolia
    )

    NETWORKS_DISABLED="${NETWORKS_DISABLED:-$(
        IFS=','; echo "${default_disabled[*]}"
    )}"

    NETWORKS_DISABLED=$(echo "$NETWORKS_DISABLED" | tr ',' '\n' | awk '!seen[$0]++' | paste -sd, -)

    declare -A seen
    local enabled_networks=()

    for key in "${!executor_ids[@]}"; do
        executor_id="${executor_ids[$key]}"
        if [[ "$NETWORKS_DISABLED" != *"$executor_id"* && -z "${seen[$executor_id]}" ]]; then
            enabled_networks+=("$executor_id")
            seen[$executor_id]=1
        fi
    done

    EXECUTOR_ENABLED_NETWORKS="$(IFS=','; echo "${enabled_networks[*]}")"
}

initialize_dynamic_network_data

edit_rpc_menu() {
    clear
    menu_header
    process_notification "🌐 EDIT RPC ENDPOINTS"

    local changes_made=false

    IFS=',' read -ra disabled_networks <<<"$NETWORKS_DISABLED"
    declare -A disabled_lookup
    for dn in "${disabled_networks[@]}"; do
        disabled_lookup["$dn"]=1
    done

    for net in "${!networks[@]}"; do
        IFS="|" read -r name chain_id urls executor_id <<<"${networks[$net]}"
        [[ -n "${disabled_lookup[$executor_id]}" ]] && continue

        show_cyan "🔗 $name"
        show_gray "Current: ${rpcs[$net]}"
        echo

        while true; do
            read -p "$(show_gray '➡️ Enter new RPC URLs (space-separated, or ENTER to skip): ')" input
            echo

            [[ -z "$input" ]] && show_blue "ℹ️ Skipped updating $name." && break

            local valid_urls=()
            local invalid=false

            for url in $input; do
                if [[ "$url" =~ ^https?:// ]]; then
                    show_orange "⏳ Checking RPC: $url ..."
                    local response=$(curl --silent --max-time 5 -X POST "$url" \
                        -H "Content-Type: application/json" \
                        --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}')

                    local actual_chain_id_hex=$(echo "$response" | jq -r '.result')
                    if [[ "$actual_chain_id_hex" == "null" || -z "$actual_chain_id_hex" ]]; then
                        show_red "❌ Invalid or empty response: $url"
                        invalid=true
                        continue
                    fi

                    local actual_chain_id_dec=$((16#${actual_chain_id_hex#0x}))
                    if [[ "$actual_chain_id_dec" == "$chain_id" ]]; then
                        valid_urls+=("$url")
                    else
                        show_red "❌ Wrong ChainID: expected $chain_id, got $actual_chain_id_dec."
                        invalid=true
                    fi
                else
                    show_red "❌ Invalid URL format (must start with http:// or https://): $url"
                    invalid=true
                fi
                echo
            done

            if [[ "$invalid" == false && "${#valid_urls[@]}" -gt 0 ]]; then
                rpcs[$net]="${valid_urls[*]}"
                changes_made=true
                show_green "✅ Updated $name."
                echo
                break
            else
                show_orange "🚫 One or more URLs were invalid. Please re-enter RPCs for $name."
            fi
        done

        echo
    done

    if [[ "$changes_made" == true ]]; then
        rebuild_rpc_endpoints
        save_env_file
        show_green "✅ RPC endpoints updated and saved."
        if confirm_prompt "🔄 To apply the changes, the Executor must be restarted. Restart now?"; then
            if sudo systemctl restart t3rn-executor; then
                show_green "✅ Executor restarted."
            else
                show_red "❌ Failed to restart executor."
            fi
        else
            show_orange "ℹ️ You can restart manually later from the Main Menu."
        fi
    else
        show_blue "ℹ️ No RPC changes made."
    fi
}

view_executor_logs() {
    process_notification "📡 EXECUTOR LOG STREAM"

    if systemctl list-units --type=service --all | grep -q 't3rn-executor.service'; then
        show_orange "📥 Attaching to systemd logs for t3rn-executor..."
        echo
        sleep 0.5
        sudo journalctl -u t3rn-executor -f --no-pager --output=cat
    else
        show_red   "❌ Executor service not found."
        show_orange "ℹ️  It might not be installed or has been removed."
        echo
    fi
}

run_executor_install() {
    local TAG="$1"

    steps=(
        "🔍 Checking existing folders"
        "🔌 Releasing port 9090"
        "📦 Preparing directory"
        "⬇️ Downloading binary"
        "📂 Extracting archive"
        "🔑 Handling private key"
        "🔧 Configuring environment"
        "🧹 Cleaning up old services"
        "🚀 Creating systemd unit"
        "📡 Launching logs"
    )

    local current=0 total=${#steps[@]}
    step_progress() {
        current=$((current + 1))
        echo -ne "\e[90m[Step $current/$total]\e[0m ${steps[$((current - 1))]}...\n"
    }

    step_progress
    for dir in "$HOME/t3rn" "$HOME/executor"; do
        if [[ -d "$dir" ]]; then
            show_orange "📁 Directory '$(basename "$dir")' already exists."
            if confirm_prompt "❓ Remove it?"; then
                [[ "$(pwd)" == "$dir"* ]] && cd ~
                rm -rf "$dir"
                show_green "✅ Directory removed."
            else
                show_red "🚫 Installation cancelled by user."
                return
            fi
        fi
    done

    step_progress
    if lsof -i :9090 &>/dev/null; then
        local pid_9090=$(lsof -ti :9090)
        [[ -n "$pid_9090" ]] && kill -9 "$pid_9090" && show_orange "🔌 Freed port :9090"
        sleep 1
    fi

    step_progress
    mkdir -p "$HOME/t3rn" && cd "$HOME/t3rn" || exit 1

    step_progress
    wget --quiet --show-progress https://github.com/t3rn/executor-release/releases/download/${TAG}/executor-linux-${TAG}.tar.gz

    step_progress
    tar -xzf executor-linux-${TAG}.tar.gz && rm -f executor-linux-${TAG}.tar.gz
    cd executor/executor/bin || exit 1
    show_green "✅ Executor unpacked successfully."

    step_progress
    while true; do
        private_key=$(prompt_input "🔑 Enter PRIVATE_KEY_LOCAL:")
        private_key=$(echo "$private_key" | sed 's/^0x//')
        if [[ -n "$private_key" ]]; then
            break
        fi

        echo
        show_orange "❓ Continue without private key?"
        echo
        show_blue "  [1] 🔁 Retry"
        show_blue "  [2] ⏩ Continue without key"
        show_blue "  [3] ❌ Cancel"
        echo
        read -p "$(show_gray '➡️ Select option [0-2]: ')" pk_choice
        echo
        case $pk_choice in
            1) continue ;;
            2) break ;;
            3)
                show_red "❌ Cancelled."
                return
                ;;
            *) show_red "❌ Invalid option." ;;
        esac
    done

    export PRIVATE_KEY_LOCAL="$private_key"

    step_progress
    if [[ -n "$RPC_ENDPOINTS" ]]; then
        if echo "$RPC_ENDPOINTS" | jq empty 2>/dev/null; then
            for key in $(echo "$RPC_ENDPOINTS" | jq -r 'keys[]'); do
                urls=$(echo "$RPC_ENDPOINTS" | jq -r ".$key | @sh" | sed "s/'//g")
                rpcs[$key]="$urls"
            done
        fi
    fi

    rebuild_rpc_endpoints
    rebuild_network_lists
    save_env_file
    load_env_file

    if ! validate_config_before_start; then
        show_red "❌ Invalid configuration. Aborting."
        return
    fi

    step_progress
    sudo systemctl disable --now t3rn-executor.service 2>/dev/null
    sudo rm -f /etc/systemd/system/t3rn-executor.service
    sudo systemctl daemon-reload
    sleep 1

    step_progress
    create_systemd_unit

    step_progress
    wait_for_wallet_log_and_save &
    view_executor_logs
}

uninstall_t3rn() {
    clear
    menu_header
    process_notification "🗑️ UNINSTALLING EXECUTOR"

    if ! confirm_prompt "❗ Completely remove Executor?"; then
        echo
        show_red "🚫 Uninstall cancelled."
        return
    fi

    show_orange "🗑️ Removing files and services..."

    sudo rm -f "$ENV_FILE"
    sudo systemctl disable --now t3rn-executor.service 2>/dev/null
    sudo rm -f /etc/systemd/system/t3rn-executor.service
    sudo systemctl daemon-reload

    for dir in "$HOME/t3rn" "$HOME/executor"; do
        if [[ -d "$dir" ]]; then
            [[ "$(pwd)" == "$dir"* ]] && cd ~
            rm -rf "$dir"
            show_green "✔️ Removed: $dir"
        fi
    done

    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s

    unset ENVIRONMENT LOG_LEVEL LOG_PRETTY EXECUTOR_PROCESS_BIDS_ENABLED \
        EXECUTOR_PROCESS_ORDERS_ENABLED EXECUTOR_PROCESS_CLAIMS_ENABLED \
        EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API EXECUTOR_PROCESS_ORDERS_API_ENABLED \
        EXECUTOR_MAX_L3_GAS_PRICE EXECUTOR_PROCESS_BIDS_API_INTERVAL_SEC \
        EXECUTOR_MIN_BALANCE_THRESHOLD_ETH PROMETHEUS_ENABLED PRIVATE_KEY_LOCAL \
        EXECUTOR_ENABLED_NETWORKS NETWORKS_DISABLED RPC_ENDPOINTS

    echo
    show_green "✅ Executor completely removed from system."
    delay 2
}

restart_executor() {
    clear
    menu_header
    process_notification "🔁 RESTARTING EXECUTOR SERVICE"

    show_orange "⏳ Attempting to restart executor..."
    echo

    if sudo systemctl restart t3rn-executor; then
        show_green "✅ Executor restarted successfully."
    else
        show_red "❌ Failed to restart executor."
        echo
    fi

    sleep 1
    clear
}

# CONFIGURATION MENU FUNCS

show_conf_menu() {
    clear
    menu_header
    show_orange "🌐 RPC Configuration Overview:"
    echo
    declare -A rpcs
    while IFS="=" read -r key value; do
        rpcs["$key"]="$value"
    done < <(echo "$RPC_ENDPOINTS" | jq -r 'to_entries[] | "\(.key)=" + (.value | join(" "))')

    IFS=',' read -ra disabled_networks <<<"$NETWORKS_DISABLED"
    declare -A disabled_lookup
    for dn in "${disabled_networks[@]}"; do
        disabled_lookup["$dn"]=1
    done

    for net in "${!networks[@]}"; do
        executor_id="${executor_ids[$net]}"
        [[ -n "${disabled_lookup[$executor_id]}" ]] && continue

        show_cyan "- ${network_names[$net]}:"
        if [[ -n "${rpcs[$net]}" ]]; then
            for url in ${rpcs[$net]}; do
                show_gray "   • $url"
            done
        else
            show_red "   ⚠️ No RPC configured."
        fi
        echo
    done

    read -p "↩️ Press Enter to return..." dummy
}

set_gas_price() {
    clear
    menu_header
    gas=$(prompt_input "⛽ Enter Max L3 Gas Price:")
    if is_number "$gas"; then
        export EXECUTOR_MAX_L3_GAS_PRICE=$gas
        save_env_file
        show_green "✅ Gas price set to: $gas"
        if confirm_prompt "🔄 Restart Executor now?"; then
            sudo systemctl restart t3rn-executor && show_green "✅ Executor restarted." || show_red "❌ Failed to restart."
        else
            show_orange "ℹ️ You can restart manually later."
        fi
    else
        show_orange "ℹ️ No changes."
    fi
}

set_api_flags() {
    clear
    menu_header
    val1=$(prompt_input "🔧 EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API (true/false):")
    val2=$(prompt_input "🔧 EXECUTOR_PROCESS_ORDERS_API_ENABLED (true/false):")
    if [[ "$val1" =~ ^(true|false)$ && "$val2" =~ ^(true|false)$ ]]; then
        export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=$val1
        export EXECUTOR_PROCESS_ORDERS_API_ENABLED=$val2
        save_env_file
        show_green "✅ API flags updated."
        if confirm_prompt "🔄 Restart Executor now?"; then
            sudo systemctl restart t3rn-executor && show_green "✅ Executor restarted." || show_red "❌ Failed to restart."
        else
            show_orange "ℹ️ You can restart manually later."
        fi
    else
        show_orange "ℹ️ No changes."
    fi
}

set_private_key() {
    clear
    menu_header
    pk=$(prompt_input "🔑 Enter PRIVATE_KEY_LOCAL:")
    pk=$(echo "$pk" | sed 's/^0x//' | xargs)
    if [[ -n "$pk" ]]; then
        export PRIVATE_KEY_LOCAL=$pk
        save_env_file
        show_green "✅ Private key saved."
        if confirm_prompt "🔄 Restart Executor now?"; then
            sudo systemctl restart t3rn-executor && show_green "✅ Executor restarted." || show_red "❌ Failed to restart."
        else
            show_orange "ℹ️ You can restart manually later."
        fi
    else
        show_orange "ℹ️ No input. Key unchanged."
    fi
}

edit_env_file() {
    clear
    menu_header
    process_notification "📝 EDIT ENVIRONMENT (.env) FILE"

    if [[ ! -f "$ENV_FILE" ]]; then
        echo
        show_red "❌ .env file does not exist: $ENV_FILE"
        return
    fi

    show_orange "⚠️ WARNING: The .env file contains your PRIVATE KEY."
    show_gray   "   Be careful not to share or leak this file."
    echo
    show_cyan   "ℹ️  After editing, you must restart the Executor to apply changes."
    echo

    if ! confirm_prompt "➡️ Continue editing .env file?"; then
        echo
        show_red "🚫 Edit cancelled."
        return
    fi

    local editor=""
    if command -v nano &>/dev/null; then
        editor="nano"
    elif command -v vim &>/dev/null; then
        editor="vim"
    elif command -v vi &>/dev/null; then
        editor="vi"
    else
        show_red "❌ No text editor found (nano, vim, vi)."
        return
    fi

    $editor "$ENV_FILE"
    echo
    show_orange "🔄 Don't forget to restart the executor using the menu option."
}

configure_disabled_networks() {
    clear
    menu_header
    process_notification "🛑 DISABLE NETWORK MODULES"

    IFS=',' read -ra already_disabled <<<"$NETWORKS_DISABLED"
    declare -A already_disabled_lookup
    for net in "${already_disabled[@]}"; do
        already_disabled_lookup["$net"]=1
    done

    local i=1
    declare -A index_to_key
    for key in "${!executor_ids[@]}"; do
        exec_name="${executor_ids[$key]}"
        [[ -z "$exec_name" || -n "${already_disabled_lookup[$exec_name]}" ]] && continue
        printf "\e[36m[%d]\e[0m \e[1;34m%-18s\e[0m\n" $i "${network_names[$key]}"
        index_to_key[$i]="$key"
        ((i++))
    done

    echo
    show_blue "[0] Back"
    echo

    read -p "$(show_gray '➡️ Enter numbers: ')" input
    [[ -z "$input" ]] && echo && show_blue "ℹ️ No changes made." && return

    IFS=',' read -ra numbers <<<"$input"
    for number in "${numbers[@]}"; do
        [[ "${index_to_key[$number]}" == "BACK" ]] && return
    done

    declare -A selected
    for d in $input; do
        if ! is_number "$d" || [[ -z "${index_to_key[$d]}" ]]; then
            show_red "❌ Invalid input: '$d'."
            return
        fi
        selected[$d]=1
    done

    local final_disabled=("${already_disabled[@]}")
    local newly_disabled=()
    for idx in "${!selected[@]}"; do
        key="${index_to_key[$idx]}"
        exec_name="${executor_ids[$key]}"
        final_disabled+=("$exec_name")
        newly_disabled+=("$exec_name")
    done

    if [[ ${#newly_disabled[@]} -eq 0 ]]; then
        show_blue "ℹ️ No networks selected to disable."
        return
    fi

    final_disabled_unique=($(echo "${final_disabled[@]}" | tr ' ' '\n' | awk '!seen[$0]++'))

    export NETWORKS_DISABLED="$(IFS=','; echo "${final_disabled_unique[*]}")"
    rebuild_network_lists
    rebuild_rpc_endpoints
    save_env_file

    echo
    show_green "✅ Newly disabled networks:"
    for exec_id in "${newly_disabled[@]}"; do
        for key in "${!executor_ids[@]}"; do
            if [[ "${executor_ids[$key]}" == "$exec_id" ]]; then
                show_cyan "   • ${network_names[$key]}"
                break
            fi
        done
    done
    echo

    if confirm_prompt "🔄 To apply changes, restart the Executor now?"; then
        if sudo systemctl restart t3rn-executor; then
            show_green "✅ Executor restarted."
        else
            show_red "❌ Failed to restart executor."
        fi
    else
        show_orange "ℹ️ You can restart manually later from the Main Menu."
    fi
}

enable_networks() {
    clear
    menu_header
    process_notification "✅ ENABLE NETWORK MODULES"

    [[ -z "$NETWORKS_DISABLED" ]] && show_blue "ℹ️ No networks currently disabled." && return

    IFS=',' read -ra disabled <<<"$NETWORKS_DISABLED"
    local i=1
    declare -A index_to_network

    for key in "${!networks[@]}"; do
        exec_name="${executor_ids[$key]}"
        for disabled_net in "${disabled[@]}"; do
            if [[ "$exec_name" == "$disabled_net" ]]; then
                printf "\e[36m[%d]\e[0m \e[1;34m%-18s\e[0m\n" $i "${network_names[$key]}"
                index_to_network[$i]="$disabled_net"
                ((i++))
                break
            fi
        done
    done

    echo
    show_blue "[0] Back"
    echo
    read -p "$(show_gray '➡️ Enter numbers: ')" input
    [[ -z "$input" ]] && echo && show_blue "ℹ️ No changes made." && return

    input=$(echo "$input" | tr -s ' ,')
    IFS=' ' read -ra numbers <<<"${input//,/ }"

    for number in "${numbers[@]}"; do
        [[ "$number" == "0" ]] && return
    done

    declare -A selected
    for d in "${numbers[@]}"; do
        if ! is_number "$d" || [[ -z "${index_to_network[$d]}" ]]; then
            show_red "❌ Invalid input: '$d'."
            return
        fi
        selected[$d]=1
    done

    local remaining=()
    local reenabled=()
    for idx in "${!index_to_network[@]}"; do
        if [[ -n "${selected[$idx]}" ]]; then
            reenabled+=("${index_to_network[$idx]}")
        else
            remaining+=("${index_to_network[$idx]}")
        fi
    done

    if [[ ${#reenabled[@]} -eq 0 ]]; then
        show_blue "ℹ️ No networks selected to enable."
        return
    fi

    if [[ ${#remaining[@]} -eq 0 ]]; then
        export NETWORKS_DISABLED=""
        show_green "✅ All networks enabled."
    else
        export NETWORKS_DISABLED="$(IFS=','; echo "${remaining[*]}")"
    fi

    if [[ -n "$RPC_ENDPOINTS" ]]; then
        if echo "$RPC_ENDPOINTS" | jq empty 2>/dev/null; then
            for key in $(echo "$RPC_ENDPOINTS" | jq -r 'keys[]'); do
                urls=$(echo "$RPC_ENDPOINTS" | jq -r ".$key | @sh" | sed "s/'//g")
                rpcs[$key]="$urls"
            done
        fi
    fi

    rebuild_network_lists
    for key in "${!networks[@]}"; do
        IFS="|" read -r _ chain_id urls executor_id <<<"${networks[$key]}"
        if [[ "$EXECUTOR_ENABLED_NETWORKS" == *"$executor_id"* && -z "${rpcs[$key]}" ]]; then
            rpcs[$key]="$urls"
        fi
    done
    rebuild_rpc_endpoints
    save_env_file

    echo
    show_green "✅ Networks enabled:"
    for exec_id in "${reenabled[@]}"; do
        for key in "${!networks[@]}"; do
            if [[ "${executor_ids[$key]}" == "$exec_id" ]]; then
                show_cyan "   • ${network_names[$key]}"
                break
            fi
        done
    done
    echo

    if confirm_prompt "🔄 To apply changes, restart the Executor now?"; then
        if sudo systemctl restart t3rn-executor; then
            show_green "✅ Executor restarted."
        else
            echo
            show_red "❌ Failed to restart executor."
        fi
    else
        echo
        show_orange "ℹ️ You can restart manually later from the Main Menu."
    fi
}

# WALLET MENU FUNCS

check_balances() {
    clear
    menu_header
    process_notification "💰 CHECK WALLET BALANCE"

    wallet_address=$(get_executor_wallet_address)
    if [[ -z "$wallet_address" ]]; then
        wallet_address=$(prompt_input "🔑 Enter wallet address:")
        wallet_address=$(echo "$wallet_address" | xargs)
    fi

    show_orange "💼 Address: $wallet_address"

    if [[ ! "$wallet_address" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        show_red "❌ Invalid address."
        return
    fi

    show_orange "⏳ Fetching live balances..."
    local url1="https://balancecheck.online/balance/$wallet_address"
    local resp1=$(curl -s --max-time 5 --connect-timeout 3 "$url1")

    if [[ -z "$resp1" || "$resp1" =~ "error" ]]; then
        show_red "❌ Failed to fetch from balancecheck.online"
    else
        echo
        show_cyan "📊 Live Balances:"
        echo "$resp1" | jq -r '
            to_entries[] |
            "   • \(.key): \(.value) " +
            (if .key == "B2N Network" then "BRN"
             elif .key == "Monad Testnet" then "MON"
             elif .key == "BNB Testnet" then "tBNB"
             elif .key == "Gnosis Testnet" then "XDAI"
             elif .key == "Sei Testnet" then "SEI"
             else "ETH" end)'
    fi

    echo
    show_orange "📅 Fetching B2N balance history (last 5 days):"
    local url2="https://b2n.explorer.caldera.xyz/api/v2/addresses/$wallet_address/coin-balance-history-by-day"
    local resp2=$(curl -s --max-time 5 --connect-timeout 3 "$url2")

    if echo "$resp2" | jq -e .items >/dev/null 2>&1; then
        echo
        local history
        history=$(echo "$resp2" | jq -r '.items | reverse[] | "\(.date) \(.value)"' |
            awk '!seen[$1]++' | head -n 5)

        local i=0
        local today_balance yesterday_balance
        while read -r date wei; do
            BRN=$(awk "BEGIN { printf \"%.6f\", $wei / 1e18 }")
            show_cyan "   • $date → $BRN BRN"
            if [[ $i -eq 0 ]]; then
                today_balance="$BRN"
            elif [[ $i -eq 1 ]]; then
                yesterday_balance="$BRN"
            fi
            ((i++))
        done <<<"$history"

        readarray -t daily_data < <(
            echo "$resp2" | jq -r '.items | reverse[] | "\(.date)|\(.value)"' |
                awk -F'|' '!seen[$1]++' | head -n 2
        )

        if [[ ${#daily_data[@]} -eq 2 ]]; then
            today_wei=$(echo "${daily_data[0]}" | cut -d'|' -f2)
            yesterday_wei=$(echo "${daily_data[1]}" | cut -d'|' -f2)

            if [[ -n "$today_wei" && -n "$yesterday_wei" ]]; then
                change_eth=$(awk "BEGIN { printf \"%.6f\", ($today_wei - $yesterday_wei) / 1e18 }")
                echo
                show_orange "📈 Change in last 24h: $change_eth BRN"
            else
                echo
                show_red "❌ Failed to fetch daily history."
            fi
        else
            echo
            show_blue "⚠️ Not enough unique days to calculate change."
        fi
    else
        echo
        show_red "❌ Failed to fetch B2N history."
    fi

    echo
    read -p "$(show_gray '↩️  Press Enter to return to menu...')"
    clear
}

show_balance_change_history() {
    clear
    menu_header
    process_notification "📊 B2N LIVE TRANSACTIONS"

    wallet_address=$(get_executor_wallet_address)

    if [[ -z "$wallet_address" ]]; then
        wallet_address=$(prompt_input "🔑 Enter wallet address:")
        wallet_address=$(echo "$wallet_address" | xargs)
    fi

    if [[ ! "$wallet_address" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        show_red "❌ Invalid address format."
        read -p "$(show_gray '↩️  Press Enter to return...')" && return
    fi

    tput civis
    trap "tput cnorm; stty echo; clear; return" EXIT

    local -a tx_lines=()
    local last_tx_hash=""

    resp=$(curl -s --max-time 5 --connect-timeout 3 "https://b2n.explorer.caldera.xyz/api/v2/addresses/$wallet_address/coin-balance-history")
    tx_lines=($(echo "$resp" | jq -r '.items[:20][] | "\(.block_timestamp)|\(.value)|\(.delta)|\(.transaction_hash)"'))
    last_tx_hash=$(echo "${tx_lines[0]}" | cut -d"|" -f4)

    draw_all_lines() {
        for i in "${!tx_lines[@]}"; do
            IFS="|" read -r timestamp value_raw delta_raw _ <<<"${tx_lines[$i]}"

            ts_epoch=$(date -u -d "$timestamp" +%s 2>/dev/null)
            [[ -z "$ts_epoch" || "$ts_epoch" -le 0 ]] && continue

            now_epoch=$(date +%s)
            diff_sec=$((now_epoch - ts_epoch))
            if ((diff_sec < 60)); then
                age="${diff_sec}s ago"
            else
                age="$((diff_sec / 60))m ago"
            fi

            delta_eth=$(awk "BEGIN { printf \"%.8f\", $delta_raw / 1e18 }")
            value_eth=$(awk "BEGIN { printf \"%.8f\", $value_raw / 1e18 }")

            if [[ "$delta_raw" =~ ^- ]]; then
                arrow="▼"
                colored_delta="\e[31m$arrow $delta_eth\e[0m"  # красный
            else
                arrow="▲"
                colored_delta="\e[32m$arrow $delta_eth\e[0m"  # зелёный
            fi

            tput cup $((6 + i)) 0
            tput el
            printf " %-9s │ %-15s │ %b\n" "$age" "$value_eth" "$colored_delta"
        done
    }

    update_ages_only() {
        for i in "${!tx_lines[@]}"; do
            IFS="|" read -r timestamp _ _ _ <<<"${tx_lines[$i]}"
            ts_epoch=$(date -u -d "$timestamp" +%s 2>/dev/null)
            [[ -z "$ts_epoch" || "$ts_epoch" -le 0 ]] && continue

            now_epoch=$(date +%s)
            diff_sec=$((now_epoch - ts_epoch))
            if ((diff_sec < 60)); then
                age="${diff_sec}s ago"
            else
                age="$((diff_sec / 60))m ago"
            fi

            tput cup $((6 + i)) 0
            printf "%-10s" " "
            tput cup $((6 + i)) 0
            printf " %-10s" "$age"
        done
    }

    clear
    menu_header
    show_blue "📋 B2N Live Transactions - Press Enter to return to menu"
    echo
    show_orange "Wallet: $wallet_address"
    echo
    printf " %-9s │ %-15s │ %-10s\n" "Age" "Balance BRN" "Delta"
    echo "-----------┼-----------------┼-------------"
    draw_all_lines

    while true; do
        resp=$(curl -s "https://b2n.explorer.caldera.xyz/api/v2/addresses/$wallet_address/coin-balance-history")
        tx=$(echo "$resp" | jq -r '.items[0] | "\(.block_timestamp)|\(.value)|\(.delta)|\(.transaction_hash)"')

        [[ "$tx" == "|||" || -z "$tx" ]] && sleep 1 && continue

        IFS="|" read -r timestamp value_raw delta_raw tx_hash <<<"$tx"

        if [[ "$tx_hash" != "$last_tx_hash" ]]; then
            tx_lines=("$tx" "${tx_lines[@]}")
            tx_lines=("${tx_lines[@]:0:20}")
            last_tx_hash="$tx_hash"
            draw_all_lines
        else
            update_ages_only
        fi

        read -t 0.5 -n 1 -s -r key </dev/tty
        [[ $? -eq 0 && "$key" == "" ]] && break
    done

    tput cnorm
    echo
    clear
}

# MAIN MENU FUNCS

main_menu() {
    print_logo
    while true; do
        menu_header
        show_gray "────────────────────────────────────────────────────────────"
        show_cyan "         🔋 MAIN OPERATIONS MENU 🔋"
        show_gray "────────────────────────────────────────────────────────────"
        sleep 0.3

        menu_item  1  "📦" "Install / Uninstall"  "Установка/Удаление"
        menu_item  2  "🛠️" "Configure"            "Настройки и параметры"
        menu_item  3  "ℹ️" "View Logs"            "Просмотр логов"
        menu_item  4  "🔁" "Restart"              "Перезапустить"
        menu_item  5  "💰" "Wallet Info"          "Информация о кошельке"
        menu_item  6  "🆘" "Support"              "Поддержка"
        menu_item  7  "🚪" "Exit"                 "Выход"

        show_gray "────────────────────────────────────────────────────────────"
        echo

        read -p "$(show_gray 'Select option ➤ ') " option
        echo

        case $option in
            1) menu_installation ;;
            2) menu_configuration ;;
            3) view_executor_logs ;;
            4) restart_executor ;;
            5) menu_wallet ;;
            6) show_support_menu;;
            7) exit_script;;
            *) incorrect_option;;
        esac
    done
}

menu_installation() {
    while true; do
        clear
        menu_header
        show_gray "────────────────────────────────────────────────────────────"
        show_cyan "           📦 INSTALLATION & REMOVAL"
        show_gray "────────────────────────────────────────────────────────────"
        echo

        menu_item 1 "⬇️" "Install Latest"      "Установка последней версии"
        menu_item 2 "📂" "Install Specific"    "Установка по версии"
        menu_item 3 "🗑️" "Uninstall Executor"  "Полное удаление"
        menu_item 4 "↩️" "Back"                "Вернуться в главное меню"

        show_gray "────────────────────────────────────────────────────────────"
        echo

        read -p "$(show_gray 'Select option ➤ ') " opt
        echo

        case $opt in
            1) install_executor_latest ;;
            2) install_executor_specific ;;
            3) uninstall_t3rn ;;
            4)
                show_gray "↩️  Returning to main menu..."
                sleep 0.5
                clear
                return
                ;;
            *) incorrect_option ;;
        esac
    done
}

menu_configuration() {
    while true; do
        clear
        menu_header
        show_gray "────────────────────────────────────────────────────────────"
        show_cyan "         🛠️ CONFIGURATION PANEL"
        show_gray "────────────────────────────────────────────────────────────"
        echo

        menu_item 1 "🌐" "Edit RPC Endpoints"     "Редактировать RPC"
        menu_item 2 "📄" "Show Configured RPC"    "Просмотреть текущие RPC"
        menu_item 3 "⛽" "Set Max Gas Price"       "Максимальный gas L3"
        menu_item 4 "🛰️" "Order API Flags"         "Настройка режимов API"
        menu_item 5 "🔐" "Set Private Key"         "Обновить PRIVATE_KEY_LOCAL"
        menu_item 6 "📝" "Edit .env File"          "Редактирование вручную"
        menu_item 7 "🚫" "Disable Networks"        "Отключить цепочки"
        menu_item 8 "✅" "Enable Networks"         "Включить цепочки"
        menu_item 9 "↩️" "Back"                    "Вернуться назад"

        show_gray "────────────────────────────────────────────────────────────"
        echo

        read -p "$(show_gray 'Select option ➤ ') " opt
        echo

        case $opt in
            1) edit_rpc_menu ;;
            2) show_conf_menu ;;
            3) set_gas_price ;;
            4) set_api_flags ;;
            5) set_private_key;;
            6) edit_env_file ;;
            7) configure_disabled_networks ;;
            8) enable_networks ;;
            9)
                show_gray "↩️ Returning to main menu..."
                sleep 0.5
                clear
                return
                ;;
            *) incorrect_option ;;
        esac
    done
}

menu_wallet() {
    while true; do
        clear
        menu_header
        show_gray "────────────────────────────────────────────────────────────"
        show_cyan "         💰 WALLET TOOLS PANEL"
        show_gray "────────────────────────────────────────────────────────────"
        echo

        menu_item 1 "💳" "Check Balances"    "Проверка балансов"
        menu_item 2 "📊" "Balance History"   "История транзакций"
        menu_item 3 "↩️" "Back"              "Вернуться назад"

        show_gray "────────────────────────────────────────────────────────────"
        echo

        read -p "$(show_gray 'Select option ➤ ') " opt
        echo

        case $opt in
            1) check_balances ;;
            2) show_balance_change_history ;;
            3)
                show_gray "↩️ Returning to main menu..."
                sleep 0.5
                clear
                return
                ;;
            *) incorrect_option ;;
        esac
    done
}

main_menu
