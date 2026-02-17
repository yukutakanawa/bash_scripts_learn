#!/bin/bash

# Цикл until базовые задания

#1. Дождаться завершения процесса
#Запускаем процесс который будем ждать
echo "Запускаем sleep 60 в фоне"
sleep 60 &

sleep 0.1

echo "Ждем завершения sleep 60 с помощью until..."

#until - пока условие ложно
until ! ps aux | grep -q "[s]leep 60"; do
      echo "Процесс еще не работает..."
      sleep 1
done

echo "Готово! Процесс sleep завершился."

#2. Повторная попытка выполнения команд
until ping -c 1 google.com &> /dev/null; do
	echo "Нет подключения к интернету, повторите попытку через 10 секунд..."
	sleep 10
	echo "Проснулись, пробуем снова..."
done

echo "Подключение к интернету восстановленно!"



#3. Игра в угадывание
number_random=$((RANDOM % 10 + 1))

until false; do
	read -p "Вводим число: " number_user
	
	
	if [ $number_user -gt 10 ]; then
		echo "Диапозон от 1 до 10"
	else
		if [ "$number_user" -eq "$number_random" ]; then
			echo "Вы угадали число"
			break
		fi
	fi
done

