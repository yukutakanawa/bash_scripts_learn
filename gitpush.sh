#!/bin/bash

# Скрипт для git

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
	echo -n "Введите сообщение коммита: "
	read COMMIT
fi

echo "Добавляем все изменения"
git add .

echo "Делаем коммит и берем его из первого аргумента"
git commit -m "$COMMIT"

echo "Показываем нужную нам ветку"
CURRENT_BRANCH=$(git branch)
git "$CURRENT_BRANCH"

