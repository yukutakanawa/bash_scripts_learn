#!/bin/bash

# Останавливаем скрипт если любая команда завершилась ошибкой
set -e
# Останавливаем скрипт если используем не объявленую переменную
set -u
# Указываем путь к файлу лога
LOG_FILE="/var/log/server_check.log"
# Вычисляем 10мб в байтах и сохранаяем в переменную
MAX_LOG_SIZE=$((10 * 1024 * 1024))

# Проверка что аргумент передан
if [ $# -eq 0 ]; then
	echo "ERROR: No task specified"
	echo "Usage: $0 {disk_approve|sshd_approve|backup_approve}"
	exit 1
fi

# Принимаем аргумент к скрипту
TASK="$1"

# Проверка что аргумент передан
if [ -z "${TASK:-}" ]; then
	echo "ERROR: No task specified"
	echo "Usage: $0 {disk_approve|sshd_approve|backup_approve}"
	exit 1
fi

# Переменные для дат, на нынешнем уровне в bash я могу сделать пока так лучший из возможных вариантов
DMY=$(date +%d-%m-%Y) # День Месяц Год
HMS=$(date +%H:%M:%S) # Часы Минуты Секунды

# Переменные для проверки диска, проверяем корневой раздел
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_USE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Функция для каждой задачи
# Функция проверки свободного места на диске
disk_check() {
	echo "["$DMY" "$HMS"] Проверка диска - Свободно: "$DISK_FREE", Занято: "$DISK_USE"%" >> "$LOG_FILE"
}

# Функция проверки работы sshd
sshd_check() {
	if ps aux | grep sshd | grep -v grep > /dev/null 2>&1; then
		echo "["$DMY" "$HMS"] sshd работает" >> "$LOG_FILE"
	else
		echo "sshd не работает" >> "$LOG_FILE"
	fi
}


# Функция для создания backup
backup_check() {
	if [ ! -d ~/backup_files ]; then
		echo "Директория не существует"
		echo "Создаем директории.."
		sleep 1
		mkdir ~/backup_files
		sleep 1
		echo "Директория успешна создана, делаем backup"
		sleep 1
		tar -czf ~/backup_$DMY.tar.gz ~/backup_files
		echo "Backup создан ["$DMY" "$HMS"]" >> "$LOG_FILE"
	else
		echo "Директория существует, делаем backup"
		tar -czf ~/backup_$DMY.tar.gz ~/backup_files
		echo "Backup создан ["$DMY" "$HMS"]" >> "$LOG_FILE"
	fi	
}



case "$TASK" in
	disk_approve)
		disk_check
		;;
	sshd_approve)
		sshd_check
		;;
	backup_approve)
		backup_check
		;;
	
	*)
		echo "Использование: $0 {disk}"
		;;
esac
