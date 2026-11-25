/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`timescale 1ns/1ps

// Модуль, содержащий модель покрытия RISC-V декодера.
// Также модуль содержит простейшую constrained-random
// генерацию входных воздействий.

//  --------------------- TODO -----------------------
// | Запустите симуляцию. Оцените, какие входные воз- |
// | действия необходимо добавить для достижения 100% |
// | покрытия. Добавьте их.                           |
//  --------------------- TODO -----------------------

//  --------------------- Важно! ---------------------
// | Модуль содержит такие интересные практики, как   |
// | with item и функции для bins. Внимательно чи-    |
// | тайте комментарии к коду.                        |
//  --------------------- Важно! ---------------------

module tb_riscv_decoder;

    logic [31:0] instr_i;
    logic        addi_o;
    logic        slri_o;
    logic        srai_o;
    logic        lui_o;
    logic        auipc_o;
    logic        add_o;
    logic        srl_o;
    logic        sra_o;
    logic        sub_o;
    logic        jal_o;
    logic        jalr_o;
    logic        beq_o;
    logic        bne_o;
    logic        illegal_o;

    logic [13:0] flags;
    assign flags = {addi_o, slri_o, srai_o, lui_o,  auipc_o, add_o, srl_o,
                    sra_o,  sub_o,  jal_o,  jalr_o, beq_o,   bne_o, illegal_o};

    // Модель покрытия

    // Перечисление opcode.
    // Сделано исключительно для удобства.
    typedef enum logic [6:0] {
        OP_IMM    = 7'b0010011,
        OP_LUI    = 7'b0110111,
        OP_AUIPC  = 7'b0010111,
        OP_OP     = 7'b0110011,
        OP_JAL    = 7'b1101111,
        OP_JALR   = 7'b1100111,
        OP_BRANCH = 7'b1100011
    } riscv_decoder_op_t;

    // Перечисление funct3.
    // Сделано исключительно для удобства.
    typedef enum {
        FUNCT3_000 = 3'b000,
        FUNCT3_001 = 3'b001,
        FUNCT3_101 = 3'b101
    } riscv_decoder_funct3_t;

    // Перечисление funct7.
    // Сделано исключительно для удобства.
    typedef enum {
        FUNCT7_ZERO = 7'b0000000,
        FUNCT7_6BIT = 7'b0100000
    } riscv_decoder_funct7_t;

    // Основная covergroup для портов.
    covergroup riscv_decoder_ports_cg;

        // Покрытие opcode.

        //  --------------------- Важно! ----------------------
        // | Обратите внимание, как неудобно приходится форми- |
        // | ровать раздел ~instr_op_all_other~ для остальных  |
        // | значений opcode. Это известная проблема, которая  |
        // | вероятно, будет решена в следующем стандарте      |
        // | SystemVerilog:                                    |
        // |   https://accellera.mantishub.io/view.php?id=4698 |
        // | На момент текущего стандарта (IEEE Std 1800-2023) |
        // | более "элегантного" решения не существует.        |
        //  --------------------- Важно! ----------------------

        instr_op_cp: coverpoint instr_i[6:0] { 
            bins instr_op_imm           = {OP_IMM   };
            bins instr_op_lui           = {OP_LUI   }; 
            bins instr_op_auipc         = {OP_AUIPC }; 
            bins instr_op_op            = {OP_OP    }; 
            bins instr_op_jal           = {OP_JAL   }; 
            bins instr_op_jalr          = {OP_JALR  }; 
            bins instr_op_branch        = {OP_BRANCH};
            bins instr_op_all_other []  = {    [0:$]} with (
                !(item inside { OP_IMM, OP_LUI,  OP_AUIPC, OP_OP,
                                OP_JAL, OP_JALR, OP_BRANCH })
            );
        }

        // Покрытие funct3.
        // См. комментарий к opcode.
        instr_funct3_cp: coverpoint instr_i[14:12] {
            bins instr_funct3_000          = {FUNCT3_000};
            bins instr_funct3_001          = {FUNCT3_001};
            bins instr_funct3_101          = {FUNCT3_101};
            bins instr_funct3_all_other [] = {     [0:$]} with (
                !(item inside {FUNCT3_000, FUNCT3_001, FUNCT3_101})
            );
        }

        // Покрытие funct7.
        // См. комментарий к opcode.
        instr_funct7_cp: coverpoint instr_i[31:25] {
            bins instr_funct7_zero          = {FUNCT7_ZERO};
            bins instr_funct7_6bit          = {FUNCT7_6BIT};
            bins instr_funct7_all_other []  = {      [0:$]} with (
                !(item inside {FUNCT7_ZERO, FUNCT7_6BIT})
            );
        }

        // Перекрестное покрытие всех разделов opcode, funct3 и funct7.
        // В качестве примера исключен случай, в котором есть только
        // "все остальные элементы", как самый низкоприоритетный для
        // покрытия.
        opXfunct3Xfunct7: cross instr_op_cp, instr_funct3_cp, instr_funct7_cp {
            ignore_bins ignore = binsof(instr_op_cp.instr_op_all_other        ) &&
                                 binsof(instr_funct3_cp.instr_funct3_all_other) &&
                                 binsof(instr_funct7_cp.instr_funct7_all_other);
        }

        // Покрытие шины выходных флагов инструкций.
        instr_flags_cp: coverpoint flags {
            bins valid [] = get_valid_flags();
        }

    endgroup

    // Функция, возврающая очередь всех onehot
    // значений для 14-битной шины. Используется
    // для формирования массива допустимых значений
    // в ~riscv_decoder_ports_cg.instr_flags_cp~.
    typedef logic [13:0] flagsqueue_t [$];
    function flagsqueue_t get_valid_flags();
        flagsqueue_t result;
        for(int i = 0; i < 14; i = i + 1) begin
            result.push_back(1 << i);
        end
        return result;
    endfunction

    // Создание модели покрытия.

    // Покрытие портов.
    riscv_decoder_ports_cg ports_cg;

    // Функция создания всех необходмых для
    // сбора покрытия декодера covergroup.
    function void create_cg();
        ports_cg = new();
    endfunction

    // Функция для сохранения информации в
    // модель покрытия декодера.
    function void sample_cg();
        ports_cg.sample();
    endfunction

    riscv_decoder DUT (
        .instr_i   ( instr_i   ),
        .addi_o    ( addi_o    ),
        .slri_o    ( slri_o    ),
        .srai_o    ( srai_o    ),
        .lui_o     ( lui_o     ),
        .auipc_o   ( auipc_o   ),
        .add_o     ( add_o     ),
        .srl_o     ( srl_o     ),
        .sra_o     ( sra_o     ),
        .sub_o     ( sub_o     ),
        .jal_o     ( jal_o     ),
        .jalr_o    ( jalr_o    ),
        .beq_o     ( beq_o     ),
        .bne_o     ( bne_o     ),
        .illegal_o ( illegal_o )
    );

    initial begin

        // Создание модели покрытия.
        create_cg();

        // Генерация тестовых сценариев.
        repeat(10000) begin

            if( !std::randomize(instr_i) with {
                // Вероятность генерации поддерживаемых opcode
                // больше частоты генерации неподдерживаемых.
                // ~ в 10 раз.
                instr_i[6:0] dist {
                    {OP_IMM, OP_LUI,  OP_AUIPC, OP_OP,
                     OP_JAL, OP_JALR, OP_BRANCH } :/ 10,
                                          [0:127] :/ 1
                };
                // Вероятность генерации поддерживаемых funct3
                // больше частоты генерации неподдерживаемых.
                // ~ в 15 раз.
                instr_i[14:12] dist {
                    {FUNCT3_000,
                     FUNCT3_001,
                     FUNCT3_101} :/ 9,
                           [0:7] :/ 1
                };
                // Вероятность генерации поддерживаемых funct7
                // больше частоты генерации неподдерживаемых.
                // ~ в 10 раз.
                instr_i[31:25] dist {
                    {FUNCT7_ZERO,
                     FUNCT7_6BIT} :/ 10,
                          [0:127] :/ 1
                };
            } ) begin
                $fatal(1, "Can't rand. 'instr_i'!");
            end

            #10;

            // Обновление модели покрытия.
            sample_cg();

        end

        // Завершение.
        $finish();

    end

endmodule
