# ***************************************************
# * Copyright © 2026 Sergey Chusov.
# * Version 1.0.0.
# * Licensed under CC BY-NC-ND 4.0
# * (Attribution-NonCommercial-NoDerivatives).
# * https://creativecommons.org/licenses/by-nc-nd/4.0
# * SPDX-License-Identifier: CC-BY-NC-ND-4.0
# ***************************************************

# "Слияние" баз покрытия, собранных при помощи run.sh
# (out/sim/<test>/coverage.ucdb).
vcover merge -out ./coverage.ucdb $(pwd)/out/sim/*/coverage.ucdb

# Отчет по функциональному покрытию (covergroup).
# Кодовое покрытие для MAC не собирается, поэтому
# отчет по коду не формируется.
vcover report -cvg -details -output ./coverage_report.txt ./coverage.ucdb

# Просмотр базы покрытия, если был передан флаг -view.
if [[ $* == -view ]]; then
    vsim -gui -viewcov ./coverage.ucdb
fi
