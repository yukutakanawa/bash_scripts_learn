#!/bin/bash

# Принимаем аргумент к скрипту
TASK="$1"

# Переменные для дат, на нынешнем уровне в bash я могу сделать пока так лучший из возможных вариантов
DMY=$(date +%d-%m-%Y) # День Месяц Год
HMS=$(date +%H:%M:%S) # Часы Минуты Секунды

# Переменные для проверки диска, также решил вынести отдельно, опять же для моего нынешнего уровня я нашел только такое решение
DISK_FREE=$(df -h | head -2 | tail -3 | awk '{print $4}' | sed "s/^Дост//" | xargs)
DISK_USE=$(df -h | head -2 | tail -3 | awk '{print $5}' | sed "s/^[^0-9]*//" | xargs)

# Функция для каждой задачи
# Функция проверки свободного места на диске
disk_check() {
	echo "["$DMY" "$HMS"] Проверка диска - Свободно: "$DISK_FREE", Занято: "$DISK_USE"" >> ~/server_check.log
}

# Функция проверки работы sshd
sshd_check() {
	if ps aux | grep sshd | grep -v grep > /dev/null 2>&1; then
		echo "["$DMY" "$HMS"] sshd работает" >> ~/server_check.log
	else
		echo "sshd не работает" >> ~/server_check.log
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
		echo "Директория успешна создана"
		sleep
		tar -czf ~/backup_$DMY.tar.gz ~/backup_files
		echo "Backup создан ["$DMY" "$HMS"]" >> ~/server_check.log
	else
		echo "Директория существует, делаем backup"
		tar -czf ~/backup_$DMY.tar.gz ~/backup_files
		echo "Backup создан ["$DMY" "$HMS"]" >> ~/server_check.log
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
