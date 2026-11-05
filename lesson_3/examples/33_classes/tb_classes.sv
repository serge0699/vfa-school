/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Обратите внимание на конструкцию
// constraint, которая накладывает
// ограничение на рандомизацию поля
// ~a~ для каждого объекта класса,
// который будет создан.
// В данном примере произойдет
// ошибка рандомизации, так как
// в рамках одного constraint
// будут конфликтовать два ог-
// раничения: ~a < 5~ и ~a > 10~.
class base;

    rand bit [7:0] a;

    constraint a_c {a < 5; a > 10;};
    
endclass

module tb_classes;

    base b1;

    initial begin
        b1 = new();
        repeat(10) begin
            if(!b1.randomize()) begin
                $fatal(1, "Can't rand. base!");
            end
            $display("a: %0d", b1.a);
        end
    end

endmodule
