/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

module tb_fulladder_sync;

    // Параметр для периода тактового сигнала.
    parameter CLK_PERIOD = 10;

    // Объявление тактового сигнала и сигнала сброса.
    logic clk_i;
    logic areset_i;

    // Объявление интерфейса последовательностного сумматора.
    // См. файл fulladdder_sync_intf.sv.

    //  -------------------- Важно! --------------------
    // | Тактовый сигнал и сигнал сброса подключаются   |
    // | к интерфейсу через порты интерфейса.           |
    //  -------------------- Важно! --------------------

    fulladder_sync_intf intf(clk_i, areset_i);

    // Подключение тестируемого модуля.

    //  -------------------- Важно! --------------------
    // | Сигналы кроме тактового и сброса подключаются  |
    // | к интерфейсу иерархически.                     |
    //  -------------------- Важно! --------------------

    fulladder_sync DUT (
        .clk_i    ( clk_i     ), 
        .areset_i ( areset_i  ), 
        .A_i      ( intf.A    ), 
        .B_i      ( intf.B    ), 
        .Cin_i    ( intf.Cin  ), 
        .Cout_o   ( intf.Cout ), 
        .S_o      ( intf.S    )
    );

    // Генерация тактового сигнала.
    initial begin
        clk_i <= 1'b0;
        forever begin
            #(CLK_PERIOD/2) clk_i = ~clk_i;
        end
    end

    // Генерация сигнала сброса.
    initial begin
        areset_i <= 1'b1;
        @(posedge clk_i);
        @(negedge clk_i);
        areset_i = 1'b0;
    end

    // Генерация входных воздействий при помощи интерфейса.
    initial begin
        wait(intf.areset === 1'b1);
        intf.A   <= 1'b0;
        intf.B   <= 1'b0;
        intf.Cin <= 1'b0;
        wait(intf.areset === 1'b0);
        @(posedge intf.clk);
        repeat(10) begin
            intf.A   <= $urandom();
            intf.B   <= $urandom();
            intf.Cin <= $urandom();
            @(posedge intf.clk);
        end
        $finish();
    end

endmodule
