# ***************************************************
# * Copyright © 2026 Sergey Chusov.
# * Version 1.0.0.
# * Licensed under CC BY-NC-ND 4.0
# * (Attribution-NonCommercial-NoDerivatives).
# * https://creativecommons.org/licenses/by-nc-nd/4.0
# * SPDX-License-Identifier: CC-BY-NC-ND-4.0
# ***************************************************

# Директория примера.
EXAMPLE = $(realpath  ./../..)

# Топ-модуль верификационного окружения.
TOP = tb_simple

# Зависимости от общих подключаемых файлов.
INCLUDE = $(wildcard ../../../../../common/dv/*.sv)

# Добавление библиотеки common в компиляцию.
COMP_OPTS = -L common_lib

# Добавление библиотеки common в оптимизацию.
SIM_OPTS  = -voptargs="-L common_lib"

# Запуск в GUI режиме.
SIM_OPTS += -gui

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
