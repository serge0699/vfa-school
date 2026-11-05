/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Данный класс содержит два динамических
// массива: ~offsets~ и ~addrs~.
// Размер массива ~addrs~ ограничен зна-
// чениями 4 и 8 при помощи size(), также
// вероятность рандомизации двух последних
// бит каждого элемента массива в значение
// 2'b00 равна 50%, наравне с остальными
// комбинациями этих двух бит. Перебор
// элементов массива осуществляется при
// помощи foreach. Для массива ~offsets~
// размер всегда равен размеру ~addrs~,
// а также, если последние два бита
// элемента с индексом i в ~addrs~ не
// равны нулю, то элемент ~offsets~ с
// таким же индексом i равен нулю.
class base;

    rand bit [1:0] offsets [];
    rand bit [4:0] addrs   [];

    constraint addrs_c {
        addrs.size() inside {4, 8};
        foreach(addrs[i]) {addrs[i][1:0] dist  {0 :/ 1, [1:3] :/ 1};}
    };

    constraint offsets_c {
        offsets.size() == addrs.size();
        foreach(offsets[i]) {
            if( addrs[i][1:0] ) offsets[i] == 2'b0;
        }
    }

endclass

module tb_classes;

    base b1;

    initial begin
        b1 = new();
        if( !b1.randomize() ) begin
            $fatal(1, "Can't rand. b1!");
        end
        else $display("addrs: %p \n", b1.addrs,
            "offsets: %p", b1.offsets);
    end

endmodule
