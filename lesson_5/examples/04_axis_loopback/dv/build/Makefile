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

# Добавление include файлов из пакета окружения.
INCLUDE = $(addprefix ../env/,$(shell ls ../env))

# Топ-модуль верификационного окружения.
TOP = tb_axis_loopback

# Добавление библиотек common и AXI-Stream в компиляцию.
COMP_OPTS = -L common_lib -L axis_lib

# Добавление include-файлов пакета окружения.
COMP_OPTS += +incdir+../env

# Добавление библиотек common и AXI-Stream в оптимизацию.
SIM_OPTS  = -voptargs="-L common_lib -L axis_lib"

# Запуск в GUI режиме + включение логирования monitor AXI-Stream.
SIM_OPTS += -gui +axis_monitor_logging +common_db_debug

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
