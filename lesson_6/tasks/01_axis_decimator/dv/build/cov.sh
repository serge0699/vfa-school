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
vcover report -cvg -details -output ./coverage_cvg_report.txt ./coverage.ucdb

# Отчет по покрытию кода (statement/branch/condition/expression).
vcover report -code sbce -details -output ./coverage_code_report.txt ./coverage.ucdb

# Просмотр базы покрытия, если был передан флаг -view.
if [[ $* == -view ]]; then
    vsim -gui -viewcov ./coverage.ucdb
fi
