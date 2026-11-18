/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

module tb_axis_pow;

    // Импорт универсальных компонентов и объектов.
    // Нужен для использования ~common_resource_db~.
    import common_pkg::*;

    // Импорт компонентов и объектов AXI-Stream
    // модуля возведения в степень.
    import axis_pow_dv_pkg::*;

    // Параметр для периода тактового
    // сигнала.
    parameter CLK_PERIOD = 10;

    // Определение тактового сигнала и
    // сигнала сброса.
    logic clk_i;

    //  ----------------- Важно! ----------------
    // | Сигнал сброса генерируется при помощи   |
    // | agent сигнала сброса. Ссылка на интер-  |
    // | фейс сигнала сброса передается в базу   |
    // | ресурсов в initial ниже. Исходный код   |
    // | agent сигнала сброса находится в:       |
    // | common/dv/reset/tb/reset_agent_base.sv  |
    //  ----------------- Важно! ----------------

    // Объявление интерфейса сигнала сброса.
    reset_intf reset_intf(clk_i);

    // Интерфейсы AXI-Stream с максимальной
    // шириной шин.
    axis_intf axis_intf_master (clk_i, reset_intf.reset);
    axis_intf axis_intf_slave  (clk_i, reset_intf.reset);
    
    // Подключение тестируемого модуля.
    axis_pow DUT (
        .clk_i      ( clk_i                          ),
        .aresetn_i  ( reset_intf.reset               ),
        .s_tvalid_i ( axis_intf_master.tvalid        ),
        .s_tready_o ( axis_intf_master.tready        ),
        .s_tdata_i  ( axis_intf_master.tdata  [31:0] ),
        .s_tid_i    ( axis_intf_master.tid    [   0] ),
        .s_tlast_i  ( axis_intf_master.tlast         ),
        .m_tvalid_o ( axis_intf_slave. tvalid        ),
        .m_tready_i ( axis_intf_slave. tready        ),
        .m_tdata_o  ( axis_intf_slave. tdata  [31:0] ),
        .m_tid_o    ( axis_intf_slave. tid    [   0] ),
        .m_tlast_o  ( axis_intf_slave. tlast         )
    );

    // Генерация тактового сигнала.
    initial begin
        clk_i <= 1'b0;
        forever begin
            #(CLK_PERIOD/2) clk_i = ~clk_i;
        end
    end

    // Основной статический процесс, запускающий тест.
    initial begin

        // Создание класса теста.
        automatic `AXIS_POW_TEST test = new("top", null);

        // Отправка ссылок на интерфейсы в базу ресурсов.

        //  ---------------------- Важно! -----------------------
        // | Простейшая реализация базы ресурсов не поддерживает |
        // | wildcards, так что для каждого компонента отправка  |
        // | производится отдельно.                              |
        //  ---------------------- Важно! -----------------------

        // Передача интерфейсов AXI-Stream.
        common_resource_db#(virtual axis_intf)::set(
            "top", "axis_vif_master", axis_intf_master);
        common_resource_db#(virtual axis_intf)::set(
            "top", "axis_vif_slave", axis_intf_slave);

        // Передача ширин AXI-Stream.
        common_resource_db#(int unsigned)::set(
            "top", "tdata_width", 32);
        common_resource_db#(int unsigned)::set(
            "top", "tid_width", 1);

        // Передача интерфейса сброса.
        common_resource_db#(virtual reset_intf)::set(
            "top", "reset_vif", reset_intf);

        // Сборка, подключение и запуск.
        test.build  ();
        test.connect();
        test.run    ();

    end

endmodule
