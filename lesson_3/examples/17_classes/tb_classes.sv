/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Объявление класса с полем ~a~
// типа bit [7:0] и определенным
// пользователем конструктором new(),
// у которого есть аргумент. А также
// методом ~print()~.
class base;

    bit [7:0] a;

    function new(bit[7:0] a);
        this.a = a;
    endfunction

    function void print();
        $display("base: %0d", a);
    endfunction
        
endclass

// Объекты класса могут создаваться
// и уничтожаться в ходе симуляции.
// Объект класса в данном примере
// создается через 10ns после начала
// симуляции.
module tb_classes;

    base b1;

    initial begin
        #10ns;
        b1 = new(7);
    end

endmodule
