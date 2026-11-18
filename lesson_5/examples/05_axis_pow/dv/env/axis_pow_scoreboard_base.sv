/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс scoreboard для получения информации от monitor
// и проверки соответствия поведения дизайна спецификации.

class axis_pow_scoreboard_base
    extends common_scoreboard;

    // Флаг логирования.
    protected bit is_logging_enabled
        = $test$plusargs("axis_pow_scb_logging");

    // Mailbox для подключения к monitor.
    mailbox#(axis_seq_item_base)  mbx_master;
    mailbox#(axis_seq_item_base)  mbx_slave;
    mailbox#(reset_seq_item_base) mbx_reset;

    // Handle для получения транзакций
    // от master и slave.
    axis_seq_item_base t_m, t_s;

    // Счетчик количества проверенных транзакций.
    int current_trans_am;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    // Отвечает за совместный опрос mailbox
    // от master и slave, а также совместный
    // с этим запуск анализа потока этих тран-
    // закций (см. ~process_axis()~).
    virtual task run();
        forever begin
            fork begin
                fork
                    forever process_axis();
                    begin
                        reset_seq_item_base t;
                        mbx_reset.get(t);
                    end
                join_any
                disable fork;
                reset();
            end join
        end
    endtask

    // "Опрос" mailbox и проверка полученных
    // от master и slave транзакций.
    virtual task process_axis();
        axis_tdata_t data_ref;
        mbx_master.get(t_m);
        mbx_slave .get(t_s);
        data_ref = model(t_m, t_s.cfg.tdata_width);
        if( data_ref !== t_s.tdata ) begin
            $error("Invalid tdata! Real: %0h, Expected: %0h",
                t_s.tdata, data_ref);
        end
        if( t_m.tid !== t_s.tid ) begin
            $error("Invalid tid! Output: %0h, Input: %0h",
                t_s.tid, t_m.tid);
        end
        if( t_m.tlast !== t_s.tlast ) begin
            $error("Invalid tlast! Output: %1b, Input: %1b",
                t_s.tlast, t_m.tlast);
        end
        // Логирование.
        if( is_logging_enabled ) begin
            $display("%t Checked! Input: %h Output: %h",
                $time(), t_m.tdata,
                    t_s.tdata);
        end
        // Увеличение счетчика проверенных транзакций.
        current_trans_am = current_trans_am + 1;
    endtask

    // Получение эталонного значения.
    virtual function axis_tdata_t model(
        axis_seq_item_base t,
        int unsigned       result_width
    );
        return axis_bitsel_u(t.tdata ** 5, result_width - 1, 0);
    endfunction


    // Метод сброса.
    virtual function void reset();
        axis_seq_item_base t_dummy;
        while(mbx_master.try_get(t_dummy)) ;
        while(mbx_slave. try_get(t_dummy)) ;
    endfunction

endclass
