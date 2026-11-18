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

    // Подключение универсальных элементов.
    import common_pkg::*;

    // Класс драйвера последовательностного сумматора.

    //  -------------------- Важно! ---------------------
    // | Класс driver взаимодействует со статическим     |
    // | интерфейсом, объявленном в топ модуле верифика- |
    // | ционного окружения tb_fulladder_sync.sv при по- |
    // | щи виртуального интерфейса, являющегося его по- |
    // | лем ~virtual fulladder_sync_intf vif~. Присво-  |
    // | ение статического интерфейса к виртуальному мо- |
    // | жет быть выполнено через базу ресурсов при по-  |
    // | мощи помещения в нее ссылки на интерфейс в топ- |
    // | модуле верификационного окружения и получения   |
    // | ссылки в ходе конфигурации класса.              |
    //  -------------------- Важно! ---------------------

    class fulladder_sync_driver extends common_driver;

        virtual fulladder_sync_intf vif;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction
        
        //  ---------------------- Важно! -----------------------
        // | Обратите внимание на доступ к базе ресурсов при     |
        // | помощи ~get_full_name()~. Данная функция возвращает |
        // | полное иерархическое имя компонента в верификаци-   |
        // | ционном окружении.                                  |
        //  ---------------------- Важно! -----------------------

        virtual function void build();
            // Если ссылка не может быть получена (ее нет в базе),
            // то генерируется фатальная ошибка, так как driver
            // не сможет взаимодействовать с дизайном.
            if(!common_resource_db#(virtual fulladder_sync_intf)::get(
                get_full_name(), "vif", vif)) begin
                $fatal(1, "Can't get 'vif' from resource_db!");
            end
        endfunction

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
    // | жет быть выполнено через базу ресурсов при по-  |
    // | мощи помещения в нее ссылки на интерфейс в топ- |
    // | модуле верификационного окружения и получения   |
    // | ссылки в ходе конфигурации класса.              |
    //  -------------------- Важно! ---------------------

    class fulladder_sync_monitor extends common_monitor;

        virtual fulladder_sync_intf vif;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        //  ---------------------- Важно! -----------------------
        // | Обратите внимание на доступ к базе ресурсов при     |
        // | помощи ~get_full_name()~. Данная функция возвращает |
        // | полное иерархическое имя компонента в верификаци-   |
        // | ционном окружении.                                  |
        //  ---------------------- Важно! -----------------------

        virtual function void build();
            // Если ссылка не может быть получена (ее нет в базе),
            // то генерируется фатальная ошибка, так как monitor
            // не сможет получать информацию о состоянии дизайна
            // в ходе симуляции.
            if(!common_resource_db#(virtual fulladder_sync_intf)::get(
                get_full_name(), "vif", vif)) begin
                $fatal(1, "Can't get 'vif' from resource_db!");
            end
        endfunction

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

        virtual task reset();
            vif.A   <= 1'b0;
            vif.B   <= 1'b0;
            vif.Cin <= 1'b0;
        endtask

    endclass

endpackage
