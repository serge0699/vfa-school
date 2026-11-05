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

//  ----------------- Важно! -------------------
// | Данное окружение реализует TBV метод +     |
// | constrained random подход к верификации.   |
// | Условием завершения является равенство     |
// | количества  проверенных пакетов количеству |
// | сгенерированных пакетов.                   |
//  ----------------- Важно! -------------------

//  ----------------- Важно! -------------------
// | Процессы генератора, драйвера, монитора и  |
// | проверки все еще выполняются совместно,    |
// | однако теперь создаются динамически при    |
// | помощи вызова задач и fork-join. Данные    |
// | процессы создаются в единственном стати-   |
// | ческом процессе, который и определяет тес- |
// | товый сценарий.                            |
//  ----------------- Важно! -------------------

//  ----------------- Важно! -------------------
// | Обратите внимание, что в задачи драйвера и |
// | генератора при помощи аргумента передается |
// | специальная структура конфигурации типа    |
// | ~mac_cfg_s~, которая определяет особеннос- |
// | ти их поведения. Например количество сге-  |
// | нерированных пакетов, максимальную и мини- |
// | мальную задержки для управляющих сигналов. |
//  ----------------- Важно! -------------------

module tb_mac;

    // Параметр для периода тактового
    // сигнала.
    parameter CLK_PERIOD = 10;

    // Определение тактового сигнала и
    // сигнала сброса.
    logic clk_i;
    logic areset_i;

    // Определение проводов, которые будут
    // подключены к портам MAC.
    logic        clken_i;
    logic        load_i;
    logic [ 7:0] dataa_i;
    logic [ 7:0] datab_i;
    logic [15:0] out_o;
    logic        ovfl_o;
    
    // Подключение тестируемого модуля.
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

    // Генерация тактового сигнала.
    initial begin
        clk_i <= 1'b0;
        forever begin
            #(CLK_PERIOD/2) clk_i = ~clk_i;
        end
    end

    // Генерация сигнала сброса.
    initial begin
        areset_i <= 1'b1;
        @(posedge clk_i);
        @(negedge clk_i);
        areset_i = 1'b0;
    end

    // Структура, которая будет передаваться
    // между компонентами окружения. Будет служить
    // "контейнером" для отправки данных между
    // генератором и драйвером, а также между
    // монитором и проверкой.
    typedef struct {
             logic        clken;
        rand logic        load;
        rand logic [ 7:0] dataa;
        rand logic [ 7:0] datab;
        rand logic [15:0] out;
        rand logic        ovfl;
    } packet_s;

    // Структура конфигурации тестового сценария.
    // Определяет поведение генератора и драйвера.
    // В конфигурации содержится количество пакетов,
    // а также максимально и минимально возможные
    // задержки между активными уровнями ~clken_i~.
    typedef struct {
        int gen_pkt_am    = 100;
        int drv_delay_min =   1;
        int drv_delay_max =  10;
    } mac_cfg_s;

    // Mailbox между генератором и драйвером.
    mailbox#(packet_s) gen2drv = new(1);

    // Mailbox между монитором и проверкой.
    mailbox#(packet_s) mon2scb = new();

    // Генератор.
    // Данный процесс отвечает за то, КАКИЕ данные
    // будут выставлены на входы тестируемого
    // устройства.

    //  ----------------- Важно! ------------------
    // | Обратите внимание, что теперь это задача, |
    // | аргументом которой является конфигурация. |
    //  ----------------- Важно! ------------------

    //  ----------------- Важно! ------------------
    // | Для генерации различных тестовых воздей-  |
    // | ствий может быть создано несколько версий |
    // | генераторов и драйверов. Например, ниже   |
    // | определено 2 версии генераторов:          |
    // | ~mac_gen_base~ и ~mac_gen_ovfl~. Вторая   |
    // | версия отличается от первой тем, что ста- |
    // | тистически чаще будет генерировать значе- |
    // | ния больше 200 для обеих операндов, при   |
    // | этом ноль генерироваться не будет вообще  |
    //  ----------------- Важно! ------------------

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
                p.load == 1;
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

    // Драйвер.
    // Данный процесс отвечает за то, КАК данные
    // попадут в тестируемое устройство.

    task mac_drv(mac_cfg_s cfg);

        // Переменная пакета.
        packet_s p;

        // Задержка драйвера на выставление
        // активного уровня ~clk_en~ в фронтах
        // тактового сигнала.
        int unsigned drv_delay;

        // Ожидание активного уровня сигнала сброса.
        wait(areset_i === 1'b1);

        // Сброс входных сигналов.
        // Обратите внимание на
        // неблокирующие присваивания.
        clken_i <= 1'b0;
        load_i  <= 1'b0;
        dataa_i <= 8'b0;
        datab_i <= 8'b0;

        // Ожидание неактивного уровня сигнала сброса.
        wait(areset_i === 1'b0);

        // Ожидание первого фронта после сигнала сброса.
        @(posedge clk_i);

        // Получение пакета от генератора и выставление.
        forever begin
            gen2drv.get(p);
            // Рандомизация задержки.
            void'(std::randomize(drv_delay) with {
                drv_delay inside {[cfg.drv_delay_min:cfg.drv_delay_max]};
            });
            // Ожидание ~drv_delay~ фронтов.
            repeat(drv_delay) begin
                load_i  <= $urandom();
                dataa_i <= $urandom();
                datab_i <= $urandom();
                @(posedge clk_i);
            end
            // Выставление ~clken_i~.
            clken_i <= 1'b1;
            // Выставление данных.
            load_i   <= p.load;
            dataa_i  <= p.dataa;
            datab_i  <= p.datab;
            // Ожидание фронта.
            @(posedge clk_i);
            // Сброс ~clken_i~.
            clken_i <= 1'b0;
        end

    endtask

    // Монитор.
    // Поток отвечает за сбор информации об изменении
    // значений на портах устройства во времени.

    task mac_mon();
        
        // Переменная пакета.
        packet_s p;

        // Значение clken_i на предыдущем такте.
        bit clken;

        // Ожидание активного уровня сигнала сброса.
        wait(areset_i === 1'b1);
        // Ожидание неактивного уровня сигнала сброса.
        wait(areset_i === 1'b0);

        // Мониторинг.
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

    // Проверка.
    // Данный процесс отвечает за получение информации
    // от монитора и проверки соответствия работы
    // тестируемого устройства спецификации.

    task mac_scb();

        // Количество проверенных пакетов.
        int unsigned scb_pkt_am;

        // Пакет с предыдущего такта ~p_prev~ и пакет с
        // текущего такта ~p_cur~.
        packet_s p_prev, p_cur;

        // Переменная эталонного значения
        bit [16:0] ovfl_out;

        // Результат умножения.
        bit [15:0] mult;

        // Результат суммы.
        bit [16:0] sum;

        // Получаем пакет.
        mon2scb.get(p_prev);
        forever begin
            // Получаем еще 1 пакет.
            // Теперь в переменной ~p_cur~ содержится
            // пакет текущего такта, а в переменной
            // ~p_prev~ пакет с прошлого такта.
            mon2scb.get(p_cur);
            // Далее идет формирование эталонного значения.
            // Шаги формирования помечены *.
            if( p_prev.clken ) begin
                // * Результат умножения.
                mult = p_prev.dataa * p_prev.datab;
                // * Результат суммы. Складываем только
                //   младшие 15 бит выхода, т.к. страший
                //   отвечает за переполнение.
                sum  = ovfl_out[15:0] + mult;
                // * Если была загрузка, то записываем
                //   только результат умножения.
                if( p_prev.load ) begin
                    ovfl_out = {1'b0, mult};
                end
                // * Если нет, то если было переполнение -
                //   сохраняем его флаг и младшие 15 бит.
                //   суммы. Если переполнения не было, то
                //   сохраняем полный результат суммы,
                //   чтобы отследить возможное переполнение.
                else begin
                    if( ovfl_out[16] ) begin
                        ovfl_out = {1'b1, sum[15:0]};
                    end
                    else begin
                        ovfl_out = sum;
                    end
                end
                // Сравниваем эталонное значение со значением
                // со входов текущего такта.
                if( ovfl_out !== {p_cur.ovfl, p_cur.out} ) begin
                    $error("Invalid {ovfl_o, out_o}! Real: %17b ",
                         {p_cur.ovfl, p_cur.out}, "Expected: %17b", ovfl_out);
                end
                // Инкремент счетчика проверенных пакетов.
                scb_pkt_am = scb_pkt_am + 1'b1; 
            end
            // Текущий пакет становится предыдущим.
            p_prev = p_cur;
        end

    endtask

    // Задачи тестов.
    // Запускают совместное выполнение
    // компонентов окружения при помощи
    // создания динамических процессов.

    //  -------------------- Важно! -------------------
    // | Ниже представлено несколько вариаций тестовых |
    // | сценариев, в которых отличаются конфигурации  |
    // | и процессы генерации.                         |
    //  -------------------- Важно! -------------------
    
    // Задача базового теста.
    // 1000 пакетов + задержка от 1 до 10 тактов
    // между активными уровнями ~clken_i~. Сигнал
    // ~load_i~ всегда в активном уровне.
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

    //  ------------------ Важно! ------------------
    // | Тестовый сценарий определяется через аргу- |
    // | мент командной строки. Для получения аргу- |
    // | ментов командной строки в SystemVerilog    |
    // | предусмотрена особвая системная функция    |
    // | $value$plusargs().                         |
    //  ------------------ Важно! ------------------

    // Основной статический процесс, запускающий тест.
    initial begin
        string mac_test;
        void'($value$plusargs("mac_test=%s", mac_test));
        case(mac_test)
            "mac_test_base": mac_test_base();
            "mac_test_lowd": mac_test_lowd();
            "mac_test_ovfl": mac_test_ovfl();
            default: $fatal(1, "Please provide valid test via +mac_test=");
        endcase
        $finish();
    end

endmodule
