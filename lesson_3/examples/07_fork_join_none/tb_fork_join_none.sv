/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Модуль демонстрации "выполнения" выражения
// потребляющего время в функции.
module tb_fork_join_none;

    function void call_fork_join_none();
        fork
            #10 $display("This process was started in: %m");
        join_none
    endfunction

    initial begin
        call_fork_join_none();
    end

endmodule
