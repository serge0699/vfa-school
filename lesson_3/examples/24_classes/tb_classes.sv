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
// который будет создан. В рамках
// одной конструкции может быть
// объявлено множество ограничений.
// В ходе рандомизации должны быть
// удовлетворены сразу все ограни-
// чения.
class base;

    rand bit [7:0] a;

    constraint a_c {a < 5; a > 2;};
    
endclass

// На каждой итерации рандомизации в данном
// примере поле ~a~ будет принимать значение
// меньше 5 и больше 2. За это отвечает
// ограничение ~a_c~, объявленное в теле
// класса.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        repeat(10) begin
            void'(b1.randomize()); $display("a: %0d", b1.a);
        end
    end

endmodule
