#!/bin/bash

tput reset
tput civis

# SYSTEM FUNCS

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

show_cyan() {
    echo -e "\e[36m$1\e[0m"
}

show_purple() {
    echo -e "\e[35m$1\e[0m"
}

show_gray() {
    echo -e "\e[90m$1\e[0m"
}

show_white() {
    echo -e "\e[97m$1\e[0m"
}

show_blink() {
    echo -e "\e[5m$1\e[0m"
}

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

menu_header() {
    local node_status=$(screen -list | grep -q "t3rn" && echo "🟢 RUNNING" || echo "🔴 STOPPED")

    show_gray  "────────────────────────────────────────────────────────────"
    show_cyan  "     ⚙️ LEGENDS GROUP T3RN CONTROL INTERFACE"
    show_gray  "────────────────────────────────────────────────────────────"
    echo
    show_orange "Agent: $(whoami)     🕒 $(date +"%H:%M:%S")     🗓️  $(date +"%Y-%m-%d")"
    show_green  "Node Status: $node_status"
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

save_env_var() {
    local key="$1"
    local value="$2"
    local file="$HOME/executor/executor/bin/my_cofiguration"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    if grep -q "^${key}=" "$file"; then
        sed -i.bak "s|^${key}=.*|${key}=${value}|" "$file"
    else
        echo "${key}=${value}" >> "$file"
    fi
}

view_logs() {
    process_notification "📡 Connecting to executor logs..."
    sleep 1

    # Проверка наличия screen-сессии
    if screen -list | grep -q "t3rn"; then
        show_green "✅ Executor session found. Attaching..."
        sleep 1
        cd "$HOME" && screen -r t3rn
    else
        show_red "❌ No active executor session found."
        show_gray "Tip: Start the node first via 'Operations' menu."
        sleep 2
    fi
}

delete_executor() {
    process_notification "🗑 Starting deletion process..."

    echo
    while true; do
        read -p "$(show_orange 'Delete executor node? (yes/no): ')" option
        echo

        case "$option" in
            yes|y|Y|Yes|YES)
                process_notification "🛑 Checking and stopping screen session..."
                if screen -r t3rn -X quit >/dev/null 2>&1; then
                    sleep 1
                    show_green "✔️  Session closed successfully."
                else
                    sleep 1
                    show_blue "ℹ️  No active session found."
                fi
                show_green "✅ Session check completed."
                echo

                process_notification "💣 Removing executor files and cleaning up system..."
                sleep 0.5

                # Бегущая строка удаления
                show_gray -n "Wiping node: "
                for i in {1..30}; do
                    echo -ne "\e[31m█\e[0m"
                    sleep 0.02
                done
                echo -e " \e[32m[OK]\e[0m"
                sleep 0.3

                # Тихое удаление
                rm -rf "$HOME/executor" >/dev/null 2>&1

                echo
                show_green "✅ Node deleted successfully. Executor uninstalled."
                echo
                break
                ;;

            no|n|N|No|NO)
                process_notification "❎ Deletion cancelled by user."
                echo
                break
                ;;

            *)
                show_red "❌ Invalid input. Please type 'yes' or 'no'."
                sleep 1
                ;;
        esac
    done
}

installation_func() {
    process_notification ">> 📦 Starting system preparation..."
    run_commands "cd $HOME && sudo apt update && sudo apt upgrade -y && sudo apt install -y screen mc nano curl jq"

    process_notification ">> ⬇️ Fetching latest release of T3rn Executor..."
    LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)

    if [[ -z "$LATEST_VERSION" ]]; then
        show_red "❌ Failed to fetch latest version. Aborting."
        return 1
    fi

    EXECUTOR_ARCHIVE="executor-linux-${LATEST_VERSION}.tar.gz"
    EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/${EXECUTOR_ARCHIVE}"

    show_green "LATEST VERSION ➤ $LATEST_VERSION"
    sleep 1

    process_notification ">> 📥 Downloading executor binary..."
    curl --progress-bar -L -o "${EXECUTOR_ARCHIVE}" "$EXECUTOR_URL"
    if [[ $? -eq 0 ]]; then
        show_green "✅ Download complete."
    else
        show_red "❌ Download failed!"
        exit 1
    fi

    process_notification ">> 📦 Extracting archive..."
    echo -ne "\e[90mExtracting: \e[0m"
    for i in {1..30}; do
        echo -ne "\e[32m█\e[0m"
        sleep 0.03
    done
    show_green "[DONE]"

    tar -xzf "${EXECUTOR_ARCHIVE}" >/dev/null 2>&1 && rm -f "${EXECUTOR_ARCHIVE}"
}

