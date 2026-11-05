/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// В выражениях ограничений может
// использоваться конструкция if-else,
// которая определяет взаимосвязь значений
// полей для рандомизации.
class base;

    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_c {
        addr dist { 8'b0 := 3, 8'hFF := 5,
            [1:254] :/ 1};
        if( addr == 8'b0 ) {
            data == 8'b1;
        } else { data == 8'b0; }
    };

endclass

// А данном примере, если поле
// ~addr~ будет срандомизировано
// в значение 0, то ~data~ будет
// срандомизирована в значение 1,
// для иных значений ~addr~ поле
// ~data~ будет срандомизировано
// в 0.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        repeat(10) begin
            void'(b1.randomize());
            $display("addr: %3d, data: %3d", b1.addr, b1.data);
        end
    end

endmodule
