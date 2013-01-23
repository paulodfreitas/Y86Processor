module mem_interface(CLOCK_50, ADDRESS_R, READ, VALUE, WRITE, LB, HB, ADDRESS_W, VALUE_W, SRAM_ADDR, SRAM_DQ, SRAM_WE_N, SRAM_OE_N, SRAM_CE_N, SRAM_UB_N, SRAM_LB_N);
	input CLOCK_50;
	input [17:0] ADDRESS_R;
	input [17:0] ADDRESS_W;
	input READ;
	input WRITE;
	input [15:0] VALUE_W;
	output  [15:0] VALUE;
	output reg [17:0] SRAM_ADDR;
	inout [15:0] SRAM_DQ;
	
	input LB;
	input HB;
	
	output reg SRAM_WE_N, SRAM_OE_N, SRAM_CE_N, SRAM_UB_N, SRAM_LB_N;
	
	wire [15:0] data_in;
	
	assign SRAM_DQ = (WRITE & ~ READ) ? VALUE_W : 16'bz;
	assign VALUE = SRAM_DQ;
	
	always @ (READ or WRITE) begin	
		if (READ) begin
			SRAM_ADDR <= ADDRESS_R;
			SRAM_WE_N <= 1;
			SRAM_OE_N <= 0;
			SRAM_UB_N <= 0;
			SRAM_LB_N <= 0;
			SRAM_CE_N <= 0;
		end else if (WRITE) begin
			SRAM_ADDR <= ADDRESS_W;
			SRAM_WE_N <= 0;
			SRAM_OE_N <= 1;
			SRAM_UB_N <= ~ HB;
			SRAM_LB_N <= ~ LB; 
			SRAM_CE_N <= 0;
		end else begin
			SRAM_CE_N <= 1;
			SRAM_WE_N <= 1;
			SRAM_OE_N <= 1;
			SRAM_UB_N <= 1;
			SRAM_LB_N <= 1;
			SRAM_CE_N <= 1;	
			SRAM_ADDR <= 0;	
		end
	end
endmodule
