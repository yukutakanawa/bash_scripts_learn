#!/bin/bash

#Базовая работа с циклом while

#Вывод ввода до условного exit

#1. while true; do
#	read -p "Введите текст: " user_input
#	
#	if [ $user_input = "exit" ]; then	
#		echo "Завершаем процесс..."
#		sleep 1
#		break
#	fi
#	
#	echo "Ваш ввод: $user_input"
#done

#sleep 1
#echo "Программа завершена"

#2. Имитация броска игральной кости

#while true; do
#	dice=$((RANDOM % 6 + 1))
	
#	if [ $dice -eq 6 ]; then
#		echo "Вы выиграли выкинув число 6"
#		echo "Завершаем игру..."
#		sleep 1
#		break
#	else
#		echo "Вы выкинули $dice"
#	fi
#done

#3. Обработка файла журналов

log_file="log_info.log"

for i in {1..10}; do
	if [ $((RANDOM % 3)) -eq 0 ]; then
		
		echo "Error: Проблема в строке $i" >> $log_file
	else
		echo "OK: Операция $i прошла успешна" >> $log_file
	fi
done

while IFS= read -r line; do
	if echo "$line" | grep -q "Error"; then
        echo "Найдена ошибка: $line"
    fi
done < $log_file
