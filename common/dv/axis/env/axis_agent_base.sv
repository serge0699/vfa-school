/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс agent. В зависимости от поля ~cfg.is_master~
// создает компоненты типа master или slave.
// Агент AXI-Stream имеет только активную конфигурацию,
// так что поле ~is_active~ не участвует в построении
// агента.

class axis_agent_base extends common_agent;

    // Конфигурация агента.
    axis_agent_cfg_base cfg;

    // Handle компонентов.
    axis_sequencer_base sqr;
    axis_driver_base    drv;
    axis_monitor_base   mon;

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
        if(!common_resource_db#(axis_agent_cfg_base)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        // Вывод информации о конфигурации.
        print_config_info();
        // Создание компонентов.
        begin
            // Создание driver в зависимости от роли агента.
            if( cfg.is_master ) begin
                axis_driver_master drv_m = new("drv", this);
                drv = drv_m;
            end
            else begin
                axis_driver_slave drv_s = new("drv", this);
                drv = drv_s;
            end
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
    virtual function void connect();
        sqr.sqr2drv = new();
        sqr.drv2sqr = new();
        drv.sqr2drv = sqr.sqr2drv;
        drv.drv2sqr = sqr.drv2sqr;
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
             "\n| AXI-Stream agent was configured with: ",
             "\n ---------------------------------------",
                        cfg.convert2string(),
             "\n----------------------------------------"      
            }));
    endfunction

endclass
