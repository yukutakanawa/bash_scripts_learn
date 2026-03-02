#!/bin/bash

# Слежка за процессами
# Принимаем аргумент и назначаем переменной
PROCS=$1

if [ -z "$PROCS" ]; then
        echo "Введите имя процесса"
        echo "Пример: ./watch_proc.sh 'Имя процесса'"

elif [ "$COUNT_PROCS" -eq 0 ]; then
       echo "Процесс "$PROCS" не найден"

else
	while true; do
		# Делаем обновление/очистки вывода каждые 5 сек
		clear

		# Общее кол-во процессов
		COUNT_PROCS=$(ps aux | grep "$PROCS" | grep -v grep | grep -v "$0" | wc -l)

		# Добавляем дату в переменную
		TIME_CHECK=$(date | awk '{print $5}')

		# Проверка изменений количетсва процессов в системе
		if [ "$COUNT_PROCS" -eq 0 ]; then
			echo "Процесс "$PROCS" не найден"

		else

        		echo ["$TIME_CHECK"] Найдено процессов: "$COUNT_PROCS"
        		# Цикл вывода всех процессов (без ограничения по количеству)
			ps aux | grep "$PROCS" | grep -v grep | grep -v "$0" | while read line; do
                		PID_PROCS=$(echo "$line" | awk '{print $2}')
                		CPU_PROCS=$(echo "$line" | awk '{print $3}')
                		MEM_PROCS=$(echo "$line" | awk '{print $4}')

                		echo PID: "$PID_PROCS" CPU: "$CPU_PROCS"% MEM: "$MEM_PROCS"%
		
        		done
		fi
	sleep 5
	done
fi
