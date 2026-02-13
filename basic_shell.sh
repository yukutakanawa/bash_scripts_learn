#!/bin/bash
#Основные команды
echo "Hello world!"
echo "Date: $(date)"
echo "User: $USER"

#Переменные
NAME="Nick"
AGE="34"

echo "My name is $NAME, me age $AGE"

#Константы (пока еще не понял зачем)
readonly PI=3.14
echo $PI


#Ввод от пользователя
echo "Вводим ваше имя"
read username
echo "Hello $username!"


#Аргументы командной строки пока тоже не пойму для чего нужно и как применять
#Запуск происходит так ./vm_monitor.sh arg1 arg2 arg3 где arg это аргументы
#Надо прочитать про язык bash

echo "Name scripts: $0"
echo "First arg: $1"
echo "All args: $@"
echo "Count args: $#"


#Условные операторы частично с ними знаком из другиз языков программирования
#Есть несколько видов записи условных выражений

echo "Введите число:"
read number

#Немного другой синтаксис
if ((number > 18)); then
	echo "Ваш возраст подходит"

else 
	echo "Не подходите"

fi #Не понятно что это


#Циклы также есть 2 вида циклов for и while
#Нужно будет привыкнуть к синтаксису обоих и лучше выучить цикл while

#Цикл for
for i in {1..5}; do
	echo "Num: $i"
done

#Цикл while
count=1
while [ $count -le 3 ]; do
	echo "Counts: $count"
	((count++))
done

#Функции
#Определяем функцию
hello() {
	echo "Hello, $1"
	return 0
}

#Вызываем функцию
hello "Nick"

#Использование возвращаемого значения
if hello "Nick"; then
	echo "Function complited"
fi




