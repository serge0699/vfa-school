/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Конвейерный модуль воздведения в 5 степень.
module axis_pow (
    input logic         clk_i,
    input logic         aresetn_i,
    // AXI-Stream на вход.
    input  logic        s_tvalid_i,
    output logic        s_tready_o,
    input  logic [31:0] s_tdata_i,
    input  logic        s_tid_i,
    input  logic        s_tlast_i,
    // AXI-Stream на выход.
    output logic        m_tvalid_o,
    input  logic        m_tready_i,
    output logic [31:0] m_tdata_o,
    output logic        m_tid_o,
    output logic        m_tlast_o
);

    logic        tvalid_ff     [5];
    logic [31:0] tdata_ff      [5];
    logic [31:0] tdata_tmp_ff  [4];
    logic        tid_ff        [5];
    logic        tlast_ff      [5];
    logic        ready         [5];

    // Ступень принимает данные, если свободна
    // или следующая ступень готова их забрать.

    for(genvar i = 0; i < 4; i++) begin : gen_ready
        assign ready[i] = ~tvalid_ff[i] | ready[i+1];
    end
    assign ready[4] = ~tvalid_ff[4] | m_tready_i;

    always_ff @(posedge clk_i or negedge aresetn_i) begin
        if( ~aresetn_i ) begin
            for(int i = 0; i < 5; i++) begin
                tvalid_ff    [i] <= 'b0;
                tdata_ff     [i] <= 'b0;
                tid_ff       [i] <= 'b0;
                tlast_ff     [i] <= 'b0;
            end
            for(int i = 0; i < 4; i++) begin
                tdata_tmp_ff [i] <= 'b0;
            end
        end
        else begin
            if( ready[0] ) begin
                tvalid_ff    [0] <= s_tvalid_i;
                tdata_ff     [0] <= s_tdata_i;
                tdata_tmp_ff [0] <= s_tdata_i;
                tid_ff       [0] <= s_tid_i;
                tlast_ff     [0] <= s_tlast_i;
            end
            for(int i = 1; i < 5; i++) begin
                if( ready[i] ) begin
                    tvalid_ff [i] <= tvalid_ff [i-1];
                    tdata_ff  [i] <= tdata_ff  [i-1] * tdata_tmp_ff [i-1];
                    tid_ff    [i] <= tid_ff    [i-1];
                    tid_ff    [i] <= tid_ff    [i-1];
                    if( i < 4 ) begin
                        tdata_tmp_ff [i] <= tdata_tmp_ff [i-1];
                    end
                end
            end
        end
    end

    assign s_tready_o = ready[0];
    assign m_tvalid_o = tvalid_ff [4];
    assign m_tdata_o  = tdata_ff  [4];
    assign m_tid_o    = tid_ff    [4];
    assign m_tlast_o  = tlast_ff  [4];

endmodule
