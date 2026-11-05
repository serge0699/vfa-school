/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Модуль демонстрации создания динамических
// процессов при помощи fork-join_any.
// В данном примере после выражений statement_1
// и statement_2 блок fork-join_any создает 3
// динамических процесса (process_1, process_2,
// process_3), которые запускаются одновременно
// и выполняются совместно.
// Выполнение выражений после fork-join_any
// (statement_3 и statement_4) начнется
// после завершения хотя бы одного из процессов,
// созданных в fork-join_any. В данном примере
// после завершения process_2, т.к. его выполнение
// займет меньше всего времени (10ns).
module tb_fork_join_any;

    initial begin
        $display("%t statement_1", $time());
        $display("%t statement_2", $time());
        fork
            #15 $display("%t process_1", $time());
            #10 $display("%t process_2", $time());
            #20 $display("%t process_3", $time());
        join_any
        $display("%t statement_3", $time());
        $display("%t statement_4", $time());
    end

endmodule
