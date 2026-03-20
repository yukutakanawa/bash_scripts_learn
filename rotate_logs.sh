#!/bin/bash

# Получаем размер файла и переводим его в кб
SIZE_FILE_BYTE=$(stat -c %s ~/server_check.log)
SIZE_FILE_KB=$(( (SIZE_FILE_BYTE + 512) / 1024))

# Получаем 1мб в байтах
LIMIT_KB=1024

# Сравниваем в кб
if [ $SIZE_FILE_KB -ge $LIMIT_KB ]; then
	# Имя для архивного лога
	ARCHIVE_NAME=~/server_check_$(date +%d-%m-%Y_%H-%M-%S).log

	# Переименовываем текущий лог
	mv ~/server_check.log "$ARCHIVE_NAME"
	
	# Сжимаем
	gzip "$ARCHIVE_NAME"
	
	# Создаем новый пустой лог
	touch ~/server_check.log
	
	# Делаем запись в новый лог что ротация прошла
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] Лог заархивирован" >> ~/server_check.log
else
	echo "Все в порядке" >> ~/server_check.log
fi



# Делаем запись в лог файл
echo "Размер лога: $SIZE_FILE_KBкб" >> ~/server_check.log
