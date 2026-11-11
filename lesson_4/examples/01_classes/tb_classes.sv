/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Объявление класса с полем ~addr~
// и методом ~print()~.
class base;
    rand logic [7:0] addr;
    function void print();
        $display("base: %0d", addr);
    endfunction
endclass

// Объявление класса-наследника для ~base~
// с иной реализацией метода ~print()~.
// При вызове ~print()~ через object handle
// типа ~child~ будет использоваться реализация
// наследника. Для вызова родительской реа-
// лизации можно использовать ключевое слово
// ~super~.
class child extends base;
    function void print();
        super.print();
        $display("child: %0d", addr);
    endfunction
endclass

module tb_classes;

    // Object handle типа ~child~.
    child c1;

    initial begin
        c1 = new();
        // Будет вызвана реализация
        // наследника, из которой через
        // super будет вызвана реализация
        // родителя.
        c1.print();
    end

endmodule
