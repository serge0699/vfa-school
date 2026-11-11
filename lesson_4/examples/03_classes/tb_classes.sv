/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Базовый (родительский) класс
// с полем ~addr~ и методом ~print()~.
class base;
    rand bit [31:0] addr;
    function void print();
        $display("addr %h", addr);
    endfunction
endclass

// Наследованный класс с иной
// имплементацией метода ~print()~
// и новым полем ~mode~.
class child extends base;
    rand bit mode;
    function void print();
        $display("addr %h with mode %1b",
            addr, mode);
    endfunction
endclass

module tb_classes;

    // Object handle родительского
    // и наследованного типов.
    base  b1;
    child c1;

    initial begin

        // Создание объекта наследованного
        // типа.
        c1 = new();

        // Создание объекта родительского
        // типа.
        b1 = new();

        // Upcasting. Теперь родительский
        // handle указывает на объект
        // наследованного типа.
        b1 = c1;

        // При вызове методов через
        // object handle родительского
        // класса будет вызываться
        // родительская реализация.
        b1.print();

        // Доступ к полям и методам,
        // которые определены в родительском
        // классе, возможен, т.к. в любом
        // наследованном классе по умол-
        // чанию есть поля и методы ба-
        // зового.
        $display("addr: %h", b1.addr);

        // Доступ к полям и методам
        // наследника через родительский
        // handle невозможен и вызовет
        // ошибку на этапе компиляции или
        // элаборации.
        // Убедитесь, что строка ниже
        // приводит к ошибке, а после
        // закомментируйте ее.
        $display("mode: %1b", b1.mode);

    end

endmodule
