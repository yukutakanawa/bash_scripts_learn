#!/bin/bash

# Скрипт для git

# Принимаем первый аргумент
COMMIT=$1

# Проверка что мы в git репозитории
if ! git rev-parse --git-dir > /dev/null 2>&1; then
	echo "Ошибка это не git репозиторий"
	exit 1
fi


# Проверка есть ли изменения
if [ -z "$(git status --porcelain)" ]; then
	echo "Нет изменений для коммита"
	exit 0
fi


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


