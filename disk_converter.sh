#!/bin/bash
#Преобразование дискового пространства в МБ ГБ

#Назначаем переменную
disk_space_kb=5242880
disk_space_mb="$((disk_space_kb / 1024))"
disk_space_gb="$((disk_space_mb / 1024))"

echo "Disk space in KB: $disk_space_kb"
echo "Disk space in MB: $disk_space_mb"
echo "Disk space in GB: $disk_space_gb"
