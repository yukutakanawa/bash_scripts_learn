#!/bin/bash

# Дата в переменной
DATE_YMD=$(date +%F)
DATE_HMS=$(date +%T)

# Получаем процент использования диска
DISK_USED=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

# Получаем свободное место в процентах вычитаем 100 от DISK_USED
DISK_FREE=$((100 - DISK_USED))


# Создаем условие проверки
if [ "$DISK_USED" -ge 85 ]; then
	echo "["$DATE_YMD" "$DATE_HMS"] КРИТИЧЕСКИЙ! Диск / заполнен на "$DISK_USED"% (свободно "$DISK_FREE"%)" >> ~/disk_warning.log
elif [ "$DISK_USED" -ge 70 ]; then
	echo "["$DATE_YMD" "$DATE_HMS"] ВНИМАНИЕ! Диск / заполнен на "$DISK_USED"% (свободно "$DISK_FREE"%)" >> ~/disk_warning.log
else 
	echo "["$DATE_YMD" "$DATE_HMS"] Диск /: заполнен на "$DISK_USED"% - все отлично" >> ~/disk_warning.log
fi
