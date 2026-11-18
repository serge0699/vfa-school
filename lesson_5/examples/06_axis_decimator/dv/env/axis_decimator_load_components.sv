/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Интерфейс и ширина load agent.

class load_agent_cfg_base;

    virtual load_intf vif;

    int unsigned dec_width;

endclass

// Класс транзакции. Иначе sequence item.
// Транзакция рандомизиуруется в sequence.

class load_seq_item_base;

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    rand load_dec_t dec;

    constraint width_c {
        (dec >> cfg.dec_width) == '0;
    }
endclass

// Sequencer передает конфигурацию в sequence.

class load_sequencer_base
    extends common_sequencer#(load_seq_item_base);

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

endclass

// Sequence для генерации транзакций типа ~load_seq_item_base~.

class load_sequence_base extends
    common_sequence#(load_seq_item_base);

    // В задаче ~body()~ генерируются полезные данные.
    // Обратите внимание, что транзакция формируется
    // между ~start_item(data)~ и ~finish_item(data)~.
    virtual task body();
        req = get_item();
        start_item(req);
        if( !req.randomize() ) begin
            $fatal(1, "Can't rand. 'req'!");
        end
        finish_item(req);
    endtask

    // Передача конфигурации из sequencer в транзакцию.
    virtual task start_item(load_seq_item_base t);
        load_sequencer_base load_sqr;
        super.start_item(t);
        $cast(load_sqr, sqr);
        t.cfg = load_sqr.cfg;
    endtask

    virtual function load_seq_item_base get_item();
        load_seq_item_base t = new();
        return t;
    endfunction

endclass

// Класс driver.

class load_driver_base
    extends common_driver#(load_seq_item_base);

    // Интерфейс доступен через конфигурацию.
    load_agent_cfg_base cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    virtual task run();
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            reset();
            wait(cfg.vif.aresetn === 1'b1);
            fork begin
                fork
                    begin
                        @(posedge cfg.vif.clk);
                        forever begin
                            get_and_drive();
                        end
                    end
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                disable fork;
            end join
        end
    endtask

    // Задача сброса входных сигналов.
    virtual task reset();
        cfg.vif.load <= 1'b0;
    endtask

    // Задача получения транзакции и генерации входных
    // воздействий на ее основании.
    virtual task get_and_drive();
        get_next_item(req);
        cfg.vif.load <= 1'b1;
        cfg.vif.dec  <= req.dec;
        @(posedge cfg.vif.clk);
        cfg.vif.load <= 1'b0;
        item_done(req);
    endtask

endclass

// Класс monitor для отслеживания состояния портов
// дизайна в ходе симуляции. 

class load_monitor_base
    extends common_monitor;

    load_agent_cfg_base cfg;

    // Mailbox для отправки информации о
    // состоянии сигналов интерфейса.
    mailbox#(load_seq_item_base) mbx;
        
    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача запуска.
    virtual task run();
        load_seq_item_base t;
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            reset();
            wait(cfg.vif.aresetn === 1'b1);
            fork begin
                fork
                    begin
                        forever begin
                            @(posedge cfg.vif.clk);
                            if( cfg.vif.load ) begin
                                t = new();
                                trans_init(t);
                                mbx.put(t);
                            end
                        end
                    end
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                disable fork;
            end join
        end
    endtask

    // Задача сброса входных сигналов.
    virtual task reset();
        cfg.vif.load <= 1'b0;
    endtask

    // Функция инициализации транзакции.
    // Создана для удобства переопределения
    // при наследовании.
    virtual function void trans_init(
        inout load_seq_item_base t
    );
        t.cfg = cfg;
        t.dec = axis_bitsel_u(cfg.vif.dec, cfg.dec_width - 1, 0);
    endfunction

endclass

// Класс agent. Содержит sequencer, driver и monitor.
// Агент интерфейса load имеет только активную конфи-
// гурацию, так что поле ~is_active~ не участвует в
// построении агента.

class load_agent_base extends common_agent;

    load_agent_cfg_base cfg;

    // Handle компонентов.
    load_sequencer_base sqr;
    load_driver_base    drv;
    load_monitor_base   mon;
        
    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Функция сборки.
    virtual function void build();
        if(!common_resource_db#(load_agent_cfg_base)::get(
            get_full_name(), "cfg", cfg)) begin
            $fatal(1, "Can't get 'cfg' from resource_db!");
        end
        sqr     = new("sqr", this);
        sqr.cfg = cfg;
        sqr.build();
        drv     = new("drv", this);
        drv.cfg = cfg;
        drv.build();
        mon     = new("mon", this);
        mon.cfg = cfg;
        mon.build();
    endfunction

    // Функция соединения.
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

endclass
