/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс environment верификационного окружения
// синхронного AXI-Stream прореживателя. Содержит
// в себе handle на agent master и agent slave,
// а также handle scoreboard.

class axis_decimator_env_base extends common_env;

    // Handle для agents.
    axis_agent_base  axis_ag_master;
    axis_agent_base  axis_ag_slave;
    reset_agent_base reset_ag;
    load_agent_base  load_ag;

    // Handle для scoreboard.
    axis_decimator_scoreboard_base scb;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction
    

    // Задача сборки.

    //  ---------------------- TODO -----------------------
    // | Создайте master и slave агенты AXI-Stream, агенты |
    // | load и reset, а также scoreboard. Вызовите их     |
    // | методы ~build()~.                                 |
    //  ---------------------- TODO -----------------------

    virtual function void build();

        // TODO: Реализация метода.

    endfunction

    // Задача соединения.

    //  ----------------------- TODO ------------------------
    // | Вызовите методы ~connect()~ агентов. Создайте       |
    // | mailbox мониторов и передайте ссылки в поля         |
    // | scoreboard: ~mbx_master~, ~mbx_slave~, ~mbx_load~ и |
    // | ~mbx_reset~.                                        |
    //  ----------------------- TODO ------------------------

    virtual function void connect();

        // TODO: Реализация метода.

    endfunction

    // Задача запуска.
    // Agents и scoreboard запускаются совместно.

    //  ------------------- TODO -------------------
    // | Параллельно запустите агенты и scoreboard. |
    //  ------------------- TODO -------------------

    virtual task run();

        // TODO: Реализация метода.

    endtask

endclass