installation_completed() {
    echo
    show_gray  "────────────────────────────────────────────────────────────"
    show_green "🎯 Executor node installed successfully!"
    show_gray  "────────────────────────────────────────────────────────────"
    show_orange "⚡ NEXT STEP REQUIRED:"
    show_cyan   "   ➤ Go to [🛠️  Configure] menu and complete full setup"
    show_cyan   "   ➤ This includes keys, endpoints, modes and networks"
    show_gray   "────────────────────────────────────────────────────────────"
    echo
}

# CONFIG MENU FUNCS

init_executor_environment() {
    cd "$HOME/executor/executor/bin" || return

    export ENVIRONMENT="testnet"
    export LOG_LEVEL="debug"
    export LOG_PRETTY="false"
    export EXECUTOR_PROCESS_BIDS_ENABLED="true"
    export EXECUTOR_PROCESS_CLAIMS_ENABLED="true"

    save_env_var "ENVIRONMENT" "$ENVIRONMENT"
    save_env_var "LOG_LEVEL" "$LOG_LEVEL"
    save_env_var "LOG_PRETTY" "$LOG_PRETTY"
    save_env_var "EXECUTOR_PROCESS_BIDS_ENABLED" "$EXECUTOR_PROCESS_BIDS_ENABLED"
    save_env_var "EXECUTOR_PROCESS_CLAIMS_ENABLED" "$EXECUTOR_PROCESS_CLAIMS_ENABLED"

    show_green "✅ Main environment variables for T3RN testnet initialized."
    show_gray  "These are base values required for executor operation."

    echo
    show_orange "⚠️  Additional configuration is REQUIRED below"
    show_orange "⚙️  Please configure ALL remaining parameters to run the executor"
    echo
}

set_pk() {
    process_notification "🔑 Configuring private key..."
    show_orange "Enter your private key (input hidden):"
    read -s -p "➤ " PRIVATE_KEY_LOCAL
    echo

    if [[ -z "$PRIVATE_KEY_LOCAL" ]]; then
        show_red "❌ Private key is empty. Operation cancelled."
        sleep 1
        return
    fi

    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
    save_env_var "PRIVATE_KEY_LOCAL" "$PRIVATE_KEY_LOCAL"

    show_green "✅ Private key saved successfully."
    echo
}

set_gas() {
    process_notification "⛽ Setting up GAS PRICE..."

    show_orange "Enter gas price (press ENTER for default: 1000):"
    read -p "➤ " GAS_PRICE
    GAS_PRICE=${GAS_PRICE:-1000}

    export EXECUTOR_MAX_L3_GAS_PRICE="$GAS_PRICE"
    save_env_var "EXECUTOR_MAX_L3_GAS_PRICE" "$GAS_PRICE"

    echo
    show_green "✅ Gas price saved: $GAS_PRICE"
    echo
}

set_executor_claim_mode() {
    process_notification "⚙️ Select EXECUTION MODE"

    show_orange "Choose processing mode:"
    echo
    menu_item 1 "⚙️" "Execute & Claim" "Обработка и выполнение заказов"
    menu_item 2 "📦" "Claim Only"      "Только сбор заказов без выполнения"
    echo

    read -p "$(show_gray 'Enter option number ➤ ') " option
    echo

    case "$option" in
        1)
            export EXECUTOR_PROCESS_ORDERS_ENABLED=true
            save_env_var "EXECUTOR_PROCESS_ORDERS_ENABLED" "true"
            show_green "✅ Mode set: EXECUTE AND CLAIM ENABLED"
            ;;
        2)
            export EXECUTOR_PROCESS_ORDERS_ENABLED=false
            save_env_var "EXECUTOR_PROCESS_ORDERS_ENABLED" "false"
            show_green "✅ Mode set: CLAIM ONLY ENABLED"
            ;;
        *)
            incorrect_option
            return
            ;;
    esac

    echo
}

