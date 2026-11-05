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
// пользователем конструктором new().
class base;

    bit [7:0] a;

    function new();
        a = 7;
    endfunction
        
endclass

// При вызове new() поле ~a~
// объекта примет значение 7.
module tb_classes;

    // Object handle типа ~base~.
    base b1;

    initial begin
        b1 = new();
    end

endmodule
