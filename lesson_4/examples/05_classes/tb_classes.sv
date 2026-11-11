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

    // Данная функция в зависимости от типа
    // передаваемого в нее объекта реализует
    // различный функционал.

    //  ---------------- Важно! ---------------
    // | Обратите внимание, что доступ к полю  |
    // | ~mode~ может быть осуществлен только  |
    // | через object handle типа ~child~, то  |
    // | есть только при успешности $cast().   |
    //  ---------------- Важно! ---------------

    function void process_class(base b);
        child c;
        if( !$cast(c, b) ) begin
            void'(b.randomize() with {addr < 128;});
            b.print();
        end
        else begin
            void'(c.randomize() with {mode == 1;});
            c.print();
        end
    endfunction

    // Object handle наследованного типа.
    child c1;

    initial begin

        // Создание объекта наследованного
        // типа.
        c1 = new();

        // Передача указателя на объект
        // производится через upcasting.
        // Тип объекта проверяется в
        // функции при помощи $cast().
        // В зависимости от типа реали-
        // зуется различный функционал.
        process_class(c1);

    end

endmodule
