# ***************************************************
# * Copyright © 2026 Sergey Chusov.
# * Version 1.0.0.
# * Licensed under CC BY-NC-ND 4.0
# * (Attribution-NonCommercial-NoDerivatives).
# * https://creativecommons.org/licenses/by-nc-nd/4.0
# * SPDX-License-Identifier: CC-BY-NC-ND-4.0
# ***************************************************

# Очищаем директорию артефактов тестирования.
make clean OUT=$(pwd)/../out -q

# Считываем из тестлиста имя и количество итераций.
cat testlist.list | while read test_item || [[ -n $line ]];
do

    # Проверка на комментарий
    if  [[ $test_item == \#* ]]; then
        continue
    fi

    # Разбиваем строку.
    test_arr=(${test_item//:/ })

    # "Вычленяем" элементы.
    test_name=${test_arr[0]}
    test_iter=${test_arr[1]}
    test_data_width=${test_arr[2]}
    test_dec_width=$(echo "${test_arr[3]}" | tr -d '\r')

    # Определяем директорию теста.
    test_out=$(pwd)/../out/${test_name}
    echo " ------------------------------------------------------------------";
    echo -e "| Test      : $test_name \
           \n| Iterations: $test_iter \
           \n| Widths    : $test_data_width / $test_dec_width";
    echo " ------------------------------------------------------------------";

    # Запускаем необходимое количество итераций.
    for sim in $( seq 1 $test_iter ); do

        # Опредеяем root seed.
        # Метод взят из статьи Doug Smith, Random Stability in SystemVerilog.
        seed=$(head -4 /dev/urandom | od -N 4 -D -A n | sed 's/ //g')

        # Запускаем основную систему сборки с необходимыми аргументами.
        command="make DATA_WIDTH=$test_data_width DEC_WIDTH=$test_dec_width \
            COMP_OPTS=\"+define+AXIS_DECIMATOR_TEST=$test_name \
                -L common_lib -L axis_lib\" SIM_OPTS=\"-c -sv_seed $seed \
                    -voptargs='-L common_lib -L axis_lib' \
                    -gDATA_WIDTH=$test_data_width -gDEC_WIDTH=$test_dec_width\" \
                        OUT=$test_out SIM=$test_out/sim/seed-${seed};"

        echo -e $command | bash

        # Проверяем, что запуск make был завершен успешно.
        if [ $? -ne 0 ]; then
            exit $?
        fi

        # Делаем вывод об успешности или нет тестового сценария.
        sim_log=$test_out/sim/seed-${seed}/sim.log
        if grep -F -q "** Error" "$sim_log"  || \
           grep -F -q "** Fatal" "$sim_log"; then
            echo    "FAILED!";
            echo -n "FAILED:" >> $(pwd)/../out/regression.log
        else
            echo    "PASSED!";
            echo -n "PASSED:" >> $(pwd)/../out/regression.log
        fi

        echo -e $command >> $(pwd)/../out/regression.log

    done

done

# Вывод финального сообщения
echo -e "\nSee results in out/regression.log"
