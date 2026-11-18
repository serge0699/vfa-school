/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс monitor для отслеживания состояния портов
// дизайна в ходе симуляции. Универсален как для
// master, так и для slave, так как handshake для
// master и slave несет один и тот же смысл.

//  ---------------- Важно! ---------------
// | Код класса подробно задокументирован. |
// | Читайте комментарии!                  |
//  ---------------- Важно! ---------------

class axis_monitor_base extends common_monitor;

    // Конфигурация агента.
    axis_agent_cfg_base cfg;

    // Mailbox для отправки информации о
    // состоянии сигналов интерфейса.
    mailbox#(axis_seq_item_base) mbx;

    // Флаг включения логирования.
    // "Включается" через командную строку при помощи
    // +axis_monitor_logging.
    bit logging_enabled = $test$plusargs("axis_monitor_logging");

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача ~run()~ класса monitor отвечает
    // за сохранение информации о состоянии
    // сигналов интерфейса.
    virtual task run();

        // Поле транзакции.
        axis_seq_item_base t;

        // Ожидание активного уровня сигнала сброса.
        // Обратите внимание, что в AXI-Stream
        // активный уровень 0.
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            // Ожидание неактивного уровня сигнала сброса.
            wait(cfg.vif.aresetn === 1'b1);
            // Fork wrapper для создание от-
            // дельного потока (хотим пов-
            // лять только на процессы в нем
            // при вызове disable fork).
            fork begin
                fork
                    begin
                        // Мониторинг сигналов AXI-Stream.
                        // Обратите внимание, что согласно
                        // спецификации передача данных
                        // (handshake) происходит в такт,
                        // когда ~tvalid~ и ~tready~ оба
                        // находятся в активном уровне.
                        // Таким образом, состояние сиг-
                        // налов фиксируется monitor толь-
                        // ков моменты handshake.
                        forever begin
                            @(posedge cfg.vif.aclk);
                            if( cfg.vif.tvalid && cfg.vif.tready ) begin
                                t = new();
                                init_trans(t);
                                // При включенном логировании
                                // производится вывод информации
                                // о зафиксироанной транзакции.
                                if( logging_enabled ) begin
                                    print_trans_info(t);
                                end
                                mbx.put(t);
                            end
                        end
                    end
                    // Ожидание активного уровня
                    // сигнала сброса. Происходит
                    // совместно с генерацией вход-
                    // ных воздействий.
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                // disable fork ниже выполнится при
                // "приходе" активного уровня сиг-
                // нала сброса. После чего процесс
                // логирования будет завершен прину-
                // дительно, а цикл forever "вернется"
                // к началу.
                disable fork;
            end join
        end

    endtask

    // Функция инициализации транзакции.
    // Создана для удобства переопределения
    // при наследовании.
    virtual function void init_trans(
        inout axis_seq_item_base t
    );
        t.cfg   = cfg;
        t.tdata = axis_bitsel_u(cfg.vif.tdata, cfg.tdata_width - 1, 0);
        t.tid   = axis_bitsel_u(cfg.vif.tid,   cfg.tid_width   - 1, 0);
        t.tlast = cfg.vif.tlast;
    endfunction

    // Функция вывода информации о транзакции.
    virtual function void print_trans_info(axis_seq_item_base t);
        $display("%0t AXI-Stream Monitor got transaction: %s",
            $time(), t.convert2string());
    endfunction

endclass
