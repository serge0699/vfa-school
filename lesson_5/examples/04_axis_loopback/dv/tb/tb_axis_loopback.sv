/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Топ-модуль для запуска loopback AXI-Stream.
// Под loopback подразумевается подключение
// master agent и slave agent к одному интер-
// фейсу. Таким образом agent взаимодействуют
// друг с другом. Подобные сценарии применя-
// ются в индустрии для проверки самих компо-
// нентов верификационного окружения. Подроб-
// нее см. в axis_test_loopback.sv.

//  ------------------ Важно! -----------------
// | В данном примере для генерации сигнала    |
// | сброса используется специальный класс     |
// | ~reset_driver~. См. комментарии в модуле. |
//  ------------------ Важно! -----------------

module tb_axis_loopback;

    // Импорт универсальных компонентов и объектов.
    // Нужен для использования ~common_resource_db~.
    import common_pkg::*;

    // Импорт компонентов и объектов AXI-Stream.
    import axis_loopback_pkg::*;

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

    // Объявление интерфейса AXI-Stream.
    axis_intf axis_intf(clk_i, reset_intf.reset);

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
        automatic axis_test_loopback test = new("top", null);

        // Передача интерфейсов AXI-Stream.
        common_resource_db#(virtual axis_intf)::set(
            "top", "axis_vif_master", axis_intf);

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
