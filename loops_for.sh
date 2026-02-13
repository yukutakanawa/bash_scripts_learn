#!/bin/bash

#Цикл for


#1. Выводим список чисел
for i in {10..20}; do
	echo "Число: $i"
done

#2. Обработка файлов каталоге
for file in *.sh; do
	if [ -f "$file" ]; then
	echo "Файл: $file"
	ls -l "$file" | awk '{print "Размер: "$5" байт"}'
	fi
done

#3. Вычислить сумму
num=0
for (( i=1; i<=100; i++ )); do
	((num += i))
done
echo "Результат: $num"

