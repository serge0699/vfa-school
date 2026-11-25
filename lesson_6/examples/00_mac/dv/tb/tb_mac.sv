/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Топ-модуль верификационного окружения
// модуля MAC (Multiply Accumulate).

//  ------------------- Важно! -------------------
// | Данное окружение повторяет окружение из      |
// | lesson_3/examples/10_mac/dv/tb/tb_mac.sv.    |
// | Комментарии, кроме комментариев к модели     |
// | покрытия и тестовым сценариям, удалены с     |
// | целью акцентирования внимания. Для полно-    |
// | го разбора исходного файла обратитесь к      |
// | оригинальному файлу окружения по ссылке,     |
// | указанной выше.                              |
//  ------------------- Важно! -------------------

module tb_mac;

    parameter CLK_PERIOD = 10;

    logic clk_i;
    logic areset_i;

    logic        clken_i;
    logic        load_i;
    logic [ 7:0] dataa_i;
    logic [ 7:0] datab_i;
    logic [15:0] out_o;
    logic        ovfl_o;

    mac DUT (
        .clk_i    ( clk_i    ),
        .areset_i ( areset_i ),
        .clken_i  ( clken_i  ),
        .load_i   ( load_i   ),
        .dataa_i  ( dataa_i  ),
        .datab_i  ( datab_i  ),
        .out_o    ( out_o    ),
        .ovfl_o   ( ovfl_o   )
    );

    initial begin
        clk_i <= 1'b0;
        forever begin
            #(CLK_PERIOD/2) clk_i = ~clk_i;
        end
    end

    initial begin
        areset_i <= 1'b1;
        @(posedge clk_i);
        @(negedge clk_i);
        areset_i = 1'b0;
    end

    typedef struct {
             logic        clken;
        rand logic        load;
        rand logic [ 7:0] dataa;
        rand logic [ 7:0] datab;
        rand logic [15:0] out;
        rand logic        ovfl;
    } packet_s;

    // Модель покрытия.

    //  --------------------------- Важно! -----------------------------
    // | Информация обновляется каждый положительный фронт тактового    |
    // | сигнала ~clk_i~. Особое внимание обратите на условия в iff,    |
    // | которые накладывают дополнительные ограничения на условие сох- |
    // | ранения данных. Например, ~iff( !areset_i )~ определяет, что   |
    // | данные сохраняются только при неактивном уровне сигнала сбро-  |
    // | са.                                                            | 
    //  --------------------------- Важно! -----------------------------

    // Covergroup, информация в которой обновляется каждый положительный
    // фронт тактового сигнала ~clk_i~ (~@(posedge clk_i)~).
    covergroup mac_cg @(posedge clk_i iff !areset_i );

        // Фиксированные значения ~clk_en_i~.
        // Создается 2 раздела покрытия для 0 и 1.
        clken_cp: coverpoint clken_i {
            bins clken_zero = {0};
            bins clken_one  = {1};
        }

        // Фиксированные значения ~load_i~.
        // Создается 2 раздела покрытия для 0 и 1.
        load_cp: coverpoint load_i {
            bins load_zero = {0};
            bins load_one  = {1};
        }

        // Покрытие переходов ~clken_i~.
        // Создается 4 раздела покрытия для
        // переходов 0 => 0, 0 => 1, 1 => 0,
        // 1 = > 1.

        //  ---------------- Важно! ----------------- 
        // | Альтернативно может быть переписано как |
        // | ~bins clken_trans [] = (0, 1 => 0, 1);~ |
        // | Однако автор не рекомендует данный под- |
        // | ход, так как не все симуляторы формиру- |
        // | ют легковоспринимаемые имена массивов   |
        // | разделов с переходами.                  |
        //  ---------------- Важно! -----------------

        clken_trans_cp: coverpoint clken_i {
            bins clken_zero_zero = (0 => 0);
            bins clken_zero_one  = (0 => 1);
            bins clken_one_zero  = (1 => 0);
            bins clken_one_one   = (1 => 1);
        }

        // Покрытие переходов ~load_i~.
        // Создается 4 раздела покрытия для
        // переходов 0 => 0, 0 => 1, 1 => 0,
        // 1 = > 1.
        load_trans_cp: coverpoint load_i {
            bins load_zero_zero = (0 => 0);
            bins load_zero_one  = (0 => 1);
            bins load_one_zero  = (1 => 0);
            bins load_one_one   = (1 => 1);
        }

        // Фиксированные значения ~ovfl_o~.

        //  ---------------------------- Важно! ----------------------------
        // | В данном случае сбор покрытия для сигнала ~ovfl_o~ необходимо  |
        // | осуществлять только если на предыдущем такте сигнал ~clk_en_i~ |
        // | имел активное значение. Ведь согласно спецификации вычисления  |
        // | происходят только при активном уровне ~clk_en_i~.              |
        //  ---------------------------- Важно! ----------------------------

        ovfl_cp: coverpoint ovfl_o iff( $past(clken_i, 1, , @(posedge clk_i)) ) {
            bins ovfl_zero = {0};
            bins ovfl_one  = {1};
        }

        // Покрытие всех сочетаний всех разделов точек
        // ~clken_cp~, ~load_cp~ и всех автоматических
        // разделов переменной ~ovfl_o~ ({0} и {1}).
        clkenXloadXovfl: cross clken_cp, load_cp, ovfl_o;

        // Покрытие "особых" значений ~dataa_i~.
        dataa_special_cp: coverpoint dataa_i iff ( clken_i ) {
            bins dataa_zero           = {0};
            bins dataa_one            = {1};
            bins dataa_max            = {8'hFF};
            bins dataa_non_zero       = {[1:$]};
        }

        // Покрытие интервалов ~dataa_i~.
        // Интервал значений [0:$] = [0:255] подразделяется на
        // 16 подинтервалов, создавая 16 разделов покрытия. Для
        // достижения 100% для coverpoint необходимо "попасть"
        // во все 16 интервалов.
        dataa_intervals_cp: coverpoint dataa_i iff ( clken_i ) {
            bins dataa_intervals [16] = {[0:$]};
        } 

        // Покрытие "особых" значений ~datab_i~.
        datab_special_cp: coverpoint datab_i iff ( clken_i ) {
            bins datab_zero           = {0};
            bins datab_one            = {1};
            bins datab_max            = {8'hFF};
            bins datab_non_zero       = {[1:$]};
        }

        // Покрытие интервалов ~datab_i~.
        // Интервал значений [0:$] = [0:255] подразделяется на
        // 16 подинтервалов, создавая 16 разделов покрытия. Для
        // достижения 100% для coverpoint необходимо "попасть"
        // во все 16 интервалов.
        datab_intervals_cp: coverpoint datab_i iff ( clken_i ) {
            bins datab_intervals [16] = {[0:$]};
        } 

        // Покрытие "особых" значений ~out_o~.
        // См. комментарий к ~ovfl_o~.
        out_special_cp: coverpoint out_o iff ( $past(clken_i, 1, , @(posedge clk_i)) ) {
            bins out_zero           = {0};
            bins out_one            = {1};
            bins out_max            = {16'hFFFF};
            bins out_non_zero       = {[1:$]};
        }

        // Покрытие интервалов значений ~out_o~.
        // См. комментарий к ~ovfl_o~.
        // Интервал значений [0:$] = [0:32768] подразделяется на
        // 16 подинтервалов, создавая 16 разделов покрытия. Для
        // достижения 100% для coverpoint необходимо "попасть"
        // во все 16 интервалов.
        out_intervals_cp: coverpoint out_o iff ( $past(clken_i, 1, , @(posedge clk_i)) ){
            bins out_intervals [32] = {[0:$]};
        } 

        // Покрытие всех сочетаний всех разделов точек
        // ~dataa_special_cp~, ~datab_special_cp~.
        // Создаются разделы:
        // (0,       0), (0,       1), (0,       FF), (0,       [1:255]),
        // (1,       0), (1,       1), (1,       FF), (1,       [1:255]),
        // (FF,      0), (FF,      1), (FF,      FF), (FF,      [1:255]),
        // ([1:255], 0), ([1:255], 1), ([1:255], FF), ([1:255], [1:255])
        dataaXdatab_special: cross dataa_special_cp, datab_special_cp;

        // Покрытие всех сочетаний всех разделов точек
        // ~dataa_intervals_cp~, ~datab_intervals_cp~.
        // Создается 16 * 16 = 256 разделов пересечения
        // всех 16 подинтервалов интервала [0:255] для
        // ~dataa_i~ и ~datab_i~. 
        dataaXdatab_intervals: cross dataa_intervals_cp, datab_intervals_cp;

    endgroup

    // Создание модели покрытия.
    
    //  ---------------- Важно! ----------------
    // | covergroup создается при помощи new(). |
    //  ---------------- Важно! ----------------

    mac_cg cg; initial cg = new();

    typedef struct {
        int gen_pkt_am    = 100;
        int drv_delay_min =   1;
        int drv_delay_max =  10;
    } mac_cfg_s;

    mailbox#(packet_s) gen2drv = new(1);

    mailbox#(packet_s) mon2scb = new();

    task mac_gen_base(mac_cfg_s cfg);
        packet_s p;
        repeat(cfg.gen_pkt_am) begin
            void'(std::randomize(p) with {
                p.dataa dist {
                          0  :/  1,
                        255  :/  4,
                    [ 1 :64] :/ 16,
                    [65:254] :/  8
                };
                p.datab dist {
                          0  :/  1,
                        255  :/  4,
                    [ 1 :64] :/ 16,
                    [65:254] :/  8
                };
            });
            gen2drv.put(p);
        end
    endtask

    task mac_gen_ovfl(mac_cfg_s cfg);
        packet_s p;
        repeat(cfg.gen_pkt_am) begin
            void'(std::randomize(p) with {
                p.dataa dist {
                    [200:255] :/  4,
                    [  1:200] :/  1
                };
                p.datab dist {
                    [200:255] :/  4,
                    [  1:200] :/  1
                };
                p.load dist {
                    1 := 4,
                    0 := 1
                };
            });
            gen2drv.put(p);
        end
    endtask

    task mac_drv(mac_cfg_s cfg);

        packet_s p;

        int unsigned drv_delay;

        wait(areset_i === 1'b1);

        clken_i <= 1'b0;
        load_i  <= 1'b0;
        dataa_i <= 8'b0;
        datab_i <= 8'b0;

        wait(areset_i === 1'b0);

        @(posedge clk_i);

        forever begin
            gen2drv.get(p);
            void'(std::randomize(drv_delay) with {
                drv_delay inside {[cfg.drv_delay_min:cfg.drv_delay_max]};
            });
            repeat(drv_delay) begin
                load_i  <= $urandom();
                dataa_i <= $urandom();
                datab_i <= $urandom();
                @(posedge clk_i);
            end
            clken_i <= 1'b1;
            load_i   <= p.load;
            dataa_i  <= p.dataa;
            datab_i  <= p.datab;
            @(posedge clk_i);
            clken_i <= 1'b0;
        end

    endtask

    task mac_mon();
        
        packet_s p;

        bit clken;

        wait(areset_i === 1'b1);
        wait(areset_i === 1'b0);

        forever begin
            @(posedge clk_i);
            if( clken_i | clken ) begin
                p.clken = clken_i;
                p.load  = load_i;
                p.dataa = dataa_i;
                p.datab = datab_i;
                p.out   = out_o;
                p.ovfl  = ovfl_o;
                mon2scb.put(p);
                clken = clken_i;
            end
        end

    endtask

    task mac_scb();

        int unsigned scb_pkt_am;

        packet_s p_prev, p_cur;

        bit [16:0] ovfl_out;
        bit [15:0] mult;
        bit [16:0] sum;

        mon2scb.get(p_prev);
        forever begin
            mon2scb.get(p_cur);
            if( p_prev.clken ) begin
                mult = p_prev.dataa * p_prev.datab;
                sum  = ovfl_out[15:0] + mult;
                if( p_prev.load ) begin
                    ovfl_out = {1'b0, mult};
                end
                else begin
                    if( ovfl_out[16] ) begin
                        ovfl_out = {1'b1, sum[15:0]};
                    end
                    else begin
                        ovfl_out = sum;
                    end
                end
                if( ovfl_out !== {p_cur.ovfl, p_cur.out} ) begin
                    $error("Invalid {ovfl_o, out_o}! Real: %17b ",
                         {p_cur.ovfl, p_cur.out}, "Expected: %17b", ovfl_out);
                end
                scb_pkt_am = scb_pkt_am + 1'b1; 
            end
            p_prev = p_cur;
        end

    endtask

    // Задачи тестов.

    // Задача базового теста.
    // 1000 пакетов + задержка от 1 до 10 тактов
    // между активными уровнями ~clken_i~.
    task mac_test_base();

        mac_cfg_s cfg;
        cfg.gen_pkt_am = 1000;
        
        fork begin
            fork
                mac_gen_base(cfg);
                mac_drv     (cfg);
                mac_mon     (   );
                mac_scb     (   );
            join_none
            wait( mac_scb.scb_pkt_am == cfg.gen_pkt_am );
            disable fork;
        end join

    endtask

    // Задача теста с небольшими задержками 
    // (относительно базового теста) для
    // сигнала ~clken_i~.
    task mac_test_lowd();

        mac_cfg_s cfg;
        cfg.gen_pkt_am    = 1000;
        cfg.drv_delay_min = 0;
        cfg.drv_delay_max = 2;
        
        fork begin
            fork
                mac_gen_base(cfg);
                mac_drv     (cfg);
                mac_mon     (   );
                mac_scb     (   );
            join_none
            wait( mac_scb.scb_pkt_am == cfg.gen_pkt_am );
            disable fork;
        end join

    endtask

    // Задача теста с увеличенным шансом
    // генерации чисел больше 200 и невоз-
    // можностью генерации нуля. Сигнал
    // ~load_i~ статистически принимает
    // неактивное значение 0 в 4 раза чаще,
    // чем активное значение 1.
    task mac_test_ovfl();

        mac_cfg_s cfg;
        cfg.gen_pkt_am = 1000;
        
        fork begin
            fork
                mac_gen_ovfl(cfg);
                mac_drv     (cfg);
                mac_mon     (   );
                mac_scb     (   );
            join_none
            wait( mac_scb.scb_pkt_am == cfg.gen_pkt_am );
            disable fork;
        end join

    endtask

    `ifndef MAC_TEST
        `define MAC_TEST mac_test_base
    `endif

    initial begin
        `MAC_TEST();
        $finish();
    end

endmodule
