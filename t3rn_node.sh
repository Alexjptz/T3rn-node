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

incorrect_option () {
    echo ""
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo ""
    show_red "Invalid option. Please choose from the available options."
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_red "Ошибка (Fail)"
        echo ""
    fi
}

show_orange " .___________. ____   .______      .__   __. " && sleep 0.2
show_orange " |           ||___ \  |   _  \     |  \ |  | " && sleep 0.2
show_orange "  ---|  |----   __) | |  |_)  |    |   \|  | " && sleep 0.2
show_orange "     |  |      |__ <  |      /     |  .    | " && sleep 0.2
show_orange "     |  |      ___) | |  |\  \----.|  |\   | " && sleep 0.2
show_orange "     |__|     |____/  | _|  ._____||__| \__| " && sleep 0.2
echo ""
sleep 1

while true; do
    echo "1. Установить T3rn (Installation)"
    echo "2. Запуск/перезапуск/остановка (Start/restart/stop)"
    echo "3. Логи (Logs)"
    echo "4. Удаление (Delete)"
    echo "5. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            # INSTALLATION
            process_notification "Начинаем подготовку (Starting preparation)..."
            run_commands "cd $HOME && sudo apt update && sudo apt upgrade -y && apt install -y screen mc nano"

            process_notification "Устанавливаем шрифт (Installing font)..."
            run_commands "sudo apt install figlet"

            FONT_PATH="/usr/share/figlet/starwars.flf"
            if [ ! -f "$FONT_PATH" ]; then
                sudo wget -P /usr/share/figlet/ http://www.figlet.org/fonts/starwars.flf
            fi

            # Binary installation
            process_notification "Установка T3rn (Installation)..."
            echo ""
            LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
            EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"

            process_notification "Скачиваем последнюю версию (Downloading latest version)"
            show_green "LATEST VERSION = $LATEST_VERSION" && sleep 2
            run_commands "curl -L -o executor-linux-${LATEST_VERSION}.tar.gz $EXECUTOR_URL"

            process_notification "Распаковка (Extracting...)"
            run_commands "tar -xzvf executor-linux-${LATEST_VERSION}.tar.gz && rm -rf executor-linux-${LATEST_VERSION}.tar.gz"

            process_notification "Настраиваем (Setting up)..."
            cd $HOME/executor/
            export NODE_ENV="testnet"
            export LOG_LEVEL="debug"
            export LOG_PRETTY="false"
            export EXECUTOR_PROCESS_ORDERS="true"
            export EXECUTOR_PROCESS_CLAIMS="true"

            show_orange "Введите (Enter)"
            read -p "Privat key: " PRIVATE_KEY_LOCAL
            echo

            export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
            export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn"

            echo ""
            show_green "--- НОДА УСТАНОВЛЕНА. NODE INSTALLED ---"
            echo ""
            ;;
        2)
            # START/RESTART/STOP
            echo
            while true; do
                show_orange "Выберите (Choose):"
                echo "1. Запусить/перезапустить (Start/Restart)"
                echo "2. Остановить (Stop)"
                echo "3. Выход (Exit)"
                echo ""

                read -p "Введите номер опции (Enter option number): " option

                case $option in
                    1)
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
                            echo ""
                        else
                            sleep 1
                            show_blue "Не найдена (Didn't find)"
                            echo ""
                        fi
                        break
                        ;;
                    3)
                        incorrect_option
                        ;;
                esac
            done
            echo
            ;;
        3)
            # LOGS
            process_notification "Подключаемся (Connecting)..." && sleep 2
            cd $HOME && screen -r t3rn
            ;;
        4)
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
        5)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
