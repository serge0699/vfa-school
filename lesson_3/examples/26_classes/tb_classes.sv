/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Одно из возможных выражений для
// ограничений - inside. Оно
// определяет интервал возможных
// значений для поля.
class base;

    rand bit [ 7:0] addr;
    rand bit [31:0] data;

    constraint addr_c {
        addr inside {[0:10]};};
    constraint data_c {
        data inside {1, 3, 5, 7};};
    
endclass

// Согласно ограничениям в классе
// поле ~addr~ будет принимать
// значения от 0 до 10. Поле
// ~data~ будет принимать зна-
// чения 1, 3, 5 или 7. Это бу-
// дет происходить после каждого
// вызова randomize().
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        repeat(10) begin
            void'(b1.randomize());
            $display("addr: %0d, data: %0d", b1.addr, b1.data);
        end
    end

endmodule
