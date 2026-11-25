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
    virtual task reset();
        cfg.vif.load <= 1'b0;
    endtask

    // Задача получения транзакции и генерации входных
    // воздействий на ее основании.
    virtual task get_and_drive();
        get_next_item(req);
        cfg.vif.load <= 1'b1;
        cfg.vif.dec  <= req.dec;
        @(posedge cfg.vif.clk);
        cfg.vif.load <= 1'b0;
        item_done(req);
    endtask

endclass
