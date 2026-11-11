# Директория примера.
EXAMPLE = $(realpath  ./../..)

# Топ-модуль верификационного окружения.
TOP = tb_resource_db

# Зависимости от общих подключаемых файлов.
INCLUDE = $(wildcard ../../../../../common/dv/*.sv)
INCLUDE += ../tb/checker.svhp

# Добавление директории для include.
COMP_OPTS = +incdir+../../../../../common/dv

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
