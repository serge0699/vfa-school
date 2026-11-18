/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс test для запуска loopback AXI-Stream.
// Под loopback подразумевается подключение
// master agent и slave agent к одному интер-
// фейсу. Таким образом agents взаимодейству-
// ют друг с другом. Подобные сценарии приме-
// няются в индустрии для проверки самих
// компонентов верификационного окружения.

//  ---------------- Важно! ---------------
// | Код класса подробно задокументирован. |
// | Читайте комментарии!                  |
//  ---------------- Важно! ---------------

//  ---------------- Важно! ---------------
// | Пример не является верификационным    |
// | окружением в "классическом" понима-   |
// | нии.                                  |
//  ---------------- Важно! ---------------

class axis_test_loopback extends common_test;

    // Указатель на интерфейс AXI-stream.
    // Оба agent подключаются к одному и тому
    // же интерфейсу, поэтому указатель один.
    virtual axis_intf axis_vif_master;

    // Интерфейс сброса.
    virtual reset_intf reset_vif;

    // Ширины шин.
    int unsigned tdata_width;
    int unsigned tid_width;

    // Handle компонентов.
    axis_agent_base      axis_ag_master;
    axis_agent_base      axis_ag_slave;
    reset_agent_base     reset_ag;

    // Конфигурации агентов.
    // В данном тесте два agent, которые
    // будут взаимодействовать друг с дру-
    // гом: master и slave.
    axis_agent_cfg_base  axis_ag_cfg_master;
    axis_agent_cfg_base  axis_ag_cfg_slave;
    reset_agent_cfg_base reset_ag_cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Функция сборки.

    //  ---------------------- Важно! ------------------------
    // | Обратите внимание на доступ к базе ресурсов при      |
    // | помощи ~get_full_name()~. Данная функция возвращает  |
    // | полное иерархическое имя компонента в верификаци-    |
    // | ционном окружении.                                   |
    //  ---------------------- Важно! ------------------------

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
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "tdata_width", tdata_width)) begin
            $fatal(1, "Can't get 'tdata_width' from resource_db!");
        end
        if(!common_resource_db#(int unsigned)::get(
            get_full_name(), "tid_width", tid_width)) begin
            $fatal(1, "Can't get 'tid_width' from resource_db!");
        end

        // Конфигурация и создание master агента.
        config_and_build_master_agent();
        // Конфигурация и создание slave агента.
        config_and_build_slave_agent();
        // Конфигурация и создание агента сброса.
        config_and_build_reset_agent();
    endfunction

    // Конфигурация master агента.
    // Интерфейс и ширины передаются
    // в конфигурацию. Она отправляется в базу
    // ресурсов с именем, специфичным для master.
    // Создается объект агента, конфигурация полу-
    // чается в функции ~build()~ agent.
    function void config_and_build_master_agent();
        axis_ag_cfg_master             = new();
        axis_ag_cfg_master.vif         = axis_vif_master;
        axis_ag_cfg_master.tdata_width = tdata_width;
        axis_ag_cfg_master.tid_width   = tid_width;
        axis_ag_cfg_master.is_master   = 1;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".axis_ag_master"}, "cfg", axis_ag_cfg_master);
        axis_ag_master = new("axis_ag_master", this);
        axis_ag_master.build();
    endfunction

    // Конфигурация slave агента.
    // Аналогично master agent: оба agent под-
    // ключены к одному и тому же интерфейсу.
    function void config_and_build_slave_agent();
        axis_ag_cfg_slave             = new();
        axis_ag_cfg_slave.vif         = axis_vif_master;
        axis_ag_cfg_slave.tdata_width = tdata_width;
        axis_ag_cfg_slave.tid_width   = tid_width;
        axis_ag_cfg_slave.is_master   = 0;
        common_resource_db#(axis_agent_cfg_base)::set(
            {get_full_name(), ".axis_ag_slave"}, "cfg", axis_ag_cfg_slave);
        axis_ag_slave = new("axis_ag_slave", this);
        axis_ag_slave.build();
    endfunction

    // Создание и конфигурация reset агента.
    function void config_and_build_reset_agent();
        reset_ag_cfg              = new();
        reset_ag_cfg.vif          = reset_vif;
        reset_ag_cfg.active_level = 0;
        common_resource_db#(reset_agent_cfg_base)::set(
            {get_full_name(), ".reset_ag"}, "cfg", reset_ag_cfg);
        reset_ag = new("reset_ag", this);
        reset_ag.build();
    endfunction

    // Соединение agents, а также "заглушка" monitor.

    //  ----------------- Важно! ----------------
    // | Данные из monitor в данном тесте никуда |
    // | не отправляются. В тесте какого-либо    |
    // | устройства монитор всегда отправляет    |
    // | данные куда-либо, создание дополнитель- |
    // | ной настройки агента на опциональное    |
    // | отключение монитора не имеет смысла. В  |
    // | данном тесте просто создаются "заглуш-  |
    // | ки" с целью предотвращения записи в не- |
    // | проинициализированный mailbox.          |
    //  ----------------- Важно! ----------------

    virtual function void connect();
        axis_ag_master.connect();
        axis_ag_slave .connect();
        reset_ag      .connect();
        reset_ag.mon.mbx = new();
        axis_ag_master.mon.mbx = new();
        axis_ag_slave. mon.mbx = new();
    endfunction

    // Задача запуска. В данном примере
    // AXI-Stream agents запускаются "друг
    // против друга". Совместно с ними за-
    // пускается agent сигнала сброса.

    //  ----------------- Важно! ----------------
    // | В данном тесте условием завершения яв-  |
    // | ляется завершение всех итераций задачи  |
    // | ~send_stimulus()~, т.к. никакой дизайн  |
    // | не проверяется.                         |
    //  ----------------- Важно! ----------------

    virtual task run();
        fork
            axis_ag_master.run();
            axis_ag_slave .run();
            reset_ag      .run();
        join_none
        send_stimulus();
        $finish();
    endtask

    // Задача непосредственной генерации
    // воздействий из класса test.
    // Создана для структурирования кода.
    virtual task send_stimulus();
        run_reset_seq();
        run_axis_seq ();
    endtask

    // Задача запуска reset sequence.
    virtual task run_reset_seq();
        reset_sequence_base reset_seq = new();
        reset_seq.start(reset_ag.sqr);
    endtask

    // Задача запуска AXI-Stream sequence.
    //  ----------------------------------------------------------
    // | 1. Запустите master и slave на N транзакций. Slave дол- |
    // |    жен ожидать ~tvalid~. Дождитесь завершения обеих     |
    // |    последовательностей при помощи fork-join.            |
    // | 2. Запустите бесконечную slave sequence без ожидания    |
    // |    ~tvalid~ через fork-join_none и конечную master seq- |
    // |    uence. Дождитесь завершения только master.           |
    //  ----------------------------------------------------------

    virtual task run_axis_seq();

        axis_sequence_master axis_seq_master;
        axis_sequence_slave  axis_seq_slave;

        // Конечные master и slave.
        axis_seq_master = new();
        if( !axis_seq_master.randomize() ) begin
            $fatal(1, "Can't rand. 'axis_seq_master'!");
        end

        axis_seq_slave = new();
        axis_seq_slave.tready_mode = AXIS_WAIT;
        axis_seq_slave.trans_am    = axis_seq_master.trans_am;

        // TODO: Параллельно запустите master и slave sequence.
        //       Дождитесь завершения обеих sequence.

        // Конечный master и бесконечный slave.
        axis_seq_master = new();
        if( !axis_seq_master.randomize() ) begin
            $fatal(1, "Can't rand. 'axis_seq_master'!");
        end

        axis_seq_slave = new();
        axis_seq_slave.tready_mode = AXIS_NO_WAIT;
        axis_seq_slave.trans_am    = -1;

        // TODO: Через fork-join_none запустите slave sequence.
        //       Затем запустите master sequence и дождитесь ее.

    endtask

endclass