build_rpc_json() {
    local custom="$1"
    shift
    local defaults=("$@")

    local endpoints=()
    if [[ -n "$custom" ]]; then
        IFS=',' read -ra endpoints <<< "$custom"
    else
        endpoints=("${defaults[@]}")
    fi

    local jq_array=""
    for url in "${endpoints[@]}"; do
        [[ -n "$url" ]] && jq_array+="\"$url\","
    done
    echo "[${jq_array%,}]"
}

set_rpc_endpoints() {
    process_notification "🌐 Managing RPC endpoints..."

    show_orange "Enter custom RPCs separated by commas, or press ENTER to use defaults"
    echo

    read -p "$(show_gray '🔌 TRN RPC ➤ ') " TRN
    read -p "$(show_gray '🔌 ARB SEPOLIA RPC ➤ ') " ARB
    read -p "$(show_gray '🔌 BLAST SEPOLIA RPC ➤ ') " BLAST
    read -p "$(show_gray '🔌 BASE SEPOLIA RPC ➤ ') " BASE
    read -p "$(show_gray '🔌 UNI SEPOLIA RPC ➤ ') " UNI
    read -p "$(show_gray '🔌 OPT SEPOLIA RPC ➤ ') " OPT
    read -p "$(show_gray '🔌 MON TESTNET RPC ➤ ') " MON
    echo

    build_rpc_array() {
        local input="$1"
        shift
        local defaults=("$@")
        local endpoints=()

        if [[ -n "$input" ]]; then
            IFS=',' read -ra endpoints <<< "$input"
        else
            endpoints=("${defaults[@]}")
        fi

        local arr_json
        arr_json=$(printf '"%s",' "${endpoints[@]}")
        echo "[${arr_json%,}]"
    }

    RPC_ENDPOINTS=$(jq -c -n \
        --argjson l2rn "$(build_rpc_array "$TRN" "https://b2n.rpc.caldera.xyz/http")" \
        --argjson arbt "$(build_rpc_array "$ARB" "https://arbitrum-sepolia.drpc.org" "https://sepolia-rollup.arbitrum.io/rpc")" \
        --argjson bast "$(build_rpc_array "$BASE" "https://base-sepolia-rpc.publicnode.com" "https://base-sepolia.drpc.org")" \
        --argjson blst "$(build_rpc_array "$BLAST" "https://sepolia.blast.io" "https://blast-sepolia.drpc.org")" \
        --argjson opst "$(build_rpc_array "$OPT" "https://sepolia.optimism.io" "https://optimism-sepolia.drpc.org")" \
        --argjson unit "$(build_rpc_array "$UNI" "https://unichain-sepolia.drpc.org" "https://sepolia.unichain.org")" \
        --argjson mont "$(build_rpc_array "$MON" "https://testnet-rpc.monad.xyz")" \
        '{l2rn: $l2rn, arbt: $arbt, bast: $bast, blst: $blst, opst: $opst, unit: $unit, mont: $mont}'
    )

    export RPC_ENDPOINTS="$RPC_ENDPOINTS"
    save_env_var "RPC_ENDPOINTS" "'$RPC_ENDPOINTS'"  # <<< ключ: одинарные кавычки

    show_green "🟢 RPC configuration completed."
    echo
    show_gray "Payload:"
    echo "$RPC_ENDPOINTS"
}

set_api_or_rpc_mode() {
    process_notification "🔁 Select data processing mode (API or RPC)"
    show_orange "Choose the data source mode:"
    echo
    menu_item 1 "🚀" "API Mode" "Fast and Furious (recommended)"
    menu_item 2 "🛰️" "RPC Mode" "Fallback mode if API is down"
    echo

    read -p "$(show_gray 'Enter option number ➤ ') " option
    echo

    case $option in
        1)
            export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
            save_env_var "EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API" "true"
            show_green "✅ Mode set to: API MODE"
            ;;
        2)
            export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
            save_env_var "EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API" "false"
            show_green "✅ Mode set to: RPC MODE"
            ;;
        *)
            incorrect_option
            ;;
    esac

    echo
}

