#!/bin/bash

#Break и Continue базовые упражнения

#1. Обработка файлов с помощью `continue`
while IFS= read -r line; do
	if [[ "$line" =~ ^# ]]; then
	        continue	
	fi
	echo "$line"
done < sorted.sh

#2. Игра в угадывание чисел `break`
chance=5
num=$((RANDOM % 10 + 1))

echo "Угадайте число от 1 до 10. У вас $shance попыток."

while [ $chance -gt 0 ]; do
	read -p "Ваше число: " user_num

	if [ "$user_num" -gt 10 ] || [ "$user_num" -lt 1 ] ; then
		echo "Вы вышли за диапозон от 1 до 10"
		continue
	fi
	
	
	if [ "$user_num" -eq "$num" ]; then
			echo "Вы угадали $user_num - Наше число $num"
			break
	elif [ "$user_num" -gt "$num" ]; then
		echo "Заданное число меньше"
	else 
		echo "Заданное число больше"
	fi
	
	chance=$((chance - 1))
	
	if [ $chance -eq 0 ]; then
		echo "У вас кончились попытки. Мы загадали число $num"
	else
		echo "У вас осталось попыток $chance"

	fi
done

#3. Проверка на простое число `break`

read -p "Введите ваше число: " number
	
if [ $number -lt 2 ]; then
	echo "Число $number не простое"
	exit
fi

is_prime=1
for ((i=2;i*i<=number;i++)); do
	if [ $((number % i)) -eq 0 ]; then
		is_prime=0
		break
	fi
done

if [ $is_prime -eq 1 ]; then
	echo "$number простое число"
else
	echo "$number составное число"
fi

#4. Обработка каталогов с помощью `continue`
echo "Файлы в текущем каталоге:"


for file in *; do
	if [ -d "$file" ];then
		#echo "Директория: $file"
		continue
	fi

	if [ -f "$file" ]; then
	       echo "Файл: $file"
	fi	       
done




