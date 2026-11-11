/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Родительский класс sequence.
// Отвечает за генерацию полезных данных на
// тестируемое устройство.
// Класс параметризуется типом данных, которые
// будут в нем генерироваться.
class common_sequence#(type REQ = int);

    // Пользователю предоставляется поле транзакции
    // типа, которым параметризован класс.
    REQ req;

    // Поле, которое указывает на sequencer,
    // на котором в данный момент исполняется
    // sequence. Поле определяется в момент
    // вызова задачи ~start()~ и не может быть
    // изменено извне.
    protected common_sequencer#(REQ) sqr;

    // Задача запуска sequence. В качестве аргумента
    // передается указатель на sequencer, на котором
    // должна исполниться sequence (целевой sequencer).
    // В задаче сначала устанавливается указатель
    // на sequencer ~sqr~, а после запускается задача
    // ~body~, которая должна быть переопределена
    // в наследнике sequence.
    virtual task start(common_sequencer#(REQ) sqr);
        this.sqr = sqr;
        body();
    endtask

    // Задача для старта передачи транзакции от
    // sequence к sequencer. В текущей простей-
    // шей реализации в данной задаче проверяется,
    // что указатель на целевой sequencer проини-
    // циализирован. Если он равен null, симуляция
    // завершается с фатальной ошибкой.
    virtual task start_item(REQ t);
        if( sqr == null ) begin
            $fatal(1, "Illegal call of start_item() with null sequencer!");
        end
    endtask

    // Задача для завершения передачи транзакции
    // от sequence к sequencer. Транзакция от-
    // правляется в sequencer при помощи
    // ~sqr.send_request()~. Далее запускается
    // ожидание обработки транзакции при по-
    // мощи ~sqr.wait_for_item_done~.
    virtual task finish_item(inout REQ t);
        sqr.send_request      (t);
        sqr.wait_for_item_done(t);
    endtask

    //  ------------------ Важно! -------------------
    // | Для каждой транзакции в задаче ~body()~     |
    // | должны быть вызваны сначала ~start_item()~, |
    // | потом ~finish_item()~.                      |
    //  ------------------ Важно! -------------------

    // Задача, в которой генерируются транзакции.
    // Должна быть переопределена наследниками
    // sequence.
    virtual task body(); endtask

endclass
