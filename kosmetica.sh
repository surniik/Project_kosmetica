#!/bin/bash
. ./functions.sh

users="/home/ksenia/Desktop/proect_costemica/users.txt"
favorits="/home/ksenia/Desktop/proect_costemica/favorits.txt"

echo "Добро подаловать в приложение Консультация у косметолога"

if [ ! -f "$users" ]; then
    touch /home/ksenia/Desktop/proect_costemica/users.txt
fi

if [ ! -f "$favorits" ]; then
    touch /home/ksenia/Desktop/proect_costemica/favorits.txt
fi

echo "Если у вас уже есть учетная запись, введите 1"
echo "Если у вас нет учетной записи, введите 2"
read choice
if [ "$choice" == "1" ]; then
    auth
elif [ "$choice" == "2" ];then
    registration
else
    echo "Ошибка: Неверный выбор." && exit 0
fi

if grep -q "$username;" $favorits; then
    favor=$(grep "^$username;" $favorits | awk -F';' '{print $3}')
    echo "-----------------------------"
    echo "---Ваши избранные продукты---"
    echo "$favor"
    echo "-----------------------------"
fi

menu_choice

exit 0