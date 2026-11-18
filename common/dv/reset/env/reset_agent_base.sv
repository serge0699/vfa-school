/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс agent сигнала сброса. Инкапсулирует
// sequencer, driver и monitor.

class reset_agent_base extends common_agent;

    // Конфигурация агента.
    reset_agent_cfg_base cfg;

    // Handle компонентов.
    reset_sequencer_base sqr;
    reset_driver_base    drv;
    reset_monitor_base   mon;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction
        
    // Функция сборки.
    virtual function void build();
        if(!common_resource_db#(reset_agent_cfg_base)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        // Вывод информации о конфигурации.
        print_config_info();
        // Создание компонентов.
        begin
            sqr = new("sqr", this);
            drv = new("drv", this);
            mon = new("mon", this);
        end
        // Передача конфигурации компонентам.
        begin
            sqr.cfg = cfg;
            drv.cfg = cfg;
            mon.cfg = cfg;
        end
        // Сборка компонентов.
        begin
            sqr.build();
            drv.build();
            mon.build();
        end
    endfunction

    // Метод соединения.
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
             "\n| Reset agent was configured with: ",
             "\n ---------------------------------------",
                        cfg.convert2string(),
             "\n----------------------------------------"
            }));
    endfunction

endclass
