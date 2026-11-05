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

// При попытке обращения к элементам
// объекта при помощи object handle,
// который не указывает ни на какой
// объект (null), симулятор должен
// сгенерировать ошибку доступа к
// памяти.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        b1.a = 5; b1.print();
        b1 = null;
        // Здесь будет сгенерирована ошибка.
        b1.a = 7;
    end

endmodule
