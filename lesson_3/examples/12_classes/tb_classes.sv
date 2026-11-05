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

// Вызов $display() выведет 1, т.к.
// object handle ~b1~ действительно
// равен null, т.к. не указывает ни
// на какой объект в памяти.
module tb_classes;

    // Object handle типа ~base~.
    base b1;

    initial begin
        $display(b1 == null);
    end

endmodule
