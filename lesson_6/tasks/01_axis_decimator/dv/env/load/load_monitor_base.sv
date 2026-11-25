/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс monitor для отслеживания состояния портов
// дизайна в ходе симуляции.

class load_monitor_base extends common_monitor;

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    // Mailbox для отправки информации о
    // состоянии сигналов интерфейса.
    mailbox#(load_seq_item_base) mbx;

    // Флаг включения логирования.
    // "Включается" через командную строку при помощи
    // +load_monitor_logging.
    bit logging_enabled = $test$plusargs("load_monitor_logging");

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    virtual task run();

        // Поле транзакции.
        load_seq_item_base t;

        // Ожидание активного уровня сигнала сброса.
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            // Ожидание неактивного уровня сигнала сброса.
            wait(cfg.vif.aresetn === 1'b1);
            // Fork wrapper для ограничения области
            // действия disable fork.
            fork begin
                fork
                    begin
                        forever begin
                            @(posedge cfg.vif.clk);
                            if( cfg.vif.load ) begin
                                t = new();
                                init_trans(t);
                                if( logging_enabled ) begin
                                    print_trans_info(t);
                                end
                                mbx.put(t);
                            end
                        end
                    end
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                disable fork;
            end join
        end

    endtask

    // Функция инициализации транзакции.
    // Создана для удобства переопределения
    // при наследовании.
    virtual function void init_trans(
        inout load_seq_item_base t
    );
        t.cfg = cfg;
        t.dec = load_bitsel_u(cfg.vif.dec, cfg.dec_width - 1, 0);
    endfunction

    // Функция вывода информации о транзакции.
    virtual function void print_trans_info(load_seq_item_base t);
        $display("%0t Load Monitor got transaction: %s",
            $time(), t.convert2string());
    endfunction

endclass
