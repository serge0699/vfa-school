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
// Обратите внимание, что у поля ~a~
// есть ключевое слово rand, которое
// позволяет полю принимать случайное
// значение при вызове randomize()
// для объекта класса.
class base;

    rand bit [7:0] a;

    function void print();
        $display("base: %0d", a);
    endfunction
        
endclass

// Объекты классов рандомизируются при
// помощи встроенной функции randomize().
// Функция возвращает 0 или 1 в зависимости
// от успешности рандомизации. В данном
// примере, если вызов randomize() вернет
// 0, то сгенерируется фатальная ошибка,
// симуляция завершится.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        if(!b1.randomize()) begin
            $fatal(1, "Can't rand. b1!");
        end
        else b1.print();
    end

endmodule
