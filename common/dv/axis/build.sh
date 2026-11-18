# Скрипт сборки элементов для верификации AXI-Stream.
# Должен быть вызван с двумя аргументами: максимальная ширина TDATA и TID.
# Пример: ./build.sh 128 8
if [ "$#" -ne 2 ]; then
    echo "Illegal number of arguments, exiting..."
    exit 1
fi

vmap common_lib ../common_lib && vlog +incdir+env env/axis_pkg.sv \
    tb/axis_intf.sv +define+AXIS_MAX_TDATA_WIDTH=$1 +define+AXIS_MAX_TID_WIDTH=$2 -work axis_lib -L common_lib
