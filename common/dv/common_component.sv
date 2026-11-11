/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Родительский класс компонента верификационного окружения.
// Большинство компонентов окружения наследуются от него.
// Содержит методы для сборки, соединения и запуска.
// Методы имеют "пустую" реализацию и являются виртуальными
// для обеспечения полиморфизма.
class common_component;

    // Локальные переменные для хранения имени
    // и полного имени компонента в иерархии.
    local string name;
    local string full_name;

    // Функция для доступа к имени.
    virtual function string get_name();
        return name;
    endfunction

    // Функция для доступа к полному имени.
    virtual function string get_full_name();
        return full_name;
    endfunction

    // Конструктор. Обязательными аргументами являются
    // имя и указатель на родителя. При вызове конструк-
    // тора определяются имя и полное имя компонента.
    // Полное имя компонента ~full_name~ формируется из
    // конкатенации полного имени родительского ком-
    // понента и имени текущего компонента. Таким об-
    // разом, полное имя компонента отражает его положение
    // в иерархии окружения.
    function new(string name, common_component parent);
        this.name = name;
        if( parent == null ) begin
            this.full_name = name;
        end
        else begin
            this.full_name = {parent.get_full_name(), ".", name};
        end
    endfunction

    // Функция сборки компонента.
    virtual function void build(); endfunction

    // Функция соединения компонента.
    virtual function void connect(); endfunction
    
    // Задача запуска компонента.
    virtual task run(); endtask

endclass
