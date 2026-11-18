/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс environment верификационного окружения
// синхронного AXI-Stream модуля возведения в 
// степень. Содержит в себе handle на agent
// master и agent slave, а также handle scoreboard.

class axis_pow_env_base extends common_env;

    // Handle для agents.
    axis_agent_base  axis_ag_master;
    axis_agent_base  axis_ag_slave;
    reset_agent_base reset_ag;

    // Handle для scoreboard.
    axis_pow_scoreboard_base scb;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача сборки.
    virtual function void build();
        // Создание и сборка agents.
        axis_ag_master = new("axis_ag_master", this);
        axis_ag_master.build();
        axis_ag_slave = new("axis_ag_slave", this);
        axis_ag_slave.build();
        reset_ag = new("reset_ag", this);
        reset_ag.build();
        // Создание и сборка scoreboard.
        scb = new("scb", this);
        scb.build();
    endfunction

    // Задача соединения.
    virtual function void connect();
        // Соединение agents.
        axis_ag_master.connect();
        axis_ag_slave .connect();
        reset_ag      .connect();
        // Соединение monitor и scoreboard.
        axis_ag_master.mon.mbx = new();
        axis_ag_slave .mon.mbx = new();
        reset_ag      .mon.mbx = new();
        scb.mbx_master = axis_ag_master.mon.mbx;
        scb.mbx_slave  = axis_ag_slave .mon.mbx;
        scb.mbx_reset  = reset_ag      .mon.mbx;
    endfunction

    // Задача запуска.
    // Agents и scoreboard запускаются совместно.
    virtual task run();
        fork
            axis_ag_master.run();
            axis_ag_slave .run();
            reset_ag      .run();
            scb           .run();
        join
    endtask

endclass
