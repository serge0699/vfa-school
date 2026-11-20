# ***************************************************
# * Copyright © 2026 Sergey Chusov.
# * Version 1.0.0.
# * Licensed under CC BY-NC-ND 4.0
# * (Attribution-NonCommercial-NoDerivatives).
# * https://creativecommons.org/licenses/by-nc-nd/4.0
# * SPDX-License-Identifier: CC-BY-NC-ND-4.0
# ***************************************************

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
tests=(axis_pow_test_base axis_pow_test_multiple_reset)

# Статус регрессии.
status=0

# Последовательно запускаем все тесты.
for test_name in "${tests[@]}"; do

    # Директория симуляции.
    sim_dir=${out_dir}/sim/${test_name}

    # Запуск.
    command="make TEST_NAME=${test_name} MODE=-c \
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
