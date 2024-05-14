function registration {
    echo "Введите ваш логин: "
    read username

    if grep -q "^$username:" "$users"; then
		echo "Ошибка: Данный логин уже занят." && exit 0
	else
		echo "Введите ваш пароль"
		read -s password
		echo "$username:$password" >> $users
		echo "Спасибо за регистрацию!"
		touch /home/ksenia/Desktop/proect_costemica/users/${username}_products.txt
		cp /home/ksenia/Desktop/proect_costemica/products.txt /home/ksenia/Desktop/proect_costemica/users/${username}_products.txt
    fi
}

function auth {
    echo "Введите ваш логин"
    read username
    echo "Введите ваш пароль"
    read password

    if grep -q "$username:$password" "$users"; then
		echo "Добро пожаловать $username"
	else
		echo "Ошибка: Неправильный логин или пароль." && exit 0
    fi
}

function menu_choice {
    clear

    echo "Выберите дествие"
    echo "1)Перейти к консультации"
    echo "2)Сохранить список избранных продуктов"
    echo "3)Отредактировать список избранных продуктов"
    echo "4)Выйти из программы"
    read menu_action

    menu
}

function menu {
    clear

    if [ "$menu_action" == "1" ]; then
        echo "Какие тип кожи вас интерисует?"
        echo "Для выбора введите номер по списку"
        echo "1)Жирная"
        echo "2)Сухая"
        echo "3)Комбинированная"
        echo "4)Вернуться в меню"
        read choice1

        if [[ $choice1 == "4" ]]; then
            menu_choice
        fi

        echo "Какие проблемы у вас встречатся?"
        echo "1)Комедоны"
        echo "2)Пигментация"
        echo "3)Активные высыпания"
        read choice2

        recommend=$(grep "^$choice1$choice2" /home/ksenia/Desktop/proect_costemica/users/${username}_products.txt)
        product1=${choice1}${choice2}'1'
        product2=${choice1}${choice2}'2'
        product3=${choice1}${choice2}'3'
        
        problems

    elif [ "$menu_action" == "2" ]; then
        if grep -q "$username;" $favorits; then
            favor=$(grep "^$username;" $favorits | awk -F';' '{print $3}')
            echo "$favor" > /home/ksenia/Desktop/proect_costemica/users/${username}_favorits_products.txt
            echo "Ваш список избранных продуктов сохранен в ${username}_favorits_products.txt"
            sleep 4
            menu_choice
        else
            echo " Ваш список избранных продуктов пуст"
            menu_choice
        fi

    elif [ "$menu_action" == "3" ]; then
        favor=$(grep "^$username;" $favorits | awk -F';' '{print $2,$3}')
        echo "$favor"
        read -p "Введите код продукта, который хотите удалить из списка, для отмены нажмите <b>: " del_favor
        if [[ $del_favor == "b" ]]; then
            menu_choice
        else
            sed -i "/^$username;$del_favor/d" $favorits
            echo "продукт удалён из вашего списка избранных"
            sleep 4
            menu_choice
        fi
        
    elif [ "$menu_action" == "4" ]; then
        echo "Завершение работы..."
        exit 0
    fi
}

function problems {
    clear

    echo "Продукты, предложенные под ваши запросы:"
        echo "$recommend"
        read -p "Выберите код продукта, с которым хотите провести взаимодествие, чтобы вернуться обратно, нажмите <b>: " product

        if [[ "$product" == "$product1" || "$product" == "$product2" || "$product" == "$product3" ]]; then
            echo "Выберите действие с продуктом"
            echo "1)Добавить в избранное"
            echo "2)Больше не предлагать"
            echo "3)Вернуться в меню"
            read action

            if [ "$action" == "1" ]; then
                favorit=$(grep "^$product" /home/ksenia/Desktop/proect_costemica/users/${username}_products.txt)
                if grep -q "^$username;$product;" $favorits; then
                    echo "Данный продукт уже в вашем избранном"
                    sleep 4
                    problems
                else
                    echo "$username;$favorit" >> $favorits
                    echo "Продукт добавлен в избранное"
                    sleep 4
                    problems
                fi

            elif [ "$action" == "2" ]; then
                sed -i "/^$product/d" /home/ksenia/Desktop/proect_costemica/users/${username}_products.txt
                echo "Этот товар больше не будет вам показываться"
                problems

            elif [ "$action" == "3" ]; then
                menu_choice
            fi
        elif [[ $product == "b" ]]; then
            menu_choice
        else
            echo "Нет такого варианта"
            problems
        fi
}