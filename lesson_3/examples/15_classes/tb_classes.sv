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
// у которого есть аргумент.

//  ----------- Важно -----------
// | Обратите внимание на this.  |
// | Через это ключевое слово    |
// | можно обратиться к объекту  |
// | класса в памяти. Здесь this |
// | используется для устранения |
// | маскирования одноименного   |
// | поля аргументом конструк-   |
// | тора.                       |
//  ----------- Важно -----------

class base;

    bit [7:0] a;

    function new(bit[7:0] a);
        this.a = a;
    endfunction
        
endclass

// При вызове new() поле
// ~a~ объекта примет значение 7
// при помощи передачи аргумента
// в конструктор.
module tb_classes;

    base b1;

    initial begin
        b1 = new(7);
    end

endmodule
