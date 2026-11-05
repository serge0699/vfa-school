/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

class base;

    rand bit       mode;
    rand bit [2:0] addr;

    constraint mode_addr {
        if( mode ) { addr == 3'b0; }
        else { addr != 3'b0; }
    };
    
endclass

// Ограничения обладают двунаправленной
// "природой". В данном примере если
// ~addr~ в ходе рандомизации примет
// значение 0, то mode тоже примет
// значение 1, т.к. это определено
// в условии if-else в ~mode_addr~,
// только ограничение сработает от
// результата рандомизации ~addr~.
module tb_classes;

    base b1;

    initial begin
        b1 = new();
        repeat(10) begin
            void'(b1.randomize() with {!addr;});
            $display("mode: %1b addr: %3b", b1.mode, b1.addr);
        end
    end

endmodule
