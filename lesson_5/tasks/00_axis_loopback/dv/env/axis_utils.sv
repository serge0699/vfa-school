/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

typedef logic [`AXIS_MAX_TDATA_WIDTH-1:0] axis_tdata_t;
typedef logic [  `AXIS_MAX_TID_WIDTH-1:0] axis_tid_t;

// Режим ответа slave.
typedef enum {
    AXIS_NO_WAIT,
    AXIS_WAIT
} axis_tready_mode_e;

// Выделение диапазона без знакового расширения.
let axis_bitsel_u(vec, hi, lo) =
    unsigned'(vec << ($bits(vec) - 1 - hi))
                  >> ($bits(vec) - 1 - hi + lo);

// Выделение диапазона со знаковым расширением.
let axis_bitsel_s(vec, hi, lo) =
    signed'(vec << ($bits(vec) - 1 - hi))
                >>> ($bits(vec) - 1 - hi + lo);
