#!/bin/bash

#Ввод данных
read -p "Введите ваш email: " email
read -p "Скрываем ваш пароль: " password_user 
read -p "Вводим строку для реверса: " str_input

#Проверка адреса электронной почты
echo "----- Проверка email -----"
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z.-]+\.[a-zA-Z]{2,}$ ]]; then
	echo "Email is correct $email"
else 
	echo "Email is not correct $email"
fi


#Маскировка пароля
echo ""
echo "----- Маскировка пароля -----"
star="*"

lock_password=${password_user//?/$star}

echo $password_user
echo "$lock_password"

#Изменение расширения файлов
echo ""
echo "----- Изменяем расширение файлов подставляя в переменную путь -----"
file="../txtfilesrenames"

for rename in "$file"/*.log; do
	if [ -f "$rename" ]; then
		filename=$(echo $rename | sed 's/^.*\///')
		newfilename="${filename%.log}.txt"
		mv "$rename" "$newfilename"
		echo "Изменили $filename на $newfilename"
	fi
done

#Реверс строки (переворачивание)
echo ""
echo "----- Реверс строки (переворачивание) -----"

reversed="$(echo $str_input | rev)"
echo $reversed
