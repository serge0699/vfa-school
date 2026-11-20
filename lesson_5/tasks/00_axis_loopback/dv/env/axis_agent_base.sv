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

    //  ------------------------- TODO --------------------------
    // | 1. Получите конфигурацию из базы ресурсов и выведите ее |
    // |    через ~print_config_info()~.                         |
    // | 2. В зависимости от ~cfg.is_master~ создайте master или |
    // |    slave driver.                                        |
    // | 3. Создайте sequencer и monitor.                        |
    // | 4. После создания всех трех компонентов передайте им    |
    // |    конфигурацию, затем вызовите их методы ~build()~.    |
    //  ------------------------- TODO --------------------------

    virtual function void build();

        // TODO: Получение конфигурации.

        // TODO: Вывод информации о конфигурации.

        // TODO: Случай master: создается master driver.

        // TODO: Случай slave: создается slave driver.

        // TODO: Создание sequencer.

        // TODO: Создание monitor.

    endfunction

    // Функция соединения.

    //  ------------ TODO -------------
    // | Реализуйте метод соединения.  |
    // | Соедините sequencer и driver. |
    //  ------------ TODO -------------

    virtual function void connect();

        // TODO: Соединение.

    endfunction

    // Метод запуска.

    //  ---------- TODO -----------
    // | Реализуйте метод запуска. |
    //  ---------- TODO -----------

    virtual task run();

        // TODO: Запуск.

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
