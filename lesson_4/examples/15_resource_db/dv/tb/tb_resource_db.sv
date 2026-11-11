/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`include "common_resource_db.sv"
`include "common_component.sv"
`include "common_scoreboard.sv"
`include "common_test.sv"

module tb_resource_db;
    
    //  ----------------------- TODO ------------------------
    // | Создайте в классе ~my_scoreboard~ поле ~crc_msg~    |
    // | типа logic [15:0]. Переопределите метод родителя    |
    // | ~build()~ получением значения CRC из базы ресурсов. |
    // | При успешном получении выведите значение CRC.       |
    //  ----------------------- TODO ------------------------

    class my_scoreboard extends common_scoreboard;

        logic [15:0] crc_msg;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build();
            if( !common_resource_db#(logic [15:0])::get(
                get_full_name(), "crc", crc_msg) ) begin
                $fatal(1, "Can't get 'crc' from resource_db!");
            end
            $display("Got crc: %4h", crc_msg);
        endfunction
        
    endclass

    //  ----------------------- TODO ------------------------
    // | Создайте в классе ~my_test~ поле ~crc_scb~ типа     |
    // | ~my_scoreboard~. Переопределите метод родителя      |
    // | ~build()~ отправкой значения CRC типа logic [15:0]  |
    // | в базу ресурсов. Также метод ~build()~ должен со-   |
    // | держать вызов ~build()~ для объекта scoreboard.     |
    // | Подумайте, в каком порядке выполнить запись в базу  |
    // | ресурсов и вызвать ~build()~ у scoreboard.          |
    // | Также подумайте, как сформировать ключ, по которому |
    // | scoreboard сможет получить значение CRC.            |
    //  ----------------------- TODO ------------------------

    //  ---------------------- Важно! -----------------------
    // | В данном минимальном примере класс test инкапсули-  |
    // | рует в себе класс scoreboard. Такая структура не    |
    // | является типовой, она создана для воспроизведения   |
    // | минимального примера.                               |
    //  ---------------------- Важно! -----------------------

    class my_test extends common_test;

        my_scoreboard crc_scb;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build();
            crc_scb = new("scb", this);
            common_resource_db#(logic [15:0])::set(
                {get_full_name, ".scb"}, "crc", 16'hFFAA);
            crc_scb.build();
        endfunction

    endclass

    // В процессе ниже создается класс теста и запускается
    // его сборка. В случае успешного выполнения задания
    // scoreboard должен получить из базы ресурсов значение,
    // отправленное туда в test.
    initial begin
        my_test test = new("top", null);
        test.build();
    end

endmodule
