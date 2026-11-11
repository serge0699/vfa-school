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
TOP = tb_resource_db

# Зависимости от общих подключаемых файлов.
INCLUDE = $(wildcard ../../../../../common/dv/*.sv)

# Добавление директории для include.
COMP_OPTS = +incdir+../../../../../common/dv

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
