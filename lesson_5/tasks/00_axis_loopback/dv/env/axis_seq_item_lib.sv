/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс транзакции. Иначе sequence item.
// Транзакция рандомизиуруется в sequence.

//  ----------------------- Важно! ----------------------
// | Обратите внимание на ширину шин транзакции. Так как |
// | объект окружения не привязан ни к какому дизайну,   |
// | то ширины определяются максимально возможными.      |
//  ----------------------- Важно! ----------------------

//  ----------------------- Важно! ----------------------
// | В ходе компиляции define может быть переопределен.  |
//  ----------------------- Важно! ----------------------

class axis_seq_item_base;

    // Конфигурация агента.
    axis_agent_cfg_base cfg;

    // Задержка.
    rand int unsigned delay;

    rand axis_tdata_t tdata;
    rand axis_tid_t   tid;
    rand logic        tlast;

    // Неиспользуемые старшие разряды равны нулю.
    constraint width_c {
        (tdata >> cfg.tdata_width) == '0;
        (tid   >> cfg.tid_width  ) == '0;
    }

    // Данная функция возвращает информацию
    // о полях транзакции в виде отформати-
    // рованной строки. Может использовать-
    // ся, например, в monitor для логирования
    // транзакций (см. axis_monitor_base.sv).
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\ntdata      : %0h", axis_bitsel_u(tdata, cfg.tdata_width - 1, 0))};
        str = {str, $sformatf("\ntid        : %0h", axis_bitsel_u(tid,   cfg.tid_width   - 1, 0))};
        str = {str, $sformatf("\ntlast      : %1b", tlast                                       )};
        return str;
    endfunction

endclass

// Транзакция slave.

class axis_seq_item_slave extends axis_seq_item_base;

    // Режим ожидания.
    rand axis_tready_mode_e tready_mode;

    virtual function string convert2string();
        string str = super.convert2string();
        str = {str, $sformatf("\ntready_mode: %s", tready_mode.name())};
        return str;
    endfunction

endclass
