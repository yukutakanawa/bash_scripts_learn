#!/bin/bash

# Установка необходимых команд и обновлений через скрипт

# Обновление и Установка пакетов
echo "Устанавливаем пакеты и обновляем их"
sudo apt update && sudo apt upgrade
sleep 1 # Делаем задержку
echo "===================================================="

# Устанавливаем необходимые пакеты для работы
echo ""
echo "Устанавливаем необходимые утилиты"
sudo apt install -y git curl wget htop tree net-tools
sleep 1
echo "===================================================="

# Настраиваем git добавляем данные от git
echo "Настраиваем git добавляем user и почту"

if [ -n "$1" ] && [ -n "$2" ]; then 
	USER_NAME="$1"
	USER_EMAIL="$2"
elif [ -z "$1" ] && [ -z "$2" ]; then
	USER_NAME="yukutakanawa"
	USER_EMAIL="yukutakanawa@gmail.com"
else 
	echo "Ошибка: нужно передать ИМЯ и EMAIL вместе, либо не передавать ничего"
	exit 1
fi

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"
sleep 1
echo "===================================================="

# Создаем папку для хранения скриптов
echo ""
echo "Создаем папку для хранения скриптов..."
sleep 1
echo "Делаем проверку существует ли она"
SCRIPT_DIR="work_scripts"

if [ ! -d "$SCRIPT_DIR" ]; then
	echo "Создаем папку..."
	sleep 1
	mkdir -p ~/"$SCRIPT_DIR"
	echo "Папка успешно создана"
else 
	echo "Папка уже создана"
	echo "Путь: ~/$SCRIPT_DIR"
fi


