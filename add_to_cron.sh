#!/bin/bash

# Находим есть ли задача в cron
TASK_CRON1=$(crontab -l | grep "disk_check.sh")
TASK_CRON2=$(crontab -l | grep "rotate_logs.sh")

# Проверяем 1 задачу disk
if [ "$TASK_CRON1" ]; then
	echo "Задача disk check уже есть"
else
	(crontab -l; echo "0 * * * * /home/takanawayuku/BASH_learn/disk_check.sh") | crontab -
	echo "Задача добавлена"
fi


# Проверяем 2 задачу rotate
if [ "$TASK_CRON2" ]; then
        echo "Задача rotate logs уже есть"
else
        (crontab -l; echo "0 2 * * * /home/takanawayuku/BASH_learn/rotate_logs.sh") | crontab -
        echo "Задача добавлена"
fi

