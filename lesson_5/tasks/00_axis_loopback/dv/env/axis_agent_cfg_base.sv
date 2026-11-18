/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс конфигурации агента. Содержит в себе
// настройку ~is_master~, которая определяет
// тип agent: master (1) или slave (0).

class axis_agent_cfg_base;

    // Интерфейс и ширины шин.
    virtual axis_intf vif;

    int unsigned tdata_width;
    int unsigned tid_width;

    // Роль: master/slave.
    bit is_master;

    // Данная функция возвращает информацию
    // о полях конфигурации в виде отформати-
    // рованной строкию. Может использовать-
    // ся, например, в agent для вывода информа-
    // ции о конфигурации (см. axis_agent_base.sv).
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\n| tdata_width  : %0d", tdata_width)};
        str = {str, $sformatf("\n| tid_width    : %0d", tid_width  )};
        str = {str, $sformatf("\n| is_master    : %1b", is_master  )};
        return str;
    endfunction

endclass
