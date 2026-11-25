/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

typedef logic [`LOAD_MAX_DEC_WIDTH-1:0] load_dec_t;

// Выделение диапазона без знакового расширения.
let load_bitsel_u(vec, hi, lo) =
    unsigned'(vec << ($bits(vec) - 1 - hi))
                  >> ($bits(vec) - 1 - hi + lo);

// Выделение диапазона со знаковым расширением.
let load_bitsel_s(vec, hi, lo) =
    signed'(vec << ($bits(vec) - 1 - hi))
                >>> ($bits(vec) - 1 - hi + lo);
