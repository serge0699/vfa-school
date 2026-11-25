/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Сборщик покрытия.

class load_cov_collector extends common_component;

    // Конфигурация сборщика покрытия.
    load_cov_collector_cfg cfg;

    // Mailbox от monitor load.
    mailbox#(load_seq_item_base) mbx;

    // Covergroup покрытия значений пропуска.
    load_cg cg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Создание covergroup'а с фактической
    // конфигурацией DUT.
    virtual function void build();
        // Получение конфигурации.
        if(!common_resource_db#(load_cov_collector_cfg)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        cg = new(cfg);
    endfunction

    // Запуск сбора покрытия по транзакциям:
    // сэмплируется транзакция, значение пропуска
    // из нее берется в модели покрытия.
    virtual task run();
        load_seq_item_base t;
        forever begin
            mbx.get(t);
            cg.sample(t);
        end
    endtask

endclass
