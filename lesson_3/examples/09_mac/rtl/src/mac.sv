/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/
// Модуль MAC (Multiply Accumulate).
// Ширина входных данных: 8.
// Ширина выходных данных: 16.
// Поддержка флага переполнения.
// На выход ~out_o~ при активном уровне (1)
// входа ~load_i~ попадает результат умножения
// ~dataa_i~ и ~datab_i~. В случае неактивного
// уровня ~load_i~ на выход попадает результат
// суммы предыдущего значения ~out_o~ с резуль-
// татом умножения ~dataa_i~ и ~datab_i~. При
// превышении результатом суммы максимального
// значения 2**16-1 формируется флаг переполне-
// ния, на выход попадают младшие 16 бит суммы.
// Флаг переполнения остается выставленным до
// выставления активного уровня на ~load_i~.
// Любая запись в регистры происходит только
// при активном уровне (1) сигнала ~clken_i~.
module mac (
    input  logic        clk_i,
    input  logic        areset_i,
    input  logic        clken_i,
    input  logic        load_i,
	input  logic [ 7:0] dataa_i,
	input  logic [ 7:0] datab_i,
	output logic [15:0] out_o,
	output logic        ovfl_o
);

    // Результат умножения.
	logic [15:0] mult;
	assign mult = dataa_i * datab_i;

	// Результат сложения.
	logic [16:0] sum;
	assign sum = out_o + mult;

	// Уиножение с накоплением или без.
	always @(posedge clk_i or posedge areset_i) begin
		if( areset_i ) begin
			{ovfl_o, out_o} <= 17'b0;
		end else if( clken_i ) begin
			if( load_i ) begin
			    {ovfl_o, out_o} <= {1'b0, mult};
            end else begin
                {ovfl_o, out_o} <= sum;
            end
		end
	end

endmodule
