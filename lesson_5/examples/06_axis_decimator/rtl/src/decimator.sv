/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль прореживателя.
// Данный модуль нивелирует каждый
// n-ый отсчет сигнала (не пропускает)
// ~valid_i~ на ~valid_o~. n определяется
// сигналом ~dec_i~, который обновляется
// при активном уровне (1) сигнала ~load_i~.
// Если ~load_i~ активен, то ~valid_i~
// игнорируется, данные не пропускаются.
module decimator #(
    parameter DATA_WIDTH = 32,
    parameter DEC_WIDTH  = 8
) (
    input  logic                  clk_i,
    input  logic                  areset_i,
    input  logic                  load_i,
    input  logic [ DEC_WIDTH-1:0] dec_i,
    input  logic                  valid_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic                  valid_o,
    output logic [DATA_WIDTH-1:0] data_o
);

    // Счетчик децимации.
    logic [DEC_WIDTH-1:0] dec_cnt_ff;

    // Регистр, хранящий значение ~dec_i~.
    logic [DEC_WIDTH-1:0] dec_ff;

    // Флаг пропуска отсчета.
    // Если счетчик децимации равен ~dec_i~, то
    // отсчет пропускается.
    logic skip_sample;
    assign skip_sample = (dec_cnt_ff == dec_ff);

    // Запись в регистр ~dec_ff~ осуществляется
    // при активном уровне (1) ~load_i~.
    always_ff @(posedge clk_i or posedge areset_i) begin
        if( load_i ) begin
            dec_ff <= dec_i;
        end
    end

    // При активном уровне (1) сигнала записи
    // ~load_i~ счетчик сбрасывается. Иначе при
    // наличии валидных данных и выполнении
    // условия пропуска, счетчик сбрасывается,
    // иначе инкрементируется.
    always_ff @(posedge clk_i or posedge areset_i) begin
        if( areset_i ) begin
            dec_cnt_ff <= 'b0;
        end
        else if( load_i ) begin
            dec_cnt_ff <= 'b0;
        end
        else if( valid_i ) begin
            if( skip_sample ) begin
                dec_cnt_ff <= 'b0;
            end
            else begin
                dec_cnt_ff <= dec_cnt_ff + 1'b1;
            end
        end
    end

    // Выставление выходных сигналов.
    // Данные защелкиваются неизменными, сигнал
    // валидности учитывается при отсутствии
    // условия пропуска отсчета.
    always_ff @(posedge clk_i or posedge areset_i) begin
        if( areset_i ) begin
            valid_o <= 1'b0;
            data_o  <= 'b0;
        end
        else begin
            valid_o <= ~load_i & valid_i & ~skip_sample;
            data_o  <= data_i;
        end
    end

endmodule
