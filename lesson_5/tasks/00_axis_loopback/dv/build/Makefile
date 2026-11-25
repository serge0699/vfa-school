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
TOP = tb_axis_loopback

# Режим запуска.
MODE = -gui

# Добавление include файлов из пакета окружения.
INCLUDE   = $(addprefix ../env/,$(shell ls ../env))
COMP_OPTS = +incdir+../env

# Добавление библиотеки common в компиляцию.
COMP_OPTS += -L common_lib

# Компиляция AXI-Stream с AXIS_MAX_TDATA_WIDTH = 128
# и AXIS_MAX_TID_WIDTH = 4.
COMP_OPTS += +define+AXIS_MAX_TDATA_WIDTH=128 \
        +define+AXIS_MAX_TID_WIDTH=4

# Добавление библиотеки common в оптимизацию.
SIM_OPTS += -voptargs="-L common_lib"

# Добавление режима запуска и логирования.
SIM_OPTS += $(MODE) +axis_monitor_logging +common_db_debug
include ../../../../../common/make/Makefile
