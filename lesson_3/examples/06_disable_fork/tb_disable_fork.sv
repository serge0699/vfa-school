/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Модуль демонстрации принудительного завершения
// процессов при помощи disable fork. В данном
// примере после естественного завершения процесса
// с задержкой в 10ns в задаче ~print_with_delays~,
// при помощи disable fork будет принудительно за-
// вершен процесс с задержкой 20ns, а также
// процесс с задержкой 30, который был создан
// при помощи fork-join_none. Это произойдет
// потому что disable fork принудительно завершает
// ВСЕ процессы родительского процесса, а вызов
// задачи  ~print_with_delays~ нового процесса не
// создает.
module tb_disable_fork;

    task print_with_delays(int unsigned delay_1, int unsigned delay_2);
        fork
            #(delay_1) $display("%m: %t", $time());
            #(delay_2) $display("%m: %t", $time());
        join_any
        disable fork;
    endtask

    initial begin
        fork
            #30 $display("This process will be killed!");
        join_none
        print_with_delays(10, 20);
    end

endmodule
