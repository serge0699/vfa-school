/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

module tb_hier;

    // Импорт компонентов.
    import hier_pkg::*;

    // Основной статический процесс, создающий компоненты.

    //  --------------------- Важно! ---------------------
    // | В данном файле изменений делать не нужно! Все    |
    // | изменения необходимо вносить в hier_pkg.sv. Если |
    // | при запуске генерируется ошибка доступа к памя-  |
    // | ти, то ошибка НЕ в этом модуле.                  |
    //  --------------------- Важно! ---------------------

    initial begin

        my_comp_0 c0 = new("c0", null); c0.build();
        $display("%s %s", c0        .get_name(), c0        .get_full_name());
        $display("%s %s", c0.c1     .get_name(), c0.c1     .get_full_name());
        $display("%s %s", c0.c2     .get_name(), c0.c2     .get_full_name());
        $display("%s %s", c0.c1.c2_1.get_name(), c0.c1.c2_1.get_full_name());
        $display("%s %s", c0.c1.c2_2.get_name(), c0.c1.c2_2.get_full_name());
        
    end

endmodule
