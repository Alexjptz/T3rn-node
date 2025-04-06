#!/bin/bash

tput reset
tput civis

# Put your logo here if nessesary

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

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo ""
        exit 0
}

incorrect_option() {
    echo
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo
    show_red "Invalid option. Please choose from the available options."
    echo
}

process_notification() {
    local message="$1"
    show_orange "$message"
    echo
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo
        show_green "Успешно (Success)"
        echo
    else
        sleep 1
        echo
        show_red "Ошибка (Fail)"
        echo
    fi
}

build_rpc_list() {
    local user="$1"
    shift
    local result=()
    [ -n "$user" ] && result+=("\"$user\"")
    for rpc in "$@"; do
        result+=("\"$rpc\"")
    done
    local joined=$(IFS=, ; echo "${result[*]}")
    echo "[$joined]"
}

print_logo() {
    show_orange " .___________. ____   .______      .__   __. " && sleep 0.1
    show_orange " |           ||___ \  |   _  \     |  \ |  | " && sleep 0.1
    show_orange "  ---|  |----   __) | |  |_)  |    |   \|  | " && sleep 0.1
    show_orange "     |  |      |__ <  |      /     |  .    | " && sleep 0.1
    show_orange "     |  |      ___) | |  |\  \----.|  |\   | " && sleep 0.1
    show_orange "     |__|     |____/  | _|  ._____||__| \__| " && sleep 0.1
    echo
    sleep 1
}

