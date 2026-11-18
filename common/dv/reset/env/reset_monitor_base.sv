/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Monitor активного уровня сигнала сброса.

class reset_monitor_base extends common_monitor;

    // Конфигурация агента.
    reset_agent_cfg_base cfg;

    // Mailbox уведомлений об активном сбросе.
    mailbox#(reset_seq_item_base) mbx;

    // Флаг включения логирования.
    // Включается через +reset_monitor_logging.
    bit logging_enabled = $test$plusargs("reset_monitor_logging");

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Отправка транзакции при обнаружении активного уровня.
    virtual task run();
        reset_seq_item_base t;
        forever begin
            wait(cfg.vif.reset === cfg.active_level);
            t = new();
            if( logging_enabled ) begin
                print_trans_info(t);
            end
            mbx.put(t);
            wait(cfg.vif.reset === ~cfg.active_level);
        end
    endtask

    // Функция вывода информации о транзакции.
    virtual function void print_trans_info(reset_seq_item_base t);
        $display("%0t Reset Monitor got transaction: %s",
            $time(), t.convert2string());
    endfunction

endclass
