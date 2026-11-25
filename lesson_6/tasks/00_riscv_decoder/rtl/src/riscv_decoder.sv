/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Модуль декодера RISC-V инструкций.
// Поддерживает инструкции: ADDI, SRLI,
// SRAI, LUI, AUIPC, ADD, SRL, SRA, SUB,
// JAL, JALR, BEQ, BNE.
// При соответствии кода входа ~instr_i~
// на выход соответствующей инструкции
// выставляется логическая 1. Остальные
// выходы в логическом нуле. Если вход
// ~instr_i~ не соответствует ни одной
// из поддерживаемых инструкций, то
// выход ~illegal_o~ равен 1, но если
// соответствие есть, то ~illegal_o~
// равен 0.
module riscv_decoder (
    input  logic [31:0] instr_i,
    output logic        addi_o,
    output logic        slri_o,
    output logic        srai_o,
    output logic        lui_o,
    output logic        auipc_o,
    output logic        add_o,
    output logic        srl_o,
    output logic        sra_o,
    output logic        sub_o,
    output logic        jal_o,
    output logic        jalr_o,
    output logic        beq_o,
    output logic        bne_o,
    output logic        illegal_o
);

    // Части инструкции.

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr_i[ 6: 0];
    assign funct3 = instr_i[14:12];
    assign funct7 = instr_i[31:25];

    // Флаги opcode.

    logic op_imm;
    logic op_lui;
    logic op_auipc;
    logic op_op;  
    logic op_jal;
    logic op_jalr;
    logic op_branch;

    assign op_imm    = ( opcode == 7'b0010011 );
    assign op_lui    = ( opcode == 7'b0110111 );
    assign op_auipc  = ( opcode == 7'b0010111 );
    assign op_op     = ( opcode == 7'b0110011 );
    assign op_jal    = ( opcode == 7'b1101111 );
    assign op_jalr   = ( opcode == 7'b1100111 );
    assign op_branch = ( opcode == 7'b1100011 );

    // Флаги funct3.

    logic funct3_srli;
    logic funct3_srai;
    logic funct3_srl;
    logic funct3_sra;
    logic funct3_bne;

    assign funct3_srli = ( funct3 == 3'b101 );
    assign funct3_srai = ( funct3 == 3'b101 );
    assign funct3_srl  = ( funct3 == 3'b101 );
    assign funct3_sra  = ( funct3 == 3'b101 );
    assign funct3_bne  = ( funct3 == 3'b001 );

    // Флаги funct7.

    logic funct7_bit6;
    
    assign funct7_bit6 = ( funct7 == 7'b0100000 );

    // Флаги инструкций.

    assign addi_o  = op_imm & ~|funct3;
    assign slri_o  = op_imm & funct3_srli & ~|funct7;
    assign srai_o  = op_imm & funct3_srai & funct7_bit6;
    assign lui_o   = op_lui;
    assign auipc_o = op_auipc;
    assign add_o   = op_op & ~|funct3 & ~|funct7;
    assign srl_o   = op_op & funct3_srl & ~|funct7;
    assign sra_o   = op_op & funct3_sra & funct7_bit6;
    assign sub_o   = op_op & ~|funct3 & funct7_bit6;
    assign jal_o   = op_jal;
    assign jalr_o  = op_jalr & ~|funct3;
    assign beq_o   = op_branch & ~|funct3;
    assign bne_o   = op_branch & funct3_bne;

    // Флаг нелегальной инструкции.

    assign illegal_o = ~|{addi_o, slri_o, srai_o, lui_o, auipc_o,
                          add_o,  srl_o,  sra_o,  sub_o, jal_o,
                          jalr_o, beq_o,  bne_o};


endmodule
