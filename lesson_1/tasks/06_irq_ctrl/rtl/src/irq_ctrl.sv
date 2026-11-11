/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль простейшего комбинационного
// контроллера прерываний. Если ~mode_i~
// равен логической 1, то на выход ~reqs_o~
// попадает самая старшая 1 со входа
// ~reqs_i~. Если ~mode_i~ в логическом 0,
// то на выход ~reqs_o~ попадает самая
// младшая 1 со входа ~reqs_i~. Если на
// входе ~reqs_i~ нет логических 1, то
// выход ~reqs_o~ равен 3'b000 независимо
// от ~mode_i~.
module irq_ctrl (
    input  logic [2:0] reqs_i,
    input  logic       mode_i,
    output logic [2:0] reqs_o
);

    logic [2:0] reqs_lsb;
    logic [2:0] reqs_msb;

    always_comb begin
        reqs_msb = 3'b0;
        for (int i = 2; i >= 0; i = i - 1) begin
            reqs_msb = reqs_i[i] ? 3'(1'b1 << i) : reqs_msb;
        end
    end

    always_comb begin
        reqs_lsb = 3'b0;
        for (int i = 2; i >= 0; i = i - 1) begin
            reqs_lsb = reqs_i[i] ? 3'(1'b1 << i) : reqs_lsb;
        end
    end
 
    assign reqs_o = mode_i ? reqs_lsb
                           : reqs_msb;

endmodule
