#!/bin/bash

#Создаем счетчик журналов сервера

today_logs=1250
new_entries=375
errors_found=20

#Первоначальное количество записей в логе
echo "Количество: $today_logs"

#Количество записей в журнале после добавления новых записей
let today_logs=$today_logs+$new_entries
echo "Количетво после добавления: $today_logs"

#Количество записей в логе после удаления ошибок
delete_logs_users=$((today_logs-errors_found))
echo "Количество после удаления: $delete_logs_users"

#Процент ошибок по данным исходных журналов
percent_logs_errors=$(( (errors_found * 100) / today_logs))
echo "Процент ошибок от общего количества: $percent_logs_errors%"
