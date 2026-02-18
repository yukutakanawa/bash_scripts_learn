#!/bin/bash

# Скрипт для git
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
	echo -n "Введите сообщение коммита: "
	read COMMIT
fi

echo "Добавляем все изменения"
git add .

echo "Делаем коммит и берем его из первого аргумента"
git commit -m "$COMMIT"

echo "Показываем нужную нам ветку"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ -z "$CURRENT_BRANCH" ]; then
	echo "Ошибка не удалось определить текущую ветку"
	exit 1
fi

echo "Текущая ветка: $CURRENT_BRANCH"

echo "Пушим изменения"
git push origin "$CURRENT_BRANCH"

echo "Все прошло успешно"
