/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс agent. Содержит sequencer, driver и monitor.
// Агент load имеет только активную конфигурацию,
// так что поле ~is_active~ не участвует в построении
// агента.

class load_agent_base extends common_agent;

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    // Handle компонентов.
    load_sequencer_base sqr;
    load_driver_base    drv;
    load_monitor_base   mon;

    // Очередь подписчиков на транзакции monitor.
    mailbox#(load_seq_item_base) mbx[$];

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction
        
    // Функция сборки.
    
    //  ---------------------- Важно! -----------------------
    // | Обратите внимание на доступ к базе ресурсов при     |
    // | помощи ~get_full_name()~. Данная функция возвращает |
    // | полное иерархическое имя компонента в верификаци-   |
    // | ционном окружении.                                  |
    //  ---------------------- Важно! -----------------------

    //  ---------------------- Важно! -----------------------
    // | Подход в формировании ключа для базы ресурсов обес- |
    // | печивает максимальную гибкость при переиспользова-  |
    // | нии, т.к. значение ключа зависит от иерархии окру-  |
    // | жения.                                              |
    //  ---------------------- Важно! -----------------------

    virtual function void build();
        // Получение конфигурации.
        if(!common_resource_db#(load_agent_cfg_base)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        // Вывод информации о конфигурации.
        print_config_info();
        // Создание компонентов.
        begin
            drv = new("drv", this);
            sqr = new("sqr", this);
            mon = new("mon", this);
        end
        // Передача конфигурации компонентам.
        begin
            drv.cfg = cfg;
            sqr.cfg = cfg;
            mon.cfg = cfg;
        end
        // Сборка компонентов.
        begin
            drv.build();
            sqr.build();
            mon.build();
        end
    endfunction

    // Соединение sequencer и driver.
    // Рассылка транзакций monitor подписчикам стартует
    // здесь же, чтобы к запуску агента каналы уже работали.
    virtual function void connect();

        // Драйвер и секвенсер.
        sqr.sqr2drv = new();
        sqr.drv2sqr = new();
        drv.sqr2drv = sqr.sqr2drv;
        drv.drv2sqr = sqr.drv2sqr;

        // Подключение монитора с броадкастингом.
        mon.mbx = new();
        fork forever begin
            load_seq_item_base t;
            foreach( mbx[i] ) begin
                mon.mbx.peek(t);
                mbx[i].put(t);
            end
            if(t == null) break;
            void'(mon.mbx.try_get(t));
        end join_none

    endfunction

    // Метод запуска.
    virtual task run();
        fork
            sqr.run();
            drv.run();
            mon.run();
        join
    endtask
    
    // Функция вывода информации о конфигурации.
    // Может быть переопределена наследником.
    virtual function void print_config_info();
        $display($sformatf("%s",
            {  " ---------------------------------------",
             "\n| Load agent was configured with: ",
             "\n ---------------------------------------",
                        cfg.convert2string(),
             "\n----------------------------------------"      
            }));
    endfunction

endclass
