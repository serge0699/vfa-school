/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

module tb_simple;

    import simple_pkg::*;

    // Основной статический процесс, запускающий тест.
    initial begin

        // Создание класса теста.
        automatic simple_test test = new("test_top", null);

        // Сборка, подключение и запуск.

        //  --------------------- Важно! ---------------------
        // | Порядок вызова методов важен. Сначала компоненты |
        // | настраиваются, потом соединяются, потом запуска- |
        // | ются. Иной порядок может привести к ошибкам дос- |
        // | тупа к памяти. Как думаете, почему?              |
        //  --------------------- Важно! ---------------------

        test.build  ();
        test.connect();
        test.run    ();
    end

endmodule
