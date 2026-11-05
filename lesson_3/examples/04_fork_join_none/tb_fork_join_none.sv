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
// процессов при помощи fork-join_none.
// В данном примере после выражений statement_1
// и statement_2 блок fork-join_none создает 3
// динамических процесса (process_1, process_2,
// process_3), которые запускаются одновременно
// и выполняются совместно.
// Однако, процессы начнут выполняться только
// в момент выполнения первого блокирующего
// выражения в "процессе-родителе", либо же
// после его завершения (в данном примере 
// "родителем" является статический initial).
// В данном примере процессы начнут выполняться
// после выполнения всех выражений в initial
// (nb_statement_1, nb_statement_2, nb_statement_3,
// nb_statement_4), т.к. они все неблокирующие (что
// такое блокирующие выражения см. SystemVerilog IEEE
// Std 1800-2023 Annex P). 
module tb_fork_join_none;

    initial begin
        $display("%t nb_statement_1", $time());
        $display("%t nb_statement_2", $time());
        fork
            #15 $display("%t process_1", $time());
            #10 $display("%t process_2", $time());
            #20 $display("%t process_3", $time());
        join_none
        $display("%t nb_statement_3", $time());
        $display("%t nb_statement_4", $time());
    end

endmodule