set_enabled_networks() {
    local default_networks=("arbitrum-sepolia" "base-sepolia" "optimism-sepolia" "unichain-sepolia" "blast-sepolia" "monad-testnet" "l2rn")

    process_notification "🌐 NETWORK MODULE INITIALIZATION"

    show_green "✅ Default enabled networks:"
    show_gray  "────────────────────────────────────────────────────────────"
    for i in "${!default_networks[@]}"; do
        printf "\e[36m  [%d]\e[0m \e[1;34m%-18s\e[0m - ACTIVE\n" $((i+1)) "${default_networks[$i]}"
        sleep 0.05
    done
    show_gray  "────────────────────────────────────────────────────────────"
    echo

    show_orange "⚙️  To deactivate specific networks,"
    show_orange "   enter their numbers separated by commas (e.g. 2,5,7)."
    show_orange "   Or press ENTER to keep all modules active."
    echo
    read -p "$(show_gray '➤ Exclude networks: ') " input
    echo

    if [[ -z "$input" ]]; then
        ENABLED_NETWORKS=$(IFS=','; echo "${default_networks[*]}")
        export ENABLED_NETWORKS="$ENABLED_NETWORKS"
        save_env_var "ENABLED_NETWORKS" "$ENABLED_NETWORKS"
        show_green "✅ All network modules remain ACTIVE."
    else
        IFS=',' read -ra exclude_indexes <<< "$input"
        local filtered_networks=()

        for i in "${!default_networks[@]}"; do
            skip=false
            for ex in "${exclude_indexes[@]}"; do
                [[ "$((i+1))" == "$ex" ]] && skip=true && break
            done
            $skip || filtered_networks+=("${default_networks[$i]}")
        done

        ENABLED_NETWORKS=$(IFS=','; echo "${filtered_networks[*]}")
        export ENABLED_NETWORKS="$ENABLED_NETWORKS"
        save_env_var "ENABLED_NETWORKS" "$ENABLED_NETWORKS"

        show_green "✅ Updated network modules:"
        show_gray  "────────────────────────────────────────────────────────────"
        for net in "${filtered_networks[@]}"; do
            show_cyan "  • $net"
            sleep 0.04
        done
        show_gray  "────────────────────────────────────────────────────────────"
    fi

    echo
}

print_config() {
    local file="$HOME/executor/executor/bin/my_cofiguration"

    if [ ! -f "$file" ]; then
        show_red "❌ Configuration file not found!"
        show_gray "Path: $file"
        echo
        return
    fi

    echo
    show_gray  "────────────────────────────────────────────────────────────"
    show_cyan  "        🔧 CURRENT CONFIGURATION"
    show_gray  "────────────────────────────────────────────────────────────"
    echo

    local max_key_length
    max_key_length=$(awk -F= '/^[^#]/ && NF>=2 {print length($1)}' "$file" | sort -nr | head -n1)

    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

        # Удаляем внешние кавычки если они есть (одинарные)
        if [[ "$value" =~ ^\'(.*)\'$ ]]; then
            value="${BASH_REMATCH[1]}"
        fi

        case "$key" in
            ENABLED_NETWORKS)
                show_green "$key :"
                IFS=',' read -ra networks <<< "$value"
                for net in "${networks[@]}"; do
                    echo -ne "  • "
                    show_cyan "$net"
                done
                echo
                ;;

            RPC_ENDPOINTS)
                show_green "$key :"
                if echo "$value" | jq empty > /dev/null 2>&1; then
                    echo "$value" | jq -r 'to_entries[] | "  • \(.key): \(.value | join(", "))"' | while read -r line; do
                        show_cyan "$line"
                    done
                else
                    show_red "❌ Invalid JSON. Cannot display."
                fi
                echo
                ;;

            *)
                printf "\e[32m%-*s\e[0m : \e[36m%s\e[0m\n" "$max_key_length" "$key" "$value"
                ;;
        esac
    done < "$file"

    show_gray  "────────────────────────────────────────────────────────────"
    echo
}

