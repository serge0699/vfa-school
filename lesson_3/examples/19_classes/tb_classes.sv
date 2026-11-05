/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Объявление класса с полем ~a~
// типа bit [7:0] и методом ~print()~.
class base;

    bit [7:0] a;

    function void print();
        $display("base: %0d", a);
    endfunction
        
endclass

// Уничтожение объекта можно
// инициировать, присвоив object
// handle, который на него указывает,
// значение null.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        b1.a = 5; b1.print();
        b1 = null;
    end

endmodule
