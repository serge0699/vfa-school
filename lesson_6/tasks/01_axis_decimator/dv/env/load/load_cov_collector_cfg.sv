/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Конфигурация сборщика покрытия.

class load_cov_collector_cfg;

    // Ширина сигнала пропуска отсчетов.
    int unsigned dec_width;

    // Количество интервалов, на которые делится
    // диапазон значений пропуска.
    int unsigned dec_intervals;

    // Функция вывода информации о конфигурации.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\n| dec_width    : %0d", dec_width    )};
        str = {str, $sformatf("\n| dec_intervals: %0d", dec_intervals)};
        return str;
    endfunction

endclass
