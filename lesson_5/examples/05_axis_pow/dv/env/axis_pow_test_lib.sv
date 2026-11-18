/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Базовый тест AXI-Stream модуля возведения в
// степень. Инкапсулирует environment и sequence
// для AXI-Stream и сигнала сброса.

//  --------------------- Важно! ----------------------
// | Класс поддерживает запуск множественных sequence, |
// | таймаут, инициацию сброса через reset sequence.   |
//  --------------------- Важно! ----------------------

class axis_pow_test_base extends common_test;

    // Указатели на интерфейсы.
    virtual axis_intf axis_vif_master;
    virtual axis_intf axis_vif_slave;

    // Интерфейс сброса.
    virtual reset_intf reset_vif;

    // Ширины шин.
    int unsigned tdata_width;
    int unsigned tid_width;

    // Environment.
    axis_pow_env_base env;

    // Конфигурации агентов.
    axis_agent_cfg_base  axis_ag_cfg_master;
    axis_agent_cfg_base  axis_ag_cfg_slave;
    reset_agent_cfg_base reset_ag_cfg;

    // Статусные флаги и настройки.
    protected int          expected_trans_am;
    protected bit          stimulus_done;
    protected int unsigned timeout_in_cyles = 100000;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Инициализация и конфигурация тестового сценария.
    
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
            get_full_name(), "tdata_width", tdata_width)) begin
            $fatal(1, "Can't get 'tdata_width' from resource_db!");
        end
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "tid_width", tid_width)) begin
            $fatal(1, "Can't get 'tid_width' from resource_db!");
        end

        // Получение количества тактов на таймаут.
        void'($value$plusargs("timeout_in_cyles=%0d",
            timeout_in_cyles));

        // Конфигурация агентов.
        config_master_agent();
        config_slave_agent ();
        config_reset_agent ();

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

    // Функция соединения.
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
    // | разбит на небольшие блоки, что структурирует код и  |
    // | дает дополнительное удобство при переопределении.   |
    //  ---------------------- Важно! -----------------------

    // Конфигурация master агента.
    virtual function void config_master_agent();
        axis_ag_cfg_master             = new();
        axis_ag_cfg_master.vif         = axis_vif_master;
        axis_ag_cfg_master.tdata_width = tdata_width;
        axis_ag_cfg_master.tid_width   = tid_width;
        axis_ag_cfg_master.is_master   = 1;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".env.axis_ag_master"}, "cfg", axis_ag_cfg_master);
    endfunction

    // Конфигурация slave агента.
    virtual function void config_slave_agent();
        axis_ag_cfg_slave             = new();
        axis_ag_cfg_slave.vif         = axis_vif_slave;
        axis_ag_cfg_slave.tdata_width = tdata_width;
        axis_ag_cfg_slave.tid_width   = tid_width;
        axis_ag_cfg_slave.is_master   = 0;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".env.axis_ag_slave"}, "cfg", axis_ag_cfg_slave);
    endfunction

    // Задача непосредственной генерации
    // воздействий из класса test.
    // Создана для структурирования кода.
    virtual task send_stimulus();
        run_reset_seq();
        run_axis_seq ();
        stimulus_done = 1;
    endtask

    // Задача запуска reset sequence.
    virtual task run_reset_seq();
        reset_sequence_base reset_seq = new();
        reset_seq.start(env.reset_ag.sqr);
    endtask

    // Задача запуска AXI-Stream sequence.
    // Случайное количество транзакций.
    // Перед запуском обновляется количество
    // ожидаемых к проверке транзакций.
    virtual task run_axis_seq();

        axis_sequence_master axis_seq_master;
        axis_sequence_slave  axis_seq_slave;

        axis_seq_master = new();
        if( !axis_seq_master.randomize() ) begin
            $fatal(1, "Can't rand. 'axis_seq_master'!");
        end
        expected_trans_am += axis_seq_master.trans_am;

        axis_seq_slave = new();
        axis_seq_slave.tready_mode = AXIS_WAIT;
        axis_seq_slave.trans_am    = axis_seq_master.trans_am;
        fork
            axis_seq_master.start(env.axis_ag_master.sqr);
            axis_seq_slave .start(env.axis_ag_slave.sqr);
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

endclass

// Тест с множественным сигналом сброса.
// Направен на проверку корректности сброса конвейера.

class axis_pow_test_multiple_reset
    extends axis_pow_test_base;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Перед сбросом конвейер заполняется без приема на slave.
    virtual task send_stimulus();
        axis_sequence_master axis_seq_master;
        run_reset_seq();
        run_axis_seq ();
        repeat($urandom_range(3, 5)) begin
            axis_seq_master           = new();
            axis_seq_master.trans_am  = 5;
            axis_seq_master.start(env.axis_ag_master.sqr);
            run_reset_seq();
            run_axis_seq ();
        end
        stimulus_done = 1;
    endtask

endclass
