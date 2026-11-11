/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс со статическим методом класса
// ~get_special()~. Такой метод отличается
// от классического статического метода,
// во-первых, тем, что static написано до
// function или task, а во-вторых, функционалом.
// Как и статическое поле, статический
// метод класса принадлежит типу.
class base;

    static int increment;

    static function int get_special();
        return 32'hDEAD_BEEF + increment;
    endfunction

endclass

// Статический метод класса может быть
// вызван иерархически через object handle
// или при помощи оператора области види-
// мости :: без создания объекта.

//  ---------------- Важно! ----------------
// | Статические методы класса могут взаимо- |
// | действовать только со статическими по- |
// | лями класса.                           |
//  ---------------- Важно! ----------------

module tb_classes;

    // Object handle.
    base  b1;

    initial begin
        b1 = new();
        $display("%h", b1.get_special());
        $display("%h", base::get_special());
        base::increment = -66;
        $display("%h", base::get_special());
    end

endmodule
