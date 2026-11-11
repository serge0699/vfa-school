/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет простейшего верификационного окружения,
// состоящего из sequence, sequencer, driver,
// agent и test. 

//  --------------------- Важно! ---------------------
// | В окружении нет monitor (в agent не объявлено    |
// | соответствующее поле). Это не является common    |
// | practice, отсутствие монитора сводит практичес-  |
// | кий смысл к нулю. Сам пример показательный и не  |
// | имеет отношения к реальным верификационным окру- |
// | жениям. Рассматривается как пример взаимодейст-  |
// | вия sequence-driver-sequencer.                   |
//  --------------------- Важно! ---------------------

package simple_pkg;

    // Импорт базовых компонентов.
    import common_pkg::*;

    // Sequencer может быть определен без дополнительного
    // функционала. Взаимодействует с типом string.
    typedef common_sequencer#(string) simple_sequencer;

    // Sequence для генерации транзакций типа string.
    class simple_seq extends common_sequence#(string);

        // В задаче ~body()~ генерируются полезные данные.
        // Обратите внимание, что транзакция формируется
        // между ~start_item(req)~ и ~finish_item(req)~.
        // Для формирования транзакции используется встро-
        // енное поле транзакции ~req~ класса ~common_sequence~.

        //  -------------------- Важно! --------------------
        // | Sequence получает обратную связь от sequencer  |
        // | через ~finish_item()~. Sequencer же получает   |
        // | обратную связь от драйвера. Таким образом, но- |
        // | вые входные воздействия могут зависеть от ре-  |
        // | акции тестируемого дизайна на старые. Такая    |
        // | техника называется reactive stimulus.          |
        //  -------------------- Важно! --------------------

        virtual task body();
            start_item(req);
            req = "Hello from sequence!";
            $display("Sequence start req: %s", req);
            finish_item(req);
            $display("Sequence end req: %s", req);
        endtask

    endclass

    // Driver для взаимодействия с транзакциями типа string.
    class simple_driver extends common_driver#(string);

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        // Основная работа драйвера производится в задаче
        // ~run()~, которую он наследует от ~common_component~
        // и переопределяет.

        //  -------------------- Важно! --------------------
        // | В данном примере отсутствует верифицируемый    |
        // | дизайн, так что драйвер просто возвращает об-  |
        // | ратно sequencer другую строку.                 |
        //  -------------------- Важно! --------------------

        // Для получения транзакции используется встроенное
        // поле транзакции ~req~ класса ~common_driver~.

        virtual task run();
            forever begin
                get_next_item(req);
                $display("Driver start req: %s", req);
                req = "Hello from driver!";
                $display("Driver end req: %s", req);
                item_done(req);
            end
        endtask

    endclass

    // Простейший класс агента. Инкапсулирует
    // sequencer и driver. Создает, соединяет
    // и запускает их.
    class simple_agent extends common_component;

        simple_sequencer sqr;
        simple_driver    drv;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build();
            sqr = new("sqr", this); sqr.build();
            drv = new("drv", this); drv.build();
        endfunction

        // Обратите внимание на типовое соединение
        // sequencer и driver.
        // В sequencer создаются mailbox. Их дескрипторы
        // присваиваются соответствующим полям driver.
        // Таким образом, каждая пара дескрипторов
        // ссылается на один объект mailbox в памяти.
        virtual function void connect();
            sqr.sqr2drv = new();
            sqr.drv2sqr = new();
            drv.sqr2drv = sqr.sqr2drv;
            drv.drv2sqr = sqr.drv2sqr;
        endfunction

        virtual task run();
            fork
                drv.run();
                sqr.run();
            join
        endtask

    endclass

    // Класс test. Инкапсулирует agent и sequence.
    // Запускает несколько sequence на sequencer.
    class simple_test extends common_component;
    
        simple_agent ag;
        simple_seq   seq;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction
    
        virtual function void build();
            ag = new("ag", this); ag.build();
        endfunction
    
        virtual function void connect();
            ag.connect();
        endfunction
    
        // Агент запускается, далее на
        // sequencer стартуют sequence
        // при помощи ~seq.start(ag.sqr)~.
        virtual task run();
            fork
                ag.run();
            join_none
            seq = new();
            seq.start(ag.sqr);
            seq = new();
            seq.start(ag.sqr);
            $finish();
        endtask
    
    endclass

endpackage
