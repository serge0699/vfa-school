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

class axis_decimator_scoreboard_base
    extends common_scoreboard;

    // Флаг логирования.
    protected bit is_logging_enabled
        = $test$plusargs("axis_decim_scb_logging");

    // Переменная, хранящая значение
    // отсчета для пропуска.
    protected load_dec_t dec;

    // Переменная, хранящая значение
    // счетчика пропусков.
    protected load_dec_t dec_cnt;

    // Mailbox для подключения к monitor.
    mailbox#(axis_seq_item_base)  mbx_master;
    mailbox#(axis_seq_item_base)  mbx_slave;
    mailbox#(reset_seq_item_base) mbx_reset;
    mailbox#(load_seq_item_base)  mbx_load;

    // Промежуточный mailbox между master и slave.
    mailbox#(axis_seq_item_base) mbx_inter;

    // Handle для получения транзакций
    // от AXI-Stream master и slave monitors.
    axis_seq_item_base t_m, t_s;

    // Handle для получения транзакции об
    // изменении сигнала ~load~.
    load_seq_item_base t_l;

    // Счетчик количества проверенных транзакций.
    int current_trans_am;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build();
        mbx_inter = new();
    endfunction

    // Задача запуска.
    // Отвечает за совместный опрос mailbox
    // от master и slave, а также mailbox от
    // load, а также совместный с этим запуск
    // анализа потока этих транзакций (см.
    // ~process_axis()~ и ~process_load()~).
    virtual task run();
        forever begin
            fork begin
                fork
                    forever process_master();
                    forever process_slave ();
                    forever process_load  ();
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
    // от AXI-Stream master и slave транзакций.
    virtual task process_master();
        axis_seq_item_base t_dummy;
        mbx_master.get(t_dummy);
        if( dec_cnt != dec ) begin
            // Счетчик хранится в типе сигнала ~load~,
            // поэтому приращение усекается до ширины
            // настройки прореживания.
            dec_cnt = load_bitsel_u(dec_cnt + 1, t_l.cfg.dec_width - 1, 0);
            mbx_inter.put(t_dummy);
        end
        else begin
            dec_cnt = 0;
        end
    endtask

    // "Опрос" mailbox и проверка полученных
    // от AXI-Stream master и slave транзакций.
    virtual task process_slave();
        mbx_slave.get(t_s);
        current_trans_am = current_trans_am + 1;
        if( !mbx_inter.try_get(t_m) ) begin
            $error({"Handshake on slave, but where was no ",
                "handshake on master or transaction must be skipped!"});
        end
        else begin
            model();
            // Логирование.
            if( is_logging_enabled ) begin
                $display("%t Checked! Input: %0h, Output: %0h",
                    $time(), t_m.tdata,
                        t_s.tdata);
            end
        end
    endtask

    // "Опрос" mailbox и применение полученных
    // load транзакций. Состояние класса, а
    // именно значение переменной ~dec_cnt~
    // обновляется значением, полученным от
    // load monitor.
    virtual task process_load();
        mbx_load.get(t_l);
        dec     = t_l.dec;
        dec_cnt = 0;
    endtask

    // Функция проверки AXI-Stream транзакции прореживателя.
    virtual function void model();
        if( t_s.tdata !== t_m.tdata ) begin
            $error("Invalid result! Input: %0h, Output: %0h",
                t_m.tdata,
                    t_s.tdata);
        end
    endfunction


    // Метод сброса.
    virtual function void reset();
        axis_seq_item_base t_dummy;
        while(mbx_master.try_get(t_dummy)) ;
        while(mbx_slave. try_get(t_dummy)) ;
        while(mbx_inter. try_get(t_dummy)) ;
        dec     = 0;
        dec_cnt = 0;
    endfunction

endclass
