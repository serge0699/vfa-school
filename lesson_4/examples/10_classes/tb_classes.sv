/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс, параметризуемый шириной адреса и данных.
// Параметры определяют размерность полей.
class packet #(DATA_WIDTH = 32, ADDR_WIDTH = 32);
    rand bit [DATA_WIDTH-1:0] data;
    rand bit [ADDR_WIDTH-1:0] addr;
endclass

//  ----------------- Важно! -----------------
// | При проектировании верификационных       |
// | окружений с использованием классов па-   |
// | раметризация применяется в крайних слу-  |
// | чаях (не касается параметризации типом), |
// | так как значительно усложняет процесс    |
// | проектирования и отладки.                |
//  ----------------- Важно! -----------------

module tb_classes;

    packet#( 8,  8) p_8;
    packet#(16, 16) p_16;
    packet#(      ) p_32;

    initial begin
        p_8  = new(); void'(p_8.randomize());
        p_16 = new(); void'(p_16.randomize());
        p_32 = new(); void'(p_32.randomize());
        $display("p_8  data: %8h, addr: %8h",
            p_8.data,  p_8.addr );
        $display("p_16 data: %8h, addr: %8h",
            p_16.data, p_16.addr);
        $display("p_32 data: %8h, addr: %8h",
            p_32.data, p_32.addr);
    end

endmodule
