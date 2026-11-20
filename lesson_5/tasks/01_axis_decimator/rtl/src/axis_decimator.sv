/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// AXI-Stream модуль прореживателя.
module axis_decimator #(
    parameter DATA_WIDTH = 32,
    parameter DEC_WIDTH  = 8
) (
    input  logic                  clk_i,
    input  logic                  aresetn_i,
    input  logic                  load_i,
    input  logic [ DEC_WIDTH-1:0] dec_i,
    input  logic                  s_tvalid_i,
    input  logic [DATA_WIDTH-1:0] s_tdata_i,
    output logic                  s_tready_o,
    output logic                  m_tvalid_o,
    output logic [DATA_WIDTH-1:0] m_tdata_o,
    input  logic                  m_tready_i
);

    // Модуль готов принимать данные, если на выходе
    // нет валидных данных без готовности их принять.
    assign s_tready_o = m_tvalid_o & ~m_tready_i ? 0 : 1;

    // Сигнал валидных входных данных в прореживатель.
    logic valid_i;
    assign valid_i = s_tvalid_i & s_tready_o;

    // Сигнал валидных выходных данных прореживателя
    // и самих данных, полученных из прореживателя.
    logic                  valid_o;
    logic [DATA_WIDTH-1:0] data_o;

    // Экземпляр прореживателя.
    decimator #(
        .DATA_WIDTH  ( DATA_WIDTH    ),
        .DEC_WIDTH   ( DEC_WIDTH     )
    ) decimator_inst (
        .clk_i       ( clk_i         ),
        .areset_i    ( ~aresetn_i    ),
        .load_i      ( load_i        ),
        .dec_i       ( dec_i         ),
        .valid_i     ( valid_i       ),
        .data_i      ( s_tdata_i     ),
        .valid_o     ( valid_o       ),
        .data_o      ( data_o        )
    );

    // Регистры хранения результата.
    logic                  valid_ff;
    logic [DATA_WIDTH-1:0] data_ff;

    // Логика регистров хранения результата.
    always_ff @(posedge clk_i or negedge aresetn_i) begin
        if( !aresetn_i ) begin
            valid_ff <= 1'b0;
            data_ff  <=  'b0;
        end
        else if( valid_o & ~m_tready_i ) begin
            valid_ff <= valid_o;
            data_ff  <= data_o;
        end
        else if( m_tvalid_o & m_tready_i ) begin
            valid_ff <= 1'b0;
        end
    end

    // Сигнал валидности выходных данных.
    assign m_tvalid_o = valid_o | valid_ff;

    // Сигнал выходных данных.
    assign m_tdata_o = valid_o ? data_o : data_ff;
    
endmodule
