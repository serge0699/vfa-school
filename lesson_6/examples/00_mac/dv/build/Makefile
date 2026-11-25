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
TOP = tb_mac

# Режим запуска.
MODE = -gui

# Выбор теста MAC.
TEST_NAME = mac_test_base

# Переопределение define для запуска
# определенного тестового сценария.
COMP_OPTS = +define+MAC_TEST=$(TEST_NAME)

# Seed случайной генерации.
SEED = $(shell head -4 /dev/urandom | od -N 4 -D -A n | sed 's/ //g')

# База покрытия и отчет о покрытии.
COV_DATABASE = $(SIM)/coverage.ucdb
COV_REPORT   = $(SIM)/coverage_report.txt

# Опции покрытия. Кодовое покрытие для MAC не собирается,
# база наполняется только covergroup'ами.
COV_OPTS = -onfinish stop -do "coverage save \
               -testname $(TEST_NAME)_$(SEED) -onexit $(COV_DATABASE); \
                   coverage report -details -file $(COV_REPORT); quit;"

# Добавление режима запуска.
SIM_OPTS += $(MODE)

# Добавление зерна симуляции.
SIM_OPTS += -sv_seed $(SEED)

# Добавление опций сбора покрытия.
SIM_OPTS += $(COV_OPTS)

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
