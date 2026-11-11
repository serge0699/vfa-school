/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Родительский класс driver верификационного окружения.
// Класс отвечает за взаимодействие с портами тестируемого
// устройства. Обратите внимание, что класс параметризуется
// типом данных, которые он будет получать от sequencer и
// которыми будет оперировать.
class common_driver#(type REQ = int) extends common_component;

    // Пользователю предоставляется поле транзакции
    // типа, которым параметризован класс.
    REQ req;

    // Mailbox для связи с sequencer.
    mailbox#(REQ) drv2sqr;
    mailbox#(REQ) sqr2drv;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    //  -------------------- Важно! ---------------------
    // | Получение транзакции и информирование о ее      |
    // | обработке должны производиться driver при       |
    // | помощи задач ~get_next_item()~ и ~item_done()~  |
    // | соответственно.                                 |
    //  -------------------- Важно! ---------------------

    // Задача для получения транзакции от sequencer.
    // В простейшем варианте реализована через get()
    // из mailbox по направлению от sequencer к driver.
    virtual task get_next_item(output REQ t);
        sqr2drv.get(t);
    endtask
    
    // Задача информирования sequencer о том, что
    // транзакция была обработана. В простейшем
    // варианте реализуется через put() в mailbox
    // по направлению от driver к sequencer. Такой
    // вариант реализации позволяет использовать
    // обратную связь (reactive stimulus).
    virtual task item_done(REQ t);
        drv2sqr.put(t);
    endtask

endclass
