/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс, параметризованный типом.
// Параметризация типом похожа на
// шаблоны в C++ и позволяет созда-
// вать универсальные классы.
// Класс параметризован типом ~T~,
// которым, в свою очередь, парамет-
// ризован mailbox. Также тип ~T~
// используется для определения
// типа данных, которые рандомизи-
// руются и отправляются в mailbox.
// Обратите внимание, что класс не
// является универсальным в полной
// мере и при параметризации типом,
// который не может быть исполь-
// зован в std::randomize(), будет
// сгенерирована ошибка компиляции.
class sender#(type T);

    mailbox#(T) mbx;

    virtual task run();
        T data;
        void'(std::randomize(data));
        mbx.put(data);
        $display("Sender put at time %t", $time());
    endtask

endclass

// Данный класс аналогичен классу,
// объявленному выше, но данные
// "забираются" из mailbox, а не
// отправляются в него.
class receiver#(type T);

    mailbox#(T) mbx;

    virtual task run();
        T data;
        mbx.get(data);
        $display("Receiver got at time %t", $time());
    endtask

endclass

`timescale 1ns/1ps

// В примере ниже создаются объекты
// типа sender#(int) и receiver#(int).
// Внутренние mailbox классов парамет-
// ризуются типом int. В mailbox отправляются
// данные типа int; из него извлекаются данные
// того же типа. Классы "общаются" пос-
// редством shared mailbox, на который
// указывают их поля ~mbx~. Shared
// mailbox также параметризован типом
// int.
module tb_classes;

    sender  #(int) sdr;
    receiver#(int) rcv;

    mailbox#(int) mbx;

    initial begin
        #10;
        sdr = new();
        rcv = new();
        mbx = new();
        sdr.mbx = mbx;
        rcv.mbx = mbx;
        fork
            sdr.run();
            rcv.run();
        join
        $finish();
    end

endmodule
