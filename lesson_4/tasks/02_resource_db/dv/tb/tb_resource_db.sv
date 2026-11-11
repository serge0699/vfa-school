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