while true; do
    print_logo
    show_green "------ MAIN MENU ------"
    echo "1. Установить T3rn (Installation)"
    echo "2. Настроить (Tunning menu)"
    echo "3. Управление (Operational menu)"
    echo "4. Логи (Logs)"
    echo "5. Удаление (Delete)"
    echo "6. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            # INSTALLATION
            process_notification "Начинаем подготовку (Starting preparation)..."
            run_commands "cd $HOME && sudo apt update && sudo apt upgrade -y && apt install -y screen mc nano"

            # Binary installation
            process_notification "Установка T3rn (Installation)..."
            echo
            # LATEST
            LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
            # Latest pre-release version
            # LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases | jq -r 'map(select(.prerelease == true)) | .[0].tag_name')
            EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"

            process_notification "Скачиваем последнюю версию (Downloading latest version)"
            show_green "LATEST VERSION = $LATEST_VERSION" && sleep 2
            run_commands "curl -L -o executor-linux-${LATEST_VERSION}.tar.gz $EXECUTOR_URL"

            process_notification "Распаковка (Extracting...)"
            run_commands "tar -xzvf executor-linux-${LATEST_VERSION}.tar.gz && rm -rf executor-linux-${LATEST_VERSION}.tar.gz"
            echo
            show_green "--- НОДА УСТАНОВЛЕНА. NODE INSTALLED ---"
            echo
            ;;
        2)
            process_notification "Настраиваем (Setting up)..."
            echo
            cd $HOME/executor/executor/bin
            export ENVIRONMENT=testnet
            export LOG_LEVEL=debug
            export LOG_PRETTY=false
            export EXECUTOR_PROCESS_BIDS_ENABLED=true
            export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
            export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,unichain-sepolia,blast-sepolia,l2rn"
            export RPC_ENDPOINTS='{
                "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
                "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
                "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
                "blst": ["https://sepolia.blast.io", "https://blast-sepolia.drpc.org"],
                "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
                "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
            }'

            # ENTER PK
            process_notification "PRIVAT KEY"
            show_orange "Введите (Enter)"
            read -p "Privat key: " PRIVATE_KEY_LOCAL
            echo
            export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
            echo

            # SETTING GAS PRICE
            process_notification "GAS SETTINGS"
            show_orange "Введите (Enter)"
            read -p "Gas price (press enter for default 1000): " GAS_PRICE
            GAS_PRICE=${GAS_PRICE:-1000}
            export EXECUTOR_MAX_L3_GAS_PRICE=$GAS_PRICE
            show_green "🟠 GAS PRICE = $GAS_PRICE"
            echo

            # MODE CHOICE
            process_notification "MODE"
            show_orange "Выберите режим (Choose mode):"
                echo "1. Обработка и сборка (Execute and claim)"
                echo "2. Только сборка (ONLY Claim)"
                read -p "Введите номер опции (Enter option number): " option
                case $option in
                    1)
                        # EXECUTE AND CLAIM
                        export EXECUTOR_PROCESS_ORDERS_ENABLED=true
                        echo
                        show_green "🟠 EXECUTE AND CLAIM MODE"
                        echo
                        ;;
                    2)
                        # ONLY CLAIM
                        export EXECUTOR_PROCESS_ORDERS_ENABLED=false
                        echo
                        show_green "🟠 CLAIM MODE"
                        echo
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac

            # RPC OR API
            process_notification "API or RPC MODE"
            show_orange "Выберите режим (Choose mode):"
                echo "1. API (Fast and Furious)"
                echo "2. RPC (In case if API falldown)"
                read -p "Введите номер опции (Enter option number): " option
                case $option in
                    1)
                        # API
                        export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
                        # export EXECUTOR_PROCESS_ORDERS_API_ENABLED=true
                        echo
                        show_green "🟠 API MODE"
                        echo
                        ;;
                    2)
                        # RPC
                        export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
                        # export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
                        # export EXECUTOR_ENABLE_BATCH_BIDDING=true

                        show_orange "Выберите режим RPC (Choose RPC mode): "
                        echo "1. Standart"
                        echo "2. Custom"
                        read -p "Введите номер опции (Enter option number): " option
                        case $option in
                            1)
                                # STANDART
                                show_green "🟠 STANDART RPC MODE"
                                ;;
                            2)
                                # CUSTOM
                                show_blue "FORMAT RPC: https://RPC_ENDPOINT"
                                read -p "Введите (Enter) ARB SEPOLIA RPC: " ARB
                                read -p "Введите (Enter) BLAST SEPOLIA RPC: " BLAST
                                read -p "Введите (Enter) BASE SEPOLIA RPC: " BASE
                                read -p "Введите (Enter) UNI SEPOLIA RPC: " UNI
                                read -p "Введите (Enter) OPT SEPOLIA RPC: " OPT
                                export RPC_ENDPOINTS="{
                                    \"l2rn\": [\"https://b2n.rpc.caldera.xyz/http\"],
                                    \"arbt\": $(build_rpc_list "$ARB" "https://arbitrum-sepolia.drpc.org" "https://sepolia-rollup.arbitrum.io/rpc"),
                                    \"bast\": $(build_rpc_list "$BASE" "https://base-sepolia-rpc.publicnode.com" "https://base-sepolia.drpc.org"),
                                    \"blst\": $(build_rpc_list "$BLAST" "https://sepolia.blast.io" "https://blast-sepolia.drpc.org"),
                                    \"opst\": $(build_rpc_list "$OPT" "https://sepolia.optimism.io" "https://optimism-sepolia.drpc.org"),
                                    \"unit\": $(build_rpc_list "$UNI" "https://unichain-sepolia.drpc.org" "https://sepolia.unichain.org")
                                }"
                                echo "$RPC_ENDPOINTS"
                                show_green "🟠 CUSTOM RPC MODE"
                                ;;
                        esac
                        echo
                        show_green "🟠 RPC MODE"
                        echo
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            echo
            show_green "--- НАСТРОЙКА ЗАВЕРШЕНА. TUNNING COMPLETED ---"
            echo
            ;;
        3)
            # START/RESTART/STOP
            show_green "------ OPERATIONAL MENU ------"
            echo
            while true; do
                show_orange "Выберите (Choose):"
                echo "1. Запусить/перезапустить (Start/Restart)"
                echo "2. Остановить (Stop)"
                echo "3. Выход (Exit)"
                echo

                read -p "Введите номер опции (Enter option number): " option

                case $option in
                    1)
                        process_notification "Закрываем screen сессию (Closing screen session)..."
                        if screen -r t3rn -X quit; then
                            sleep 1
                            show_green "Успешно (Success)"
                            echo
                        else
                            sleep 1
                            show_blue "Не найдена (Didn't find)"
                            echo
                        fi

                        process_notification "Создаем и запускаем  (Creating and starting)..."
                        run_commands "screen -dmS t3rn && screen -S t3rn -X stuff \"cd \$HOME/executor/executor/bin/ && ./executor$(echo -ne '\r')\""
                        # screen -dmS t3rn && screen -S t3rn -X stuff "cd $HOME/executor/executor/bin/ && ./executor\n"
                        break
                        ;;
                    2)
                        process_notification "Закрываем screen сессию (Closing screen session)..."
                        if screen -r t3rn -X quit; then
                            sleep 1
                            show_green "Успешно (Success)"
                            echo
                        else
                            sleep 1
                            show_blue "Не найдена (Didn't find)"
                            echo
                        fi
                        break
                        ;;
                    3)
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
            echo
            ;;
        4)
            # LOGS
            process_notification "Подключаемся (Connecting)..." && sleep 2
            cd $HOME && screen -r t3rn
            ;;
        5)
            # DELETE
            process_notification "Удаление (Deleting)..."
            echo
            while true; do
                read -p "Удалить ноду? Delete node? (yes/no): " option

                case "$option" in
                    yes|y|Y|Yes|YES)
                        process_notification "Закрываем screen сессию (Closing screen session)..."
                        if screen -r t3rn -X quit; then
                            sleep 1
                            show_green "Успешно (Success)"
                            echo ""
                        else
                            sleep 1
                            show_blue "Не найдена (Didn't find)"
                            echo ""
                        fi

                        process_notification "Чистим (Cleaning)..."
                        run_commands "rm -rvf $HOME/executor"

                        show_green "--- НОДА УДАЛЕНА. NODE DELETED. ---"
                        break
                        ;;
                    no|n|N|No|NO)
                        process_notification "Отмена (Cancel)"
                        echo ""
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
            ;;
        6)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
