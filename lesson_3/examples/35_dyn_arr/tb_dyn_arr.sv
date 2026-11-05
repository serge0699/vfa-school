/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль показательной работы
// с динамическим массивом.
module tb_dyn_arr;

    function void arr_info(logic [7:0] arr []);
        $display("size() = %0d: %p",
            arr.size(), arr);
    endfunction

    initial begin
        logic [7:0] arr [];
        // Инициализация.
        arr = new[5];
        // Вывод информации.
        arr_info(arr);
        // Заполнение.
        for(int i = 0; i < arr.size(); i++) begin
            arr[i] = i;
        end
        // Вывод информации.
        arr_info(arr);
        // Деинициализация.
        arr.delete();
        // Вывод информации.
        arr_info(arr);
    end

endmodule
