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
TOP = tb_axis_decimator

# Режим запуска.
MODE = -gui

# Добавление include файлов из пакета окружения.
INCLUDE   = $(wildcard ../env/*.sv ../env/load/*.sv ../env/load/*.svh)
COMP_OPTS = +incdir+../env +incdir+../env/load

# Ширины шин DUT.
DATA_WIDTH = 32
DEC_WIDTH  = 8

# Выбор теста прореживателя.
TEST_NAME = axis_decimator_test_base

# Seed случайной генерации.
SEED = $(shell head -4 /dev/urandom | od -N 4 -D -A n | sed 's/ //g')

# Типы покрытия, база покрытия, отчет о покрытии.
COV_TYPES    = sbcef
COV_DATABASE = $(SIM)/coverage.ucdb
COV_REPORT   = $(SIM)/coverage_report.txt

# Опции покрытия.
COV_CODE = -coverage -voptargs="+cover=$(COV_TYPES)+$(TOP)/DUT+0"
COV_OPTS = -onfinish stop $(COV_CODE) -do "coverage save \
               -testname $(TEST_NAME)_$(SEED) -onexit $(COV_DATABASE); \
                   coverage report -details -file $(COV_REPORT); quit;"

ifeq ($(PORTS_ONLY),1)
    COV_OPTS += -toggleportsonly
endif

# Добавление библиотек common и AXI-Stream в компиляцию.
COMP_OPTS += -L common_lib -L axis_lib

# Добавление теста в компиляцию.
COMP_OPTS += +define+AXIS_DECIMATOR_TEST=$(TEST_NAME)

# Добавление библиотек и параметров DUT в оптимизацию.
SIM_OPTS += -voptargs="-L common_lib -L axis_lib" \
        -gDATA_WIDTH=$(DATA_WIDTH) -gDEC_WIDTH=$(DEC_WIDTH)

# Добавление режима запуска и логирования.
SIM_OPTS += $(MODE) +common_db_debug +axis_decim_scb_logging

# Добавление зерна симуляции.
SIM_OPTS += -sv_seed $(SEED)

# Добавление опций сбора покрытия.
SIM_OPTS += $(COV_OPTS)

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
