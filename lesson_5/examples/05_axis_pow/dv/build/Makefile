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
TOP = tb_axis_pow

# Добавление include файлов из пакета окружения.
INCLUDE  = $(addprefix ../env/,$(shell ls ../env))

# Выбор теста усилителя.
TEST_NAME = axis_pow_test_base

# Добавление библиотек common и AXI-Stream в компиляцию.
COMP_OPTS = -L common_lib -L axis_lib \
	+define+AXIS_POW_TEST=$(TEST_NAME)

# Добавление библиотек common и AXI-Stream в оптимизацию.
SIM_OPTS  = -voptargs="-L common_lib -L axis_lib"

# Запуск в GUI режиме
SIM_OPTS += -gui +common_db_debug +axis_pow_scb_logging

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
