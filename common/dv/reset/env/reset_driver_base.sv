/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Driver сигнала сброса.

class reset_driver_base extends
    common_driver#(reset_seq_item_base);

    // Конфигурация агента.
    reset_agent_cfg_base cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    virtual task run();
        cfg.vif.reset <= ~cfg.active_level;
        forever begin
            get_and_drive();
        end
    endtask

    // Генерация одного импульса сброса.
    virtual task get_and_drive();
        get_next_item(req);
        repeat(req.delay) begin
            @(posedge cfg.vif.clk);
        end
        @(posedge cfg.vif.clk);
        cfg.vif.reset <= cfg.active_level;
        repeat(req.duration) begin
            @(posedge cfg.vif.clk);
        end
        cfg.vif.reset <= ~cfg.active_level;
        item_done(req);
    endtask

endclass
