/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс с классическим статическим
// методом ~calc()~. Для всех вызовов
// этого метода в объектах типа ~base~
// или производных от него значение переменной
// будет сохраняться между этими вызо-
// вами.

//  ----------------- Важно! -----------------
// | Объявление function static в теле класса |
// | запрещено стандартом. Однако некоторые   |
// | симуляторы поддерживают данный функцио-  |
// | нал. Не рекомендуется автором к исполь-  |
// | зованию.                                 |
//  ----------------- Важно! -----------------

class base;

    function static void calc();
        int data;
        data = data + 1;
        $display(data);
    endfunction

endclass

// В данном примере результирующее
// значение переменной data будет
// равно 5, т.к. функция ~calc()~
// статическая.
module tb_classes;

    // Object handle.
    base  b1;

    initial begin

        b1 = new();
        repeat(5) b1.calc();

    end

endmodule
