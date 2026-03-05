#!/bin/bash

# Получаем аргумент
TASK="$1"

# Функция для каждой задачи
check() {
	echo "$(date): Проверка прошла" >> ~/cron_check.log
}

load() {
	echo "$(date): $(uptime)" >> ~/cron_load.log
}

endday() {
	echo "$(date): День законцен" >> ~/cron_endday.log
}

monday() {
	echo "$(date): Понедельник - день тяжелый" >> ~/cron_monday.log
}


# Выбор задачи по аргументу

case "$TASK" in
	check)
		check
		;;
	load)
		load
		;;
	endday)
		endday
		;;
	monday)
		monday
		;;
	*)
		echo "Использование: $0 {check|load|endday|monday}"
		;;
esac

