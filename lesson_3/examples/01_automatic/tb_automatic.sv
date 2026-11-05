/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль показательного вызова автоматической
// задачи. Между вызовами ~my_automatic_task~
// значение переменной ~a~ не сохраняется, так
// как в начале каждого вызова "создается" новая
// копия переменной, а в конце эта копия унич-
// тожается.
module tb_automatic;

    task automatic my_automatic_task();
        int a;
        a = a + 1;
        $display("%m %0d", a);
    endtask

    initial begin
        repeat(5) my_automatic_task();
    end

endmodule
