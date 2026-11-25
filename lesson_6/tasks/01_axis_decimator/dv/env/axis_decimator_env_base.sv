/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Клаcc environment верификационного окружения
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

    // Handle для сборщиков покрытия: сигнал load и
    // соотношение транзакций к пропуску.
    load_cov_collector           load_cc;
    axis_decimator_cov_collector axis_decimator_cc;

    // Объявление конструктора обязательно, так как
    // конструктор родительского клаccа содержит аргументы.
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
        load_ag = new("load_ag", this);
        load_ag.build();
        // Создание и сборка scoreboard.
        scb = new("scb", this);
        scb.build();
        // Создание и сборка сборщиков покрытия.
        load_cc = new("load_cc", this);
        load_cc.build();
        axis_decimator_cc = new("axis_decimator_cc", this);
        axis_decimator_cc.build();
    endfunction

    // Задача соединения.
    virtual function void connect();

        // Соединение agents.
        reset_ag      .connect();
        axis_ag_slave .connect();
        axis_ag_master.connect();
        load_ag       .connect();

        // Соединение monitor и scoreboard.
        scb.mbx_master = new();
        scb.mbx_slave  = new();
        scb.mbx_reset  = new();
        scb.mbx_load   = new();
        axis_ag_master.mbx.push_back(scb.mbx_master);
        axis_ag_slave .mbx.push_back(scb.mbx_slave );
        reset_ag      .mbx.push_back(scb.mbx_reset );
        load_ag       .mbx.push_back(scb.mbx_load  );

        // Соединение monitor и сборщиков покрытия.
        load_cc.mbx                  = new();
        axis_decimator_cc.mbx_master = new();
        axis_decimator_cc.mbx_load   = new();
        axis_decimator_cc.mbx_reset  = new();
        axis_ag_master.mbx.push_back(axis_decimator_cc.mbx_master);
        load_ag       .mbx.push_back(axis_decimator_cc.mbx_load  );
        reset_ag      .mbx.push_back(axis_decimator_cc.mbx_reset );
        load_ag       .mbx.push_back(load_cc.mbx                 );

    endfunction

    // Задача запуска.
    // Agents, scoreboard и сборщики покрытия
    // запускаются совместно.
    virtual task run();
        fork
            axis_ag_master   .run();
            axis_ag_slave    .run();
            reset_ag         .run();
            load_ag          .run();
            scb              .run();
            load_cc          .run();
            axis_decimator_cc.run();
        join
    endtask

endclass
