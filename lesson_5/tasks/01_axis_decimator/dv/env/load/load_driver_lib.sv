/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Библиотека классов драйверов для load.

class load_driver_base extends
    common_driver#(load_seq_item_base);

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    virtual task run();
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            reset();
            wait(cfg.vif.aresetn === 1'b1);
            fork begin
                fork
                    begin
                        @(posedge cfg.vif.clk);
                        forever begin
                            get_and_drive();
                        end
                    end
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                disable fork;
            end join
        end
    endtask

    // Задача сброса входных сигналов.

    //  ------------------ TODO -------------------
    // | Задайте начальные значения ~load~ и ~dec~ |
    // | неблокирующими присваиваниями.            |
    //  ------------------ TODO -------------------

    virtual task reset();

        // TODO: Реализация метода.

    endtask

    // Задача получения транзакции и генерации входных
    // воздействий на ее основании.

    //  ----------------------- TODO ------------------------
    // | Выставьте ~dec~ из транзакции и поднимите ~load~ на |
    // | один такт. Затем снимите ~load~. Используйте        |
    // | неблокирующие присваивания по положительному фронту |
    // | тактового сигнала.                                  |
    //  ----------------------- TODO ------------------------

    virtual task get_and_drive();

        get_next_item(req);

        // TODO: Передача транзакции.

        item_done(req);

    endtask

endclass
