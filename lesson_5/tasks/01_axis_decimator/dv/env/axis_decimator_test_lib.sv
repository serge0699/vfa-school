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

    //  ---------------------- TODO ----------------------
    // | 1. Создайте конфигурацию агента reset.           |
    // | 2. Назначьте интерфейс и уровень сброса.         |
    // | 3. Передайте конфигурацию через базу ресурсов по |
    // |    полному иерархическому имени агента.          |
    //  ---------------------- TODO ----------------------

    function void config_reset_agent();

        // TODO: Реализация метода.

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

    //  ----------------------- TODO -----------------------
    // | 1. Создайте конфигурацию агента master AXI-Stream. |
    // | 2. Назначьте интерфейс, ширины шин и роль master.  |
    // | 3. Передайте конфигурацию через базу ресурсов по   |
    // |    полному иерархическому имени агента.            |
    //  ----------------------- TODO -----------------------

    virtual function void config_master_agent();

        // TODO: Реализация метода.

    endfunction

    // Конфигурация slave агента.

    //  ---------------------- TODO -----------------------
    // | 1. Создайте конфигурацию агента slave AXI-Stream. |
    // | 2. Назначьте интерфейс, ширины шин и роль slave.  |
    // | 3. Передайте конфигурацию через базу ресурсов по  |
    // |    полному иерархическому имени агента.           |
    //  ---------------------- TODO -----------------------

    virtual function void config_slave_agent();

        // TODO: Реализация метода.

    endfunction

    // Конфигурация load агента.

    //  ---------------------- TODO ----------------------
    // | 1. Создайте конфигурацию агента load.            |
    // | 2. Назначьте интерфейс и ширину ~dec~.           |
    // | 3. Передайте конфигурацию через базу ресурсов по |
    // |    полному иерархическому имени агента.          |
    //  ---------------------- TODO ----------------------

    virtual function void config_load_agent();

        // TODO: Реализация метода.

    endfunction

    // Задача непосредственной генерации
    // воздействий из класса test.
    // Создана для структурирования кода.

    //  --------------------- TODO ----------------------
    // | 1. Выполните сброс.                             |
    // | 2. Загрузите случайный ~dec~.                   |
    // | 3. Запустите передачу AXI-Stream с этим ~dec~.  |
    // | 4. После завершения установите ~stimulus_done~. |
    //  --------------------- TODO ----------------------

    virtual task send_stimulus();

        // TODO: Реализация метода.

    endtask

    // Задача запуска reset sequence.

    //  ----------------------- TODO ------------------------
    // | Создайте локальную reset sequence и запустите ее на |
    // | sequencer агента reset.                             |
    //  ----------------------- TODO ------------------------

    virtual task run_reset_seq();

        // TODO: Реализация метода.

    endtask

    // Задача запуска sequence для load.

    //  ---------------------- TODO -----------------------
    // | 1. Создайте load sequence через ~get_load_seq()~. |
    // | 2. Запустите ее на sequencer агента load.         |
    // | 3. Верните загруженный ~dec~ через выходной       |
    // |    аргумент метода.                               |
    //  ---------------------- TODO -----------------------

    virtual task run_load_seq(
        output load_dec_t dec
    );

        // TODO: Реализация метода.

    endtask

    // Задача запуска AXI-Stream sequence.
    // Количество генерируемых транзакций зависит
    // от значения ~dec~, которым был сконфигури-
    // рован дизайн. См. ~send_stimulus()~.

    //  ---------------------- TODO -----------------------
    // | 1. Создайте и рандомизируйте master sequence.     |
    // | 2. Создайте slave sequence в режиме ~AXIS_WAIT~.  |
    // | 3. По числу входных передач и ~dec~ определите    |
    // |    число ожидаемых выходных транзакций согласно   |
    // |    спецификации.                                  |
    // | 4. Настройте slave на прием этого количества и    |
    // |    обновите ~expected_trans_am~.                  |
    // | 5. Параллельно запустите обе sequence и дождитесь |
    // |    завершения обеих.                              |
    //  ---------------------- TODO -----------------------

    virtual task run_axis_seq(load_dec_t dec);

        // TODO: Реализация метода.

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

    //  ----------------------- TODO ------------------------
    // | 1. Выполните сброс, загрузку ~dec~ и передачу       |
    // |    данных.                                          |
    // | 2. Повторно подайте сброс.                          |
    // | 3. Без новой загрузки запустите передачу с          |
    // |    ожидаемым ~dec = 0~. Выходных транзакций быть не |
    // |    должно.                                          |
    // | 4. После завершения установите ~stimulus_done~.     |
    // |                                                     |
    // | Это проверяется в scoreboard.                       |
    //  ----------------------- TODO ------------------------

    virtual task send_stimulus();

        // TODO: Реализация метода.

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

    //  ----------------------- TODO -----------------------
    // | 1. Выполните начальный сброс.                      |
    // | 2. Повторите загрузку случайного ~dec~ и передачу  |
    // |    AXI-Stream от 3 до 5 раз. Перед новой загрузкой |
    // |    дождитесь завершения предыдущего запуска.       |
    // | 3. После завершения установите ~stimulus_done~.    |
    //  ----------------------- TODO -----------------------

    virtual task send_stimulus();

        // TODO: Реализация метода.

    endtask

endclass
