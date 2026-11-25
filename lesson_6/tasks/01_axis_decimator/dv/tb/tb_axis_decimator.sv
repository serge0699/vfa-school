/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

//  --------------------- Важно! ---------------------
// | Окружение повторяет окружение примера            |
// | lesson_5/examples/06_axis_decimator.             |
//  --------------------- Важно! ---------------------

//  ----------------------- TODO ---------------------
// | В окружение встроена модель покрытия.            |
// | Запустите регрессию при помощи build/run.sh.     |
// | Объедините результаты при помощи cov.sh с флагом |
// | -view и проанализируйте результат. Добавьте      |
// | входные воздействия. Совет: создайте новые тес-  |
// | товые сценарии, направленные на конкретные зна-  |
// | чения ~load~, и добавьте их в массив tests в     |
// | run.sh.                                          |
//  ----------------------- TODO ---------------------

//  --------------------- Важно! ---------------------
// | В дизайне есть feature, которую забыли указать   |
// | в спецификации. Найдите ее.                      |
//  --------------------- Важно! ---------------------

`timescale 1ns/1ps

module tb_axis_decimator;

    // Импорт универсальных компонентов и объектов.
    // Нужен для использования ~common_resource_db~.
    import common_pkg::*;

    // Импорт компонентов и объектов AXI-Stream прореживателя.
    import axis_decimator_dv_pkg::*;

    
    //  ----------------- Важно! ----------------
    // | Сигнал сброса генерируется при помощи   |
    // | agent сигнала сброса. Ссылка на интер-  |
    // | фейс сигнала сброса передается в базу   |
    // | ресурсов в initial ниже. Исходный код   |
    // | agent сигнала сброса находится в:       |
    // | common/dv/reset/tb/reset_agent_base.sv  |
    //  ----------------- Важно! ----------------

    // Параметр для периода тактового
    // сигнала.
    parameter CLK_PERIOD = 10;

    // Ширины шин DUT.
    parameter DATA_WIDTH = 32;
    parameter DEC_WIDTH  = 8;

    // Определение тактового сигнала и
    // сигнала сброса.
    logic clk_i;

    //  ----------------- Важно! ----------------
    // | Сигнал сброса генерируется при помощи   |
    // | driver сигнала сброса. Ссылка на интер- |
    // | фейс сигнала сброса передается в базу   |
    // | ресурсов в initial ниже. Исходный код   |
    // | driver сигнала сброса находится в:      |
    // |     common/dv/reset/tb/reset_driver.sv  |
    //  ----------------- Важно! ----------------

    // Объявление интерфейса сигнала сброса.
    reset_intf reset_intf(clk_i);

    // Интерфейсы AXI-Stream с максимальной
    // шириной шин.
    axis_intf axis_intf_master (clk_i, reset_intf.reset);
    axis_intf axis_intf_slave  (clk_i, reset_intf.reset);

    // Объявление интерфейса load.
    load_intf load_intf (clk_i, reset_intf.reset);
    
    // Подключение тестируемого модуля.
    axis_decimator #(
        .DATA_WIDTH ( DATA_WIDTH ),
        .DEC_WIDTH  ( DEC_WIDTH  )
    ) DUT (
        .clk_i      ( clk_i                                   ),
        .aresetn_i  ( reset_intf      .reset                  ),
        .load_i     ( load_intf       .load                   ),
        .dec_i      ( load_intf       .dec   [ DEC_WIDTH-1:0] ),
        .s_tvalid_i ( axis_intf_master.tvalid                 ),
        .s_tdata_i  ( axis_intf_master.tdata [DATA_WIDTH-1:0] ),
        .s_tready_o ( axis_intf_master.tready                 ),
        .m_tvalid_o ( axis_intf_slave .tvalid                 ),
        .m_tdata_o  ( axis_intf_slave .tdata [DATA_WIDTH-1:0] ),
        .m_tready_i ( axis_intf_slave .tready                 )
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
        automatic `AXIS_DECIMATOR_TEST test = new("top", null);

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
            "top", "axis_tdata_width", DATA_WIDTH);
        common_resource_db#(int unsigned)::set(
            "top", "axis_tid_width", 0);

        // Передача интерфейса сброса.
        common_resource_db#(virtual reset_intf)::set(
            "top", "reset_vif", reset_intf);

        // Передача интерфейса и ширины load.
        common_resource_db#(virtual load_intf)::set(
            "top", "load_vif", load_intf);
        common_resource_db#(int unsigned)::set(
            "top", "load_dec_width", DEC_WIDTH);

        // Сборка, подключение и запуск.
        test.build  ();
        test.connect();
        test.run    ();

    end

endmodule
