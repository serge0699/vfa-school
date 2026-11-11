# Директория примера.
EXAMPLE = $(realpath  ./../..)

# Топ-модуль верификационного окружения.
TOP = tb_hier

# Зависимости от общих подключаемых файлов.
INCLUDE = $(wildcard ../../../../../common/dv/*.sv)

# Добавление директории для include.
COMP_OPTS = +incdir+../../../../../common/dv

# Запуск в GUI режиме.
SIM_OPTS += -gui

# Подключение основного Makefile для
# сборки и симуляции.
include ../../../../../common/make/Makefile
