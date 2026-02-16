#!/bin/bash

# Лог файл вывода
LOG_FILE="sys_info$(date '+%Y%m%d').log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Системный отчет
# Делаем переменную для текущей даты
DATE=$(date)

# Переменная для загрузки системы
DOWNLOAD_SYS=$()


echo "Системный отчёт: $DATE"
echo "-------------------------"

# Вывод информации о системе
# Загрузка системы
echo "Загрузка системы: $(uptime | tail -1 | sed 's/.*average://' | xargs)"
# Память
ALL_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $2}' | sed "s/[a-zA-Z]//g")
FREE_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $4}' | sed "s/[a-zA-Z]//g") 
USED_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $3}' | sed "s/[a-zA-Z]//g")


# Делаем проверку на заполнение памяти
COMPLITED=$((USED_MEMORY * 100 / ALL_MEMORY))

if [ $COMPLITED -gt 74 ]; then
	echo "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("$COMPLITED"% занято) Высокая загруженость"
	exit 0
elif [ $COMPLITED -gt 49 ]; then
	echo "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("$COMPLITED"% занято) Средняя загруженость"
elif [ $COMPLITED -gt 24 ]; then
	echo "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("$COMPLITED"% занято) Умеренная загруженость"
else
	echo "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("$COMPLITED"% занято) Слабая загруженость"
fi

# Дисковое пространство
DISK_USED=$(df -h | head -2 | tail -1 | awk '{print $3}')
DISK_FREE=$(df -h | head -2 | tail -1 | awk '{print $4}')

echo "Диск /: $DISK_USED использавано, $DISK_FREE свободно"

# Топ-3 процесса по CPU
echo "Топ-3 процесса по CPU:"
ps aux --sort=-%cpu | head -4 | while read line; do
	pid=$(echo $line | awk '{print $2}')
	proc=$(echo $line | awk '{print $11}')
	cpu=$(echo $line | awk '{print $3}')
	mem=$(echo $line | awk '{print $4}')

	echo "PID: $pid | Процесс: $proc | CPU: $cpu% | MEM: $mem%"
	echo "-----------"
done



