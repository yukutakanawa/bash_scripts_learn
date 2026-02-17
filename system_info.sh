#!/bin/bash

#Системная информация
HOSTNAME=$(hostname)
NAME_OS=$(cat /etc/os-release | grep "PRETTY_NAME=" | cut -d'"' -f2)
KERNEL_VERSION=$(uname -r)
UPTIME=$(uptime | awk -F',' '{print $1}')
CURRENT_USER=$(whoami)
CURRENT_DIR=$(pwd)
MODEL_PROCESS=$(lscpu | grep "Имя модели:" | cut -d: -f2 | xargs)
KERNEL_COUNT_CP=$(lscpu | grep "CPU(s):" | cut -d: -f2 | xargs | sed "s/ .*//")
GENERAL_MEMORY=$(free -h | grep "Память" | cut -d: -f2 | xargs | sed "s/ .*//")
FREE_MEMORY=$(free -h | grep "Память" | cut -d: -f2 | xargs | sed "s/ //" | cut -d" " -f2)
GENERAL_DISK_SIZE=$(df -h / | awk '{print $2}' | sed "s/"Размер"//" | xargs)
ACCESSIBLE_DISK_SIZE=$(df -h / | awk '{print $4}' | sed "s/"Дост"//" | xargs)


#Отображение информации
echo "Системная информация"
echo "--------------------"
echo "Hostname: $HOSTNAME"
echo "Название ос и её версия: $NAME_OS"
echo "Версия ядра: $KERNEL_VERSION"
echo "Время работы: $UPTIME"
echo "Текущий пользователь: $CURRENT_USER"
echo "Текущая директория: $CURRENT_DIR"
echo "Модель процессора: $MODEL_PROCESS"
echo "Количество ядер ЦП: $KERNEL_COUNT_CP"
echo "Общая память: $GENERAL_MEMORY"
echo "Свободная память: $FREE_MEMORY"
echo "Общий объем дискового пространства (корневой каталог): $GENERAL_DISK_SIZE"
echo "Доступное дисковое пространство (корневой каталог): $ACCESSIBLE_DISK_SIZE"



#PID Скрипта
echo "Script PID: $$"

#Выводим количество аргументов передаваемых скрипты
echo "Число аргументов: $#"

#Проверяем статус завершения последней команды
if [ $? -eq 0 ]; then
	echo "Все прошло успешно"
else
	echo "Во время выполнения скрипта возникла ошибка"
fi

#Функция резервного копирования с проверкой ошибок
backup() {
#Определяем источник и каталог для резервного копирования
source_dir="../BASH_learn/"
backup_dir="../backup/"

#Проверяем существует ли наш исходный каталог
if [ ! -d "$source_dir" ]; then
	echo "Ошибка: Исходный каталог '$source_dir' не существует"
	return 1
fi

#Создаем резервную папку если она не существует
mkdir -p "$backup_dir"
if [ $? -ne 0 ]; then
	echo "Ошибка: Не удалось создать каталог резервных копий '$backup_dir'"
	return 1
fi

#Копируем файлы в каталог резервного копирования
cp -r "$source_dir"/* "$backup_dir"
if [ $? -ne 0 ]; then
	echo "Ошибка: Не удалось скопировать файлы в резервную директорию"
	return 1
fi

echo "Файлы успешно скопированы в каталог резервного копирования '$backup_dir'"
return 0
}

backup

