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

    // Импорт компонентов и объектов сумматора.
    import fulladder_sync_dv_pkg::*;

    // Параметр для периода тактового сигнала.
    parameter CLK_PERIOD = 10;

    // Объявление тактового сигнала и сигнала сброса.
    logic clk_i;
    logic areset_i;

    // Объявление интерфейса последовательностного сумматора.

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


    // Процесс создания драйвера и монитора, а также
    // их совместного запуска.

    //  --------------------- Важно! ---------------------
    // | Обратите внимание на моменты присвоения стати-   |
    // | ческих интерфейсов виртуальным: ~drv.vif = intf~ |
    // | и ~mon.vif = intf~. После выполнения данных при- |
    // | своений классы могут обращаться к статическому   |
    // | интерфейсу при помощи виртуального, что и проис- |
    // | ходит в их задачах ~run()~, которые запускаются  |
    // | после присвоений интерфейсов.                    |
    //  --------------------- Важно! ---------------------

    initial begin
        automatic fulladder_sync_driver  drv = new("drv", null);
        automatic fulladder_sync_monitor mon = new("mon", null);
        drv.vif = intf;
        mon.vif = intf;
        fork
            drv.run();
            mon.run();
        join_none
        wait(areset_i === 1'b0);
        repeat(10) @(posedge clk_i);
        disable fork;
        $finish();
    end

endmodule
