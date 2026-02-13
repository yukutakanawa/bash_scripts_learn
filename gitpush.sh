#!/bin/bash

# Скрипт для git

# Принимаем первый аргумент
COMMIT=$1

# Делаем проверку что аргумент передали

if [ -z "$COMMIT" ]; then
	echo "Вы не ввели сообщение, введите сообщение commit"
	exit 1
fi


echo "Добавляем все изменения"
git add .

echo "Делаем коммит и берем его из второго аргумента"
git commit -m "$COMMIT"

echo "Пушим наш результат в репозиторий"
git push origin main


