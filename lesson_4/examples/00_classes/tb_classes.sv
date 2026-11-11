/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Объявление класса с полем ~addr~,
// методом ~print()~ и ограничением
// ~addr_c~.
class base;
    rand logic [7:0] addr;
    function void print();
        $display("base: %0d", addr);
    endfunction 
    constraint addr_c {!(addr[1:0]);};
endclass

// Объявление класса-наследника для ~base~
// с полем ~data~. Для наследования исполь-
// зуется ключевое слово extends.
// Тип ~child~ наследует поле ~addr~,
// метод ~print()~ и ограничение
// ~addr_c~, а также вносит новое поле
// ~data~ и ограничение ~data_c~.
class child extends base;
    rand logic [3:0] data;
    constraint data_c {!(data % 2);};
endclass

module tb_classes;

    // Object handle типа ~child~.
    child c1;

    initial begin
        c1 = new();
        void'(c1.randomize());
        c1.print();
    end

endmodule
