/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль показательного вызова статической
// задачи. Между вызовами ~my_static_task~
// значение переменной ~a~ сохраняется.

//  ------------------- Важно! --------------------
// | Обратите внимание, что так как в статических  |
// | функциях и задачах переменные статические, то |
// | возможен иерархический доступ к ним.          |
// | Пример: ~my_static_task.a~.                   |
//  ------------------- Важно! --------------------

module tb_static;

    task my_static_task();
        int a;
        a = a + 1;
        $display("%m %0d", a);
    endtask

    initial begin
        repeat(5) my_static_task();
        $display(my_static_task.a);
    end

endmodule
