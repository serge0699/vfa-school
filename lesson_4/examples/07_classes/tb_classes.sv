/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс со статическим полем ~data~.
// Поле будет "общим" для всех объектов
// типа ~base~. Поле принадлежит типу,
// а не объекту. В данном примере поле
// принадлежит типу ~base~.
class base;
    static int data;
endclass

// Доступ к полю ~data~ может быть осуществлен
// через иерархическое обращение к object handle
// или оператор области видимости :: без создания
// объекта.
// Изменение значения статического поля отража-
// ется на всех объектах типа, которому принад-
// лежит это поле.
module tb_classes;

    // Object handles.
    base b1, b2;

    initial begin

        b1 = new();
        b1.data += 1;
        b2 = new();
        b2.data += 1;
        $display("%0d %0d", b1.data, b2.data);
        base::data += 1;
        $display("%0d %0d", b1.data, b2.data);

    end

endmodule
