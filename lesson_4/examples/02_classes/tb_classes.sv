/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Объявление класса с полем ~addr~
// и ограничением ~addr_c~.
class base;
    rand logic [7:0] addr;
    constraint addr_c {!(addr[1:0]);};
endclass

// Объявление класса-наследника для ~base~
// с таким же именем ограничения ~addr_c~,
// но другим его содержанием. При вызове
// метода ~randomize()~ через object handle
// типа ~child~ будет применено ограничение
// с содержанием наследника.
class child extends base;
    constraint addr_c {addr[1:0];};
endclass

module tb_classes;

    // Object handle типа ~child~.
    child c1;

    initial begin
        c1 = new();
        void'(c1.randomize());
        $display("child.addr: %8b", c1.addr);
    end

endmodule
