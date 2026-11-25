/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Базовый тест AXI-Stream прореживателя. Инкапсулирует
// environment и sequence для AXI-Stream, сигнала ~load~
// и сигнала сброса.

//  --------------------- Важно! ----------------------
// | Класс поддерживает запуск множественных sequence, |
// | таймаут, инициацию сброса через reset sequence.   |
//  --------------------- Важно! ----------------------

class axis_decimator_test_base extends common_test;

    // Указатели на интерфейсы.
    virtual axis_intf axis_vif_master;
    virtual axis_intf axis_vif_slave;
    virtual load_intf load_vif;

    // Интерфейс сброса.
    virtual reset_intf reset_vif;

    // Ширины шин.
    int unsigned axis_tdata_width;
    int unsigned axis_tid_width;
    int unsigned load_dec_width;

    // Environment.
    axis_decimator_env_base env;

    // Конфигурации агентов.
    axis_agent_cfg_base  axis_ag_cfg_master;
    axis_agent_cfg_base  axis_ag_cfg_slave;
    reset_agent_cfg_base reset_ag_cfg;
    load_agent_cfg_base  load_ag_cfg;

    // Статусные флаги и настройки.
    protected int          expected_trans_am;
    protected bit          stimulus_done;
    protected int unsigned timeout_in_cyles = 100000;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Создание и конфигурация environment.
    
    //  ---------------------- Важно! -----------------------
    // | Обратите внимание на доступ к базе ресурсов при     |
    // | помощи ~get_full_name()~. Данная функция возвращает |
    // | полное иерархическое имя компонента в верификаци-   |
    // | ционном окружении.                                  |
    //  ---------------------- Важно! -----------------------

    virtual function void build();

        // Получение интерфейсов и ширин шин.
        if(!common_resource_db#(virtual reset_intf)::get(
            get_full_name(), "reset_vif", reset_vif)) begin
            $fatal(1, "Can't get 'reset_vif' from resource_db!");
        end
        if(!common_resource_db#(virtual axis_intf)::get(
            get_full_name(), "axis_vif_master", axis_vif_master)) begin
            $fatal(1, "Can't get 'axis_vif_master' from resource_db!");
        end
        if(!common_resource_db#(virtual axis_intf)::get(
            get_full_name(), "axis_vif_slave", axis_vif_slave)) begin
            $fatal(1, "Can't get 'axis_vif_slave' from resource_db!");
        end
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "axis_tdata_width", axis_tdata_width)) begin
            $fatal(1, "Can't get 'axis_tdata_width' from resource_db!");
        end
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "axis_tid_width", axis_tid_width)) begin
            $fatal(1, "Can't get 'axis_tid_width' from resource_db!");
        end
        if(!common_resource_db#(virtual load_intf)::get(
            get_full_name(), "load_vif", load_vif)) begin
            $fatal(1, "Can't get 'load_vif' from resource_db!");
        end
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "load_dec_width", load_dec_width)) begin
            $fatal(1, "Can't get 'load_dec_width' from resource_db!");
        end

        // Получение количества тактов на таймаут.
        void'($value$plusargs("timeout_in_cyles=%0d",
            timeout_in_cyles));

        // Конфигурация агентов.
        config_master_agent();
        config_slave_agent ();
        config_reset_agent ();
        config_load_agent  ();

        // Создание и конфигурация environment.
        env = new("env", this); env.build();

    endfunction

    // Конфигурация агента сброса.
    function void config_reset_agent();
        reset_ag_cfg              = new();
        reset_ag_cfg.vif          = reset_vif;
        reset_ag_cfg.active_level = 0;
        common_resource_db#(reset_agent_cfg_base)::set(
            {get_full_name(), ".env.reset_ag"}, "cfg", reset_ag_cfg);
    endfunction

    // Соединение environment.
    virtual function void connect();
        env.connect();
    endfunction

    // Основная задача запуска.
    // Запускает environment, после
    // чего запускает генерацию воз-
    // действий, ожидание завершения
    // и ожидание таймаута совместно.
    virtual task run();
        fork
            env.run();
        join_none
        fork
            send_stimulus     ();
            wait_for_test_done();
            timeout           ();
        join
    endtask

    //  ---------------------- Важно! -----------------------
    // | Методы ниже являются вспомогательными. Функционал   |
    // | разбит на небольшие блоки, что структурирует код и   |
    // | дает дополнительное удобство при переопределении.   |
    //  ---------------------- Важно! -----------------------

    // Конфигурация master агента.
    virtual function void config_master_agent();
        axis_ag_cfg_master             = new();
        axis_ag_cfg_master.vif         = axis_vif_master;
        axis_ag_cfg_master.tdata_width = axis_tdata_width;
        axis_ag_cfg_master.tid_width   = axis_tid_width;
        axis_ag_cfg_master.is_master   = 1;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".env.axis_ag_master"}, "cfg", axis_ag_cfg_master);
    endfunction

    // Конфигурация slave агента.
    virtual function void config_slave_agent();
        axis_ag_cfg_slave             = new();
        axis_ag_cfg_slave.vif         = axis_vif_slave;
        axis_ag_cfg_slave.tdata_width = axis_tdata_width;
        axis_ag_cfg_slave.tid_width   = axis_tid_width;
        axis_ag_cfg_slave.is_master   = 0;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".env.axis_ag_slave"}, "cfg", axis_ag_cfg_slave);
    endfunction

    // Конфигурация load агента.
    virtual function void config_load_agent();
        load_ag_cfg           = new();
        load_ag_cfg.vif       = load_vif;
        load_ag_cfg.dec_width = load_dec_width;
        common_resource_db#(load_agent_cfg_base)::set(
            {get_full_name(), ".env.load_ag"}, "cfg", load_ag_cfg);
    endfunction

    // Задача непосредственной генерации
    // воздействий из класса test.
    // Создана для структурирования кода.
    virtual task send_stimulus();
        load_dec_t dec;
        run_reset_seq();
        run_load_seq(dec);
        run_axis_seq(dec);
        stimulus_done = 1;
    endtask

    // Задача запуска reset sequence.
    virtual task run_reset_seq();
        reset_sequence_base reset_seq = new();
        reset_seq.start(env.reset_ag.sqr);
    endtask

    // Задача запуска sequence для load.
    virtual task run_load_seq(
        output load_dec_t dec
    );
        load_sequence_base load_seq = get_load_seq();
        load_seq.start(env.load_ag.sqr);
        dec = load_seq.req.dec;
    endtask

    // Задача запуска AXI-Stream sequence.
    // Количество генерируемых транзакций зависит
    // от значения ~dec~, которым был сконфигури-
    // рован дизайн. См. ~send_stimulus()~.
    virtual task run_axis_seq(load_dec_t dec);

        axis_sequence_master axis_seq_master;
        axis_sequence_slave  axis_seq_slave;

        axis_seq_master = new();
        if( !axis_seq_master.randomize() ) begin
            $fatal(1, "Can't rand. 'axis_seq_master'!");
        end

        axis_seq_slave = new();
        axis_seq_slave.tready_mode = AXIS_WAIT;

        // Количество транзакций, которое должен принять
        // slave, зависит от начения ~dec~, которым был
        // сконфигурирован дизайн.
        axis_seq_slave.trans_am = 
            axis_seq_master.trans_am -
            axis_seq_master.trans_am / ({1'b0, dec} + 1);

        expected_trans_am += axis_seq_slave.trans_am;

        fork
            axis_seq_master.start(env.axis_ag_master.sqr);
            axis_seq_slave .start(env.axis_ag_slave .sqr);
        join

    endtask

    // Задача ожидания завершения тестового сценария.
    // Условием завершения является равенство ожидаемого
    // количества проверенных транзакций текущему количес-
    // тву проверенных транзакций.
    virtual task wait_for_test_done();
        wait(stimulus_done);
        wait(env.scb.current_trans_am == expected_trans_am);
        $display("Test was finished! Number of transactions checked: %0d",
            env.scb.current_trans_am);
        $finish();
    endtask

    // Задача таймаута.
    virtual task timeout();
        repeat(timeout_in_cyles)
            @(posedge axis_vif_master.aclk);
        $fatal(1, "Test was finished by timeout!");
    endtask

    // Пользовательская функция, возвращающая
    // sequence типа ~load_sequence_base~ или
    // наследованного от нее (через upcasting).
    virtual function load_sequence_base get_load_seq();
        load_sequence_base seq = new();
        return seq;
    endfunction

endclass

// Тест для проверки корректности работы
// дизайна при генерации сигнала сброса.
// Счетчик ~dec~ и само значение ~dec~
// должно быть сброшено. Дизайн должен
// перестать "пропускать" транзакции.

class axis_decimator_test_reset
    extends axis_decimator_test_base;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Переопредление задачи генерации входных воздействий.
    // Количество транзакций после снятия сброса не должно
    // измениться.
    virtual task send_stimulus();
        load_dec_t dec;
        run_reset_seq();
        run_load_seq(dec);
        run_axis_seq(dec);
        run_reset_seq();
        run_axis_seq(0);
        stimulus_done = 1;
    endtask

endclass

// Тест с множественными конфигурациями.
// Направлен на проверку корректности по-
// ведения дизайна при реконфигурации.

class axis_decimator_test_multiple_config
    extends axis_decimator_test_base;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Запуск множественных sequence.
    virtual task send_stimulus();
        load_dec_t dec;
        run_reset_seq();
        repeat($urandom_range(3, 5)) begin
            run_load_seq(dec);
            run_axis_seq(dec);
        end
        stimulus_done = 1;
    endtask

endclass
