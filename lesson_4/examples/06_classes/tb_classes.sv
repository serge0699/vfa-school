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
// Обратите внимание, что метод
// ~print()~ объявлен как virtual.
// Это ключевое слово позволяет
// выполнять реализацию функции
// наследника через object handle
// родительского класса.
class base;
    rand bit [31:0] addr;
    virtual function void print();
        $display("addr %h", addr);
    endfunction
endclass

// Наследованный класс с иной
// имплементацией метода ~print()~
// и новым полем ~mode~.
// Если функция объявлена в родителе
// как virtual, то во всех наследниках
// она тоже будет virtual, независимо
// от того, написано ключевое слово
// или нет. Тем не менее ключевое
// слово рекомендуется сохранять
// написанным и в наследниках.
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

        // Upcasting. Теперь родительский
        // handle указывает на объект
        // наследованного типа.
        b1 = c1;

        // При вызове методов через
        // object handle родительского
        // класса будет вызываться
        // реализация того наследника,
        // на который указывает handle
        // в данный момент, так как
        // метод в родительском классе
        // объявлен как virtual.
        b1.print();

    end

endmodule
