/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Родительский класс sequencer.
// Отвечает за передачу транзакций от sequence к driver.
// Класс параметризуется типом транзакции, которая будет
// передаваться между sequencer и driver.
class common_sequencer#(type REQ = int) extends common_component;
    
    // Mailbox для связи с driver.
    mailbox#(REQ) sqr2drv;
    mailbox#(REQ) drv2sqr;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    // Задача отправки запроса в driver.
    // Вызывается из sequence через
    // указатель на sequencer ~sqr~.
    // В простейшем случае реализуется
    // через ~put()~ в mailbox по направ-
    // лению sequencer->driver.
    virtual task send_request(REQ t);
        sqr2drv.put(t);
    endtask

    // Задача получения ответа от driver.
    // Вызывается из sequence через
    // указатель на sequencer ~sqr~.
    // В простейшем случае реализуется
    // через ~get()~ из mailbox по направ-
    // лению driver->sequencer.
    virtual task wait_for_item_done(output REQ t);
        drv2sqr.get(t);
    endtask

endclass
