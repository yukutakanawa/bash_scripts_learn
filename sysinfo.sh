#!/bin/bash

# Лог файл вывода
#LOG_FILE="sys_info$(date '+%Y%m%d').log"
#exec > >(tee -a "$LOG_FILE") 2>&1

# Аргумент для вывода информации
SYSINFO=$1

# Цвета для вывода
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No color


# Делаем переменную для текущей даты
DATE=$(date)

echo "Системный отчёт: $DATE"
echo "-------------------------"

# Вывод информации о системе

# Делаем через case
case "$SYSINFO" in 
	cpu)
		# Топ-3 процесса по CPU
		echo "Топ-3 процесса по CPU:"
		ps aux --sort=-%cpu | head -4 | tail -3 | while read line; do
		        pid=$(echo $line | awk '{print $2}')
		        proc=$(echo $line | awk '{print $11}')
		        cpu=$(echo $line | awk '{print $3}')
		        mem=$(echo $line | awk '{print $4}')

		        echo "PID: $pid | Процесс: $proc | CPU: $cpu% | MEM: $mem%"
        		echo "-----------"
		done
		;;
	mem)

# Память
                        ALL_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $2}' | sed "s/[a-zA-Z]//g")
                        FREE_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $4}' | sed "s/[a-zA-Z]//g")
                        USED_MEMORY=$(free -h | head -2 | tail -1 | awk '{print $3}' | sed "s/[a-zA-Z]//g")


                # Делаем проверку на заполнение памяти
                       COMPLITED=$((USED_MEMORY * 100 / ALL_MEMORY))

                        if [ $COMPLITED -gt 74 ]; then
                                echo -e  "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${RED}" "$COMPLITED"% занято "${NC}") Высокая загруженость"

                        elif [ $COMPLITED -gt 49 ]; then
                                echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${YELLOW}" "$COMPLITED"% занято "${NC}") Средняя загруженость"
                        elif [ $COMPLITED -gt 24 ]; then
                                echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${GREEN}" "$COMPLITED"% занято "${NC}") Умеренная загруженость"
                        else
                                echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${NC}" "$COMPLITED"% занято) Слабая загруженость"
                        fi
			;;
		disk)
			# Дисковое пространство
			DISK_USED=$(df -h | head -2 | tail -1 | awk '{print $3}')
			DISK_FREE=$(df -h | head -2 | tail -1 | awk '{print $4}')

			echo "Диск /: $DISK_USED использовано, $DISK_FREE свободно"
			;;
		*)
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
				 echo -e  "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${RED}" "$COMPLITED"% занято "${NC}") Высокая загруженость"

			elif [ $COMPLITED -gt 49 ]; then
			        echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${YELLOW}" "$COMPLITED"% занято "${NC}") Средняя загруженость"
elif [ $COMPLITED -gt 24 ]; then
        echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${GREEN}" "$COMPLITED"% занято "${NC}") Умеренная загруженость"
else
			        echo -e "Память: всего "$ALL_MEMORY"G, свободно "$FREE_MEMORY"G ("${NC}" "$COMPLITED"% занято) Слабая загруженость"
			fi
			
			# Дисковое пространство
DISK_USED=$(df -h | head -2 | tail -1 | awk '{print $3}')
DISK_FREE=$(df -h | head -2 | tail -1 | awk '{print $4}')

echo "Диск /: $DISK_USED использовано, $DISK_FREE свободно"

# Топ-3 процесса по CPU
echo "Топ-3 процесса по CPU:"
ps aux --sort=-%cpu | head -4 | tail -3 | while read line; do
        pid=$(echo $line | awk '{print $2}')
        proc=$(echo $line | awk '{print $11}')
        cpu=$(echo $line | awk '{print $3}')
        mem=$(echo $line | awk '{print $4}')

        echo "PID: $pid | Процесс: $proc | CPU: $cpu% | MEM: $mem%"
        echo "-----------"
done

;;
esac
