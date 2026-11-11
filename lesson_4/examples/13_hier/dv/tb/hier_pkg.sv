/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет компонентов для тестирования создания иерархии.
package hier_pkg;

    `include "common_component.sv"

    //  --------------------- TODO ---------------------
    // | Объявите класс типа ~my_comp_2~, наследованный |
    // | от ~common_component~. Не объявляйте новых     |
    // | полей, добавьте только конструктор.            |
    //  --------------------- TODO ---------------------

    class my_comp_2 extends common_component;

        // Объявление конструктора обязательно, так как
        // конструктор родительского класса содержит аргументы.
        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

    endclass

    //  --------------------- TODO ---------------------
    // | Объявите класс типа ~my_comp_1~, наследованный |
    // | от ~common_component~. Объявите в нем два поля |
    // | типа ~my_comp_2~ с именами ~c2_1~ и ~c2_2~. В  |
    // | функции ~build()~ создайте их и запустите их   |
    // | методы ~build()~.                              |
    //  --------------------- TODO ---------------------
    
    class my_comp_1 extends common_component;

        my_comp_2 c2_1;
        my_comp_2 c2_2;

        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build();
            c2_1 = new("c2_1", this); c2_1.build();
            c2_2 = new("c2_2", this); c2_2.build();
        endfunction

    endclass

    //  --------------------- TODO ---------------------
    // | Объявите класс типа ~my_comp_0~, наследованный |
    // | от ~common_component~. Объявите в нем два поля |
    // | типов ~my_comp_1~ и ~my_comp_2~ с именами ~c1~ |
    // | и ~c2~ соответственно. В функции ~build()~     |
    // | создайте их и запустите их методы ~build()~.   |
    //  --------------------- TODO ---------------------

    class my_comp_0 extends common_component;

        my_comp_1 c1;
        my_comp_2 c2;

        function new(string name, common_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build();
            c1 = new("c1", this); c1.build();
            c2 = new("c2", this); c2.build();
        endfunction

    endclass
    
endpackage
