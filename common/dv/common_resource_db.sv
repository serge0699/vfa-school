/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс базы ресурсов. Используется для хранения данных
// и обмена этими данными между компонентами окружения.
class common_resource_db #(type T);

    // Ассоциативный массив для хранения элементов.
    // Имеет модификатор ~local~, чтобы исключить
    // возможность модификации извне.
    static local T database [string];

    // Переменная статуса debug. Отслеживание записи
    // и чтения для базы ресурсов можно включить при
    // помощи +common_db_debug.
    static local bit is_debug_enabled =
        $test$plusargs("common_db_debug");

    // Функция записи.
    
    // ------------------------------- Важно! ---------------------------------
    // | Ключ в базе ресурсов формируется при помощи конкатенации              |
    // | ~scope~ и ~name~.                                                     |
    // | Например, для вызова:                                                 |
    // |   > common_resource_db#(virtual load_intf)::set(                      |
    // |   >        "common_test_top.env.load_ag.drv", "vif", load_intf);      |
    // | ключом будет "common_test_top.env.load_ag.drv.vif".                   |
    // | А для:                                                                |
    // |   > common_resource_db#(axis_agent_cfg_base)::set(                    |
    // |   >     {get_full_name(), ".env.ag_master"}, "cfg", ag_cfg_master);   |
    // | ключ будет зависеть от полного имени компонента (иерархии окружения). |
    // ------------------------------- Важно! ---------------------------------

    static function void set(string scope, string name, T data);
        database[{scope, ".", name}] = data;
        if( is_debug_enabled ) begin
            $display("common_resource_db: %s was set: ",
                {scope, ".", name}, data);
        end
    endfunction

    // Функция чтения.

    // ------------------------------- Важно! ---------------------------------
    // | Ключ в базе ресурсов формируется при помощи конкатенации              |
    // | ~scope~ и ~name~. См. пояснение для ~set()~.                          |
    // ------------------------------- Важно! ---------------------------------

    static function bit get(string scope, string name, inout T data);
        if( database.exists({scope, ".", name}) ) begin
            data = database[{scope, ".", name}];
            return 1;
        end
        else begin
            if( is_debug_enabled ) begin
                $warning("common_resource_db: %s lookup failed, content:",
                    {scope, ".", name}); print();
            end
            return 0;
        end
    endfunction

    // Функция вывода содержимого базы ресурсов.
    static function void print();
        foreach(database[scope]) begin
            $display("common_resource_db: %s : ", scope, database[scope]);
        end
    endfunction

endclass