load_env_config() {
    local file="$HOME/executor/executor/bin/my_cofiguration"

    if [ ! -f "$file" ]; then
        show_red "❌ Configuration file not found!"
        return 1
    fi

    while IFS='=' read -r key value; do
        [[ -z "$key" || "$key" =~ ^# ]] && continue

        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        # Если значение заключено в одинарные кавычки — удалим их
        if [[ "$value" =~ ^\'(.*)\'$ ]]; then
            value="${BASH_REMATCH[1]}"
        fi

        export "$key=$value"
    done < "$file"

    show_green "✅ Environment variables loaded."
}

print_logo

while true; do
    show_gray "────────────────────────────────────────────────────────────"
    show_cyan "         🔋 MAIN OPERATIONS MENU 🔋"
    show_gray "────────────────────────────────────────────────────────────"
    sleep 0.3

    menu_item  1  "📦" "Install T3rn"         "Установка протокола"
    menu_item  2  "🛠️" "Configure"            "Настройки и параметры"
    menu_item  3  "🔁" "Operations"           "Основное управление"
    menu_item  4  "ℹ️" "View Logs"            "Просмотр логов"
    menu_item  5  "🗑" "Uninstall"            "Удаление компонентов"
    menu_item  6  "🚪" "Exit"                 "Выход"

    show_gray "────────────────────────────────────────────────────────────"
    echo

    read -p "$(show_gray 'Select option ➤ ') " option
    echo

    case $option in
        1)
            installation_func
            installation_completed
            ;;
        2)
            clear
            menu_header
            init_executor_environment
            while true; do
            show_gray  "────────────────────────────────────────────────────────────"
            show_cyan  "         🛠️  CONFIGURATION MENU"
            show_gray  "────────────────────────────────────────────────────────────"
            echo

            menu_item 1 "🔑" "Private Key"         "Установка приватного ключа"
            menu_item 2 "⛽" "Gas Price"           "Настройка газа"
            menu_item 3 "🎯" "Exec & Claim Mode"   "Режим Execute & Claim"
            menu_item 4 "🌐" "RPC Endpoints"       "Добавление RPC"
            menu_item 5 "🔁" "API / RPC Mode"      "Выбор источника данных"
            menu_item 6 "🧬" "Enabled Networks"    "Выбор активных сетей"
            menu_item 7 "📄" "Show Config"         "Просмотр текущей конфигурации"
            menu_item 8 "🚪" "Exit"                "Вернуться в главное меню"

            show_gray "────────────────────────────────────────────────────────────"
            echo

            read -p "$(show_gray 'Select option ➤ ') " option
            echo
                case $option in
                    1)
                        set_pk
                        ;;
                    2)
                        set_gas
                        ;;
                    3)
                        set_executor_claim_mode
                        ;;
                    4)
                        set_rpc_endpoints
                        ;;
                    5)
                        set_api_or_rpc_mode
                        ;;
                    6)
                        set_enabled_networks
                        ;;
                    7)
                        print_config
                        ;;
                    8)
                        show_gray "↩️  Returning to main menu..."
                        sleep 0.5
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
            ;;
        3)
            clear
            menu_header
            while true; do

            show_gray "────────────────────────────────────────────────────────────"
            show_cyan "        🔁 OPERATIONAL CONTROL PANEL"
            show_gray "────────────────────────────────────────────────────────────"
            echo
            show_orange "Choose an action:"

            menu_item 1 "🔄" "Start / Restart" "Запустить или перезапустить Executor"
            menu_item 2 "🛑" "Stop"             "Остановить Executor"
            menu_item 3 "↩️" "Back"             "Вернуться в главное меню"
            echo

            read -p "$(show_gray 'Enter option number ➤ ') " option
            echo

                case $option in
                    1)
                        process_notification "🔌 Stopping existing screen session..."
                        if screen -r t3rn -X quit; then
                            sleep 1
                            show_green "✔️  Session closed successfully."
                        else
                            sleep 1
                            show_blue "ℹ️  No active session found."
                        fi
                        echo

                        process_notification "🚀 Launching new Executor session..."
                        load_env_config
                        run_commands "screen -dmS t3rn && screen -S t3rn -X stuff \"cd \$HOME/executor/executor/bin/ && ./executor$(echo -ne '\r')\""
                        show_green "✅ Executor started in detached screen session [t3rn]"
                        echo
                        break
                        ;;

                    2)
                        process_notification "🛑 Stopping Executor screen session..."
                        if screen -r t3rn -X quit; then
                            sleep 1
                            show_green "✔️  Session stopped successfully."
                        else
                            sleep 1
                            show_blue "ℹ️  No active session found."
                        fi
                        echo
                        break
                        ;;

                    3)
                        show_gray "↩️  Returning to main menu..."
                        sleep 0.5
                        break
                        ;;

                    *)
                        show_red "❌ Invalid option. Please try again."
                        sleep 1
                        ;;
                esac
            done
            ;;
        4)
            view_logs
            ;;
        5)
            delete_executor
            ;;
        6)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
