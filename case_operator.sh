#!/bin/bash

#Упражнения по оператору case основы

#1. Скрипт настройки сети
echo "=== Команды настройки сети ==="

echo "Постмотреть текущий ip адрес ---> showip"
echo "Пинг поисковика гугл ---> pinggoogle"
echo "Поиск DNS ---> dnslookup"
echo "Для выхода из меню ---> exit"

read -p "Введите команду: " action

case "$action" in
	showip)
		interface=$(ip route | grep default | awk '{print $5}' | head -1)
		echo "Текущий IP: $(ip a show "$interface" | grep inet | awk '{print $2}')"
		;;

	pinggoogle)
		echo "Пингуем google:"
		ping -c 4 google.com
		;;
		
	dnslookup)
		read -p "Введите доменное имя: " domain

		echo "DNS: $(dig "$domain")"
		;;
	exit)
		echo "Завершение работы скрипта настройки сети"
		exit 0
		;;
	
	*)
		echo "Неправильный ввод '$action'"
		echo "Пожалуйста введите одну из команд 'showip', 'pinggoogle', 'dnslookup', 'exit'"
		;;
esac

#2. Моделирование доступа на основе ролей пользователя
echo "=== Ниже представлены уровни пользователя выберите свой ==="

echo "admin"
echo "user"
echo "developer"
echo "guest"
echo "exit"

read -p "Введите ваш уровень: " access

case "$access" in 
	admin | ADMIN)
		echo "$access - Полный доступ к системе предоставлен"
		;;
	user | USER)
		echo "$access - Ограниченный доступ к приложению"
		;;
	developer | DEVELOPER)
		echo "$access - Доступ к репозиторию кода и тестовой среде доступен"
		;;
	guest | GUEST)
		echo "$access - Доступ только для чтения к общедоуступным ресурсам"
		;;
	exit | EXIT)
		echo "$access - Выход из меню"
		exit 0
		;;
	*)
		echo "$access - Недоступная роль. Доступ запрещен!"
		echo "Список ролей 'admin', 'user', 'developner', 'guest' и команда 'exit'"
esac


