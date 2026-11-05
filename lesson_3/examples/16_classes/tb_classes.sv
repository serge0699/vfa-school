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

// К элементам класса можно обращаться
// иерархически извне. Если они не
// защищены модификаторами доступа,
// которые будут рассмотрены позже.
module tb_classes;

    base b1;

    initial begin
        b1 = new(7);
        b1.print(); $display(b1.a);
    end

endmodule
