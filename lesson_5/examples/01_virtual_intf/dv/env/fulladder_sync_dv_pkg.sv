/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет верификационного окружения 
// последовательностного сумматора.
package fulladder_sync_dv_pkg;

    // Импорт универсальных элементов.
    import common_pkg::*;

    // Класс драйвера последовательностного сумматора.

    //  -------------------- Важно! ---------------------
    // | Класс driver взаимодействует со статическим     |
    // | интерфейсом, объявленном в топ модуле верифика- |
    // | ционного окружения tb_fulladder_sync.sv при по- |
    // | щи виртуального интерфейса, являющегося его по- |
    // | лем ~virtual fulladder_sync_intf vif~. Присво-  |
    // | ение статического интерфейса к виртуальному мо- |
    // | жет быть выполнено иерархически извне, что и    |
    // | происходит в tb_fulladder_sync.sv.              |
    //  -------------------- Важно! ---------------------

    class fulladder_sync_driver extends common_driver;

        // Указатель на интерфейс.
        virtual fulladder_sync_intf vif;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        // Задача запуска.
        virtual task run();

            // Обращение к проводам интерфейса
            // производится иерархически (через
            // точку).
            wait(vif.areset === 1'b1);
            reset();
            wait(vif.areset === 1'b0);

            @(posedge vif.clk);

            forever begin
                vif.A   <= $urandom();
                vif.B   <= $urandom();
                vif.Cin <= $urandom();
                @(posedge vif.clk);
            end

        endtask

        // Задача сброса.
        virtual task reset();
            vif.A   <= 1'b0;
            vif.B   <= 1'b0;
            vif.Cin <= 1'b0;
        endtask

    endclass

    // Класс монитора последовательностного сумматора.

    //  -------------------- Важно! ---------------------
    // | Класс monitor взаимодействует со статическим    |
    // | интерфейсом, объявленном в топ модуле верифика- |
    // | ционного окружения tb_fulladder_sync.sv при по- |
    // | щи виртуального интерфейса, являющегося его по- |
    // | лем ~virtual fulladder_sync_intf vif~. Присво-  |
    // | ение статического интерфейса к виртуальному мо- |
    // | жет быть выполнено иерархически извне, что и    |
    // | происходит в tb_fulladder_sync.sv.              |
    //  -------------------- Важно! ---------------------

    class fulladder_sync_monitor extends common_monitor;

        // Указатель на интерфейс.
        virtual fulladder_sync_intf vif;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        // Задача запуска
        virtual task run();

            // Обращение к проводам интерфейса
            // производится иерархически (через
            // точку).
            wait(vif.areset === 1'b1);
            reset();
            wait(vif.areset === 1'b0);

            @(posedge vif.clk);

            forever begin
                $display("A: %1b, B: %1b, Cin: %1b",
                    vif.A, vif.B, vif.Cin);
                @(posedge vif.clk);
            end

        endtask

        // Задача сброса.
        virtual task reset();
            vif.A   <= 1'b0;
            vif.B   <= 1'b0;
            vif.Cin <= 1'b0;
        endtask

    endclass

endpackage
