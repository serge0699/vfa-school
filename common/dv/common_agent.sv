/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Родительский класс agent верификационного окружения.
// Содержит в себе поле ~is_active~, определяющее пассив-
// ность или активность агента. Также класс содержит
// метод ~get_is_active()~ для получения значения данного
// поля. В методе ~build()~ агент считывает из базы ресур-
// сов значение ~is_active~.
class common_agent extends common_component;

    common_active_passive_e is_active = COMMON_ACTIVE;

    // Объявление конструктора обязательно, так как
    // конструктор родительского класса содержит аргументы.
    function new(string name, common_component parent);
        super.new(name, parent);
    endfunction

    
    //  ---------------------- Важно! -----------------------
    // | Обратите внимание на доступ к базе ресурсов при     |
    // | помощи ~get_full_name()~. Данная функция возвращает |
    // | полное иерархическое имя компонента в верифика-     |
    // | ционном окружении.                                  |
    //  ---------------------- Важно! -----------------------

    virtual function void build();
        void'(common_resource_db#(common_active_passive_e)::get(
            get_full_name(), "is_active", is_active));
    endfunction

    virtual function common_active_passive_e get_is_active();
        return is_active;
    endfunction

endclass
