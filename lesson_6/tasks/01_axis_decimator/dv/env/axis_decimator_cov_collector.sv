/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Сборщик покрытия.

class axis_decimator_cov_collector extends common_component;

    // Конфигурация сборщика покрытия.
    axis_decimator_cov_collector_cfg cfg;

    // Mailbox от monitor master, load и reset.
    mailbox#(axis_seq_item_base)  mbx_master;
    mailbox#(load_seq_item_base)  mbx_load;
    mailbox#(reset_seq_item_base) mbx_reset;

    // Covergroup покрытия прореживателя.
    axis_decimator_ratio_cg cg;

    // Текущее значение пропуска и количество
    // принятых транзакций.
    protected load_dec_t dec;
    protected int        trans_am;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Создание covergroup'а с фактической
    // конфигурацией DUT.
    virtual function void build();
        // Получение конфигурации.
        if(!common_resource_db#(axis_decimator_cov_collector_cfg)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        cg = new(cfg);
    endfunction

    // Запуск сбора покрытия по транзакциям.
    virtual task run();
        forever begin
            fork begin
                fork
                    forever process_master();
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

    // Обработка транзакции от monitor load.
    // Новое значение пропуска обнуляет счетчик
    // транзакций, накопленных для предыдущего значения.
    virtual task process_load();
        load_seq_item_base t;
        mbx_load.get(t);
        dec      = t.dec;
        trans_am = 0;
    endtask

    // Обработка транзакции от monitor master:
    // счетчик увеличивается и сэмплируется
    // на каждой транзакции.
    virtual task process_master();
        axis_seq_item_base t;
        mbx_master.get(t);
        trans_am = trans_am + 1;
        cg.sample(dec, trans_am);
    endtask

    // Метод сброса.
    virtual function void reset();
        axis_seq_item_base t_master;
        load_seq_item_base t_load;
        while(mbx_master.try_get(t_master)) ;
        while(mbx_load.  try_get(t_load  )) ;
        dec      = 0;
        trans_am = 0;
    endfunction

endclass
