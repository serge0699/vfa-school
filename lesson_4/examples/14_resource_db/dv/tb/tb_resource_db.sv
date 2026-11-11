/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`include "common_resource_db.sv"

module tb_resource_db;

    `include "checker.svhp"

    initial begin

        string msg;
        int    num;

        wait (sync_q.size() == 1); // Не убирайте данную строку.

        //  ----------------------- TODO ------------------------
        // | Отправьте в базу ресурсов сообщение типа string,    |
        // | в котором будет написано "Hello, Alice!".           |
        // | Ключ для базы ресурсов: "to_alice.hello_from_bob".  |
        //  ----------------------- TODO ------------------------

        common_resource_db#(string)::set(
            "to_alice", "hello_from_bob", "Hello, Alice!");


        //  ----------------------- TODO ------------------------
        // | Получите из базы ресурсов сообщение типа string,   |
        // | ключ для базы ресурсов: "to_bob.hello_from_alice". |
        // | Что в нем написано?                                |
        //  ----------------------- TODO ------------------------

        if( !common_resource_db#(string)::get(
            "to_bob", "hello_from_alice", msg) ) begin
            $fatal(1, "Can't get 'hello_from_alice' from resource_db!");
        end
        $display("hello_from_alice: %s", msg);


        //  ----------------------- TODO ------------------------
        // | Отправьте в базу ресурсов значение типа int, равное |
        // | 128. Ключ для базы ресурсов: "numbers.my_number".   |
        //  ----------------------- TODO ------------------------

        common_resource_db#(int)::set("numbers", "my_number", 128);


        //  ----------------------- TODO ------------------------
        // | Получите из базы ресурсов сообщение типа int, ключ  |
        // | для базы ресурсов: "numbers.my_new_number". Чему    |
        // | равно значение числа?                               |
        //  ----------------------- TODO ------------------------

        if( !common_resource_db#(int)::get(
            "numbers", "my_new_number", num) ) begin
            $fatal(1, "Can't get 'my_new_number' from resource_db!");
        end
        $display("my_new_number: %0d", num);

        void'(sync_q.pop_front()); // Не убирайте данную строку.
        
    end

endmodule
