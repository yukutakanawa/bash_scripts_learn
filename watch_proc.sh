#!/bin/bash

# Слежка за процессами
PROCS=$1

if [ ! -z "$PROCS" ]; then
	COUNT_PROCS=$(ps aux | grep "$PROCS" | grep -v grep | grep -v "$0" | wc -l)
	PID_PROCS=$(ps aux | grep "$PROCS" | grep -v grep | awk '{print $2}' | head -1)
	CPU_PROCS=$(ps aux | grep "$PROCS" | grep -v grep | awk '{print $3}' | head -1)
	MEM_PROCS=$(ps aux | grep "$PROCS" | grep -v grep | awk '{print $4}' | head -1)	

	echo Найдено процессов: "$COUNT_PROCS" 
	echo PID: "$PID_PROCS" CPU: "$CPU_PROCS"% MEM: "$MEM_PROCS"%

else
	echo "Введите имя процесса"
	echo "Пример: ./watch_proc.sh 'Имя процесса'"

fi
