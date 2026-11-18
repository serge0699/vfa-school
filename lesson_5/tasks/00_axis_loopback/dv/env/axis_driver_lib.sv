/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Библиотека классов драйверов для AXI-Stream.

//  ---------------- Важно! ----------------
// | Библиотека подробно задокументирована. |
// | Читайте комментарии к коду!            |
//  ---------------- Важно! ----------------

// Driver для взаимодействия с транзакцией
// типа ~axis_seq_item_base~.

class axis_driver_base extends
    common_driver#(axis_seq_item_base);

    // Конфигурация агента
    axis_agent_cfg_base cfg;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Универсальная для master или slave задача запуска.
    virtual task run();
        // Ожидание активного уровня сброса.
        // Обратите внимание, что в AXI-Stream
        // активный уровень 0.
        wait(cfg.vif.aresetn === 1'b0);
        forever begin
            // Cброс входных сигналов.
            // Обратите внимание, что сброс входных
            // сигналов вынесен в отдельную задачу
            // ~reset()~, которая должна быть пере-
            // определена в master и slave.
            reset();
            // Ожидание неактивного уровня
            // сигнала сброса.
            wait(cfg.vif.aresetn === 1'b1);
            // Fork wrapper для создания от-
            // дельного потока (необходим для
            // ограничения "области действия"
            // disable fork (см. lesson_5/
            // examples/10_disable_fork)).
            fork begin
                fork
                    begin
                        // Ожидание первого фронта
                        // после снятия сигнала сброса
                        // и генерация воздействий.
                        @(posedge cfg.vif.aclk);
                        forever begin
                            // Обратите внимание, что получение
                            // транзакции и генерация на ее осно-
                            // ве входных воздействий вынесена в
                            // отдельную задачу ~get_and_drive()~,
                            // которая должна быть переопределена
                            // в master и slave.
                            get_and_drive();
                        end
                    end
                    // Ожидание активного уровня
                    // сигнала сброса. Происходит
                    // совместно с генерацией вход-
                    // ных воздействий.
                    wait(cfg.vif.aresetn === 1'b0);
                join_any
                // disable fork ниже выполнится при
                // "приходе" активного уровня сиг-
                // нала сброса. После чего процесс
                // генерации входных воздействий
                // будет завершен принудительно и
                // цикл forever "вернется" к началу,
                // произойдет сброс входных сигна-
                // лов через ~reset()~. Генерация
                // входных воздействий начнется
                // заново.
                disable fork;
            end join
        end
    endtask

    // Задача сброса входных сигналов.
    // Функционал отличается для master и slave.
    virtual task reset();
        $fatal(1, "This task must be overriden by driver!");
    endtask

    // Задача получения транзакции и генерации входных
    // воздействий на ее основании. Функционал отличается
    // для master и slave.
    virtual task get_and_drive();
        $fatal(1, "This task must be overriden by driver!");
    endtask

endclass

// Driver master.

class axis_driver_master extends axis_driver_base;

    // Поле для рандомизации случайных
    // данных в ходе задержки между актив-
    // ными уровнями ~tvalid~.
    protected axis_seq_item_base dummy = new();

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Конфигурация для случайных данных между передачами.
    virtual function void build();
        super.build();
        dummy.cfg = cfg;
    endfunction

    // Задача сброса входных сигналов.
    // Согласно спецификации со стороны master
    // сигнал ~tvalid~ должен принять неактив-
    // ный уровень. Остальные сигналы могут
    // оставаться неизменными. См. задачу
    // ~get_and_drive()~.
    virtual task reset();
        cfg.vif.tvalid <= 1'b0;
    endtask

    // Задача получения транзакции и генерации входных
    // воздействий на ее основании.
    virtual task get_and_drive();
        get_next_item(req);
        // Ожидание ~req.delay~ фронтов.
        // Обратите внимание, что специ-
        // фикация не запрещает изменение
        // полезных данных между активными
        // фронтами ~tvalid~. Каждый такт
        // полезные данные рандомизируются.
        // Для рандомизации не используется
        // $urandom(), т.к. ширина шины
        // может быть больше 32. Для рандо-
        // мизации используется так называ-
        // емая dummy-транзакция.
        repeat(req.delay) begin
            @(posedge cfg.vif.aclk);
            void'(dummy.randomize());
            cfg.vif.tdata <= dummy.tdata;
            cfg.vif.tid   <= dummy.tid;
            cfg.vif.tlast <= dummy.tlast;
        end
        // Выставление ~tvalid~ в актив-
        // ный уровень и данных из полученной
        // от sequencer транзакции.
        cfg.vif.tvalid <= 1'b1;
        cfg.vif.tdata  <= req.tdata;
        cfg.vif.tid    <= req.tid;
        cfg.vif.tlast  <= req.tlast;
        // Ожидание ~tready~ для handshake.
        // Согласно спецификации AXI-Stream
        // ~tvalid~ не может быть "снят" до
        // "прихода" ~tready~. Также до при-
        // хода ~tready~ полезные данные (
        // ~tdata~, ~tid~, ~tlast~) не могут
        // менять своего значения.
        do begin
            @(posedge cfg.vif.aclk);
        end
        while(cfg.vif.tready !== 1'b1);
        // Сброс ~tvalid~.
        cfg.vif.tvalid <= 1'b0;
        item_done(req);
    endtask

endclass

// Driver slave.

class axis_driver_slave extends axis_driver_base;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача сброса входных сигналов.
    // Согласно спецификации со стороны slave
    // сигнал ~tready~ может принять любое значение.
    // Выставление в 0 выбрано как осознанное
    // упрощение. Можно добавить настройку
    // в конфигурацию агента при желании.
    virtual task reset();
        cfg.vif.tready <= 1'b0;
    endtask

    // В режиме ожидания запрос завершается после handshake.
    // Без ожидания ~tready~ активен один такт.
    virtual task get_and_drive();
        axis_seq_item_slave slave_req;
        get_next_item(req);
        if( !$cast(slave_req, req) ) begin
            $fatal(1, "Can't cast 'req' to 'axis_seq_item_slave'!");
        end
        case( slave_req.tready_mode )
            AXIS_NO_WAIT: begin
                repeat(slave_req.delay) begin
                    @(posedge cfg.vif.aclk);
                end
                cfg.vif.tready <= 1'b1;
                @(posedge cfg.vif.aclk);
                cfg.vif.tready <= 1'b0;
            end
            AXIS_WAIT: begin
                repeat(slave_req.delay) begin
                    @(posedge cfg.vif.aclk);
                end
                cfg.vif.tready <= 1'b1;
                do begin
                    @(posedge cfg.vif.aclk);
                end
                while( cfg.vif.tvalid !== 1'b1 );
                cfg.vif.tready <= 1'b0;
            end
        endcase
        item_done(req);
    endtask

endclass
