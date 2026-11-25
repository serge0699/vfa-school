# ***************************************************
# * Copyright © 2026 Sergey Chusov.
# * Version 1.0.0.
# * Licensed under CC BY-NC-ND 4.0
# * (Attribution-NonCommercial-NoDerivatives).
# * https://creativecommons.org/licenses/by-nc-nd/4.0
# * SPDX-License-Identifier: CC-BY-NC-ND-4.0
# ***************************************************

# Ширины шин DUT: bash run.sh [DATA_WIDTH] [DEC_WIDTH].
data_width=${1:-32}
dec_width=${2:-8}

# Директория артефактов тестирования.
out_dir=$(pwd)/out

# Директория компиляции.
comp_dir=${out_dir}/compile

# Очищаем директорию артефактов тестирования.
make clean OUT="${out_dir}" || exit 1

# Общий файл лога.
mkdir -p "${out_dir}"
log=${out_dir}/run.log

# Список тестовых сценариев.
tests=(axis_decimator_test_base axis_decimator_test_reset axis_decimator_test_multiple_config)

# Статус регрессии.
status=0

# Последовательно запускаем все тесты.
for test_name in "${tests[@]}"; do

    # Директория симуляции.
    sim_dir=${out_dir}/sim/${test_name}

    # Запуск.
    command="make TEST_NAME=${test_name} MODE=-c \
        DATA_WIDTH=${data_width} DEC_WIDTH=${dec_width} \
        OUT=\"${out_dir}\" COMP=\"${comp_dir}\" SIM=\"${sim_dir}\""

    # Сохранение в общий файл лога.
    echo "$(date '+%Y-%m-%d %H:%M:%S') ${command}" >> "${log}"

    output=$(eval "${command}" 2>&1)
    printf '%s\n' "${output}" | tee -a "${log}"

    # Проверяем лог симуляции на наличие ошибок.
    if [ ! -f "${sim_dir}/sim.log" ] ||
        grep -q -E '\*\* (Error|Fatal)' "${sim_dir}/sim.log"; then
        echo " FAILED" | tee -a "${log}"
        status=1
    else
        echo " PASSED" | tee -a "${log}"
    fi

done

exit ${status}
