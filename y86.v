`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
	
`include "memHandler.v"
`include "memInterface.v"
`include "registers.v"
`include "SRAM_sim.v"
`include "forward.v"
//module y86(CLOCK_25, CLOCK_50, SRAM_ADDR, SRAM_DQ, SRAM_WE_N, SRAM_OE_N, SRAM_CE_N, SRAM_UB_N, SRAM_LB_N);
module y86();
	

	wire waiting_ret_finished;
	wire [31:0] pc_from_ret;

	wire [15:0] pred_table;
	
	wire [31:0] address1;
	wire read1;
	
	wire [31:0] address2;
	wire [15:0] value2;
	wire write2;
	wire read2;
	
	wire [15:0] valueRead;
	
	wire [3:0] fetch_icode; 
	wire [3:0] fetch_ifun; 
	wire [3:0] fetch_rA; 
	wire [3:0] fetch_rB;
	wire [31:0] fetch_valC; 
	wire [31:0] fetch_valP; 
	wire fetch_pred;
	
	wire [3:0] decode_icode; 
	wire [3:0] decode_ifun; 
	wire [3:0] decode_rA; 
	wire [3:0] decode_rB; 
	wire [31:0] decode_valA; 
	wire [31:0] decode_valB; 
	wire [31:0] decode_valC; 
	wire [31:0] decode_valP; 
	wire decode_pred;
	
	wire [3:0] exe_icode;
	wire [3:0] exe_rA;
	wire [3:0] exe_rB; 
	wire [31:0] exe_valA; 
	wire [31:0] exe_valE; 
	wire [31:0] exe_valP;
	wire exe_wrong_pred;
	
	wire [3:0] mem_icode; 
	wire [3:0] mem_rA;
	wire [3:0] mem_rB;
	wire [31:0] mem_valE; 
	wire [31:0] mem_valM;
	
	wire wireWrite1;
	wire wireWrite2;
	wire [3:0] wireReg1;
	wire [3:0] wireReg2;
	wire [31:0] wireValue1;
	wire [31:0] wireValue2;
	
	wire [3:0] readReg1; 
	wire [31:0] valueRead1; 
	wire [3:0] readReg2;
	wire [31:0] valueRead2;
	
	wire blocked1;
	wire blocked2;
	wire [31:0] addr;
	wire [15:0] value;
	wire read;
	wire write;
	
	wire [17:0] SRAM_ADDR; 
	wire [15:0] SRAM_DQ; 
	wire WE_N; 
	wire OE_N; 
	wire UB_N; 
	wire LB_N; 
	wire CE_N;
	
	wire [31:0] regValue1;
	wire [31:0] regValue2;
	
	wire [31:0] readValue1;
	wire [31:0] readValue2;
	
	wire [31:0] addr1;
	wire [31:0] addr2;
	wire [31:0] addr3;
	

	wire [3:0] register1;
	wire [3:0] register2;

	wire [17:0] address;
	
	wire fetch_stall;
	wire mem_stall;
	
	wire lb_from_memory, hb_from_memory, lb_to_mi, hb_to_mi;

    wire [31:0] fwd_regAValue;
    wire [31:0] fwd_regBValue;
    wire [1:0]  mem_apply_fwd;
    wire        exe_apply_fwd;

	reg clock_50;

	initial begin
	  $dumpfile("tb.vcd");
	  $dumpvars;
	  $dumpon;
	end

	initial begin
	
		clock_50 <= 0;
	end
	
	always @ (*) begin
		#10 clock_50 = ~clock_50;
	end

	fetch f(
		fetch_stall,
		//to next stage
		fetch_icode, fetch_ifun, fetch_rA, fetch_rB, fetch_valC, fetch_valP, fetch_pred, 
		//external
		CLOCK_50, address1, read1, blocked1, valueRead,
		//from branch prediction
		pred_table, exe_wrong_pred,
		//from ret
		pc_from_ret, waiting_ret_finished
	);
	
	decode d(
		//from previous stage
		fetch_icode, fetch_ifun, fetch_rA, fetch_rB, fetch_valC, fetch_valP, fetch_pred,
		//external
		CLOCK_50, readReg1, readReg2, readValue1, readValue2, 
		//to next stage
		decode_icode, decode_ifun, decode_rA, decode_rB, decode_valA, decode_valB, decode_valC, decode_valP, decode_pred
	);
	
    fwd_2_execute fwd2e(
        //applyMemFwd, mem_regA, mem_regAValue, mem_regB, mem_regBValue, 
        mem_apply_fwd, mem_rA, mem_valM, mem_rB, mem_valE
        //applyEx2Fwd, ex2_regA, ex2_regAValue
        exe_apply_fwd, exe_rB, exe_valE
        //exe_regA, exe_regAValue, exe_regB, exe_regBValue, 
        decode_rA, decode_valA, decode_rB, decode_valB
        //out_regAValue, out_regBValue 
        fwd_regAValue, fwd_regBValue
    );

	execute e(
		//from previous stage
		decode_icode, decode_ifun, decode_rA, decode_rB, fwd_regAValue, fwd_regBValue, decode_valC, decode_valP, decode_pred,
		//external
		CLOCK_50, 
		//to next stage
		exe_icode, exe_rA, exe_rB, exe_valA, exe_valE, exe_valP,
		//to fetch
		exe_wrong_pred
        // flag for fwd
        , exe_apply_fwd
	);
	
	memory m(
		mem_stall,
		//from previous stage
		exe_icode, exe_rA, exe_rB, exe_valA, exe_valE, exe_valP,
		//external
		CLOCK_50, address2, read2, write2, value2, blocked2, lb_from_memory, hb_from_memory, valueRead,
		//to next stage
		mem_icode, mem_rA, mem_rB, mem_valE, mem_valM,
		//to fetch
		waiting_ret_finished, pc_from_ret
        // flag for fwd
        , mem_apply_fwd
	);
	
	write_back wb(
		//from previous stage
		mem_icode, mem_rA, mem_rB, mem_valE, mem_valM,
		//external
		CLOCK_50, wireWrite1, wireWrite2, wireReg1, wireReg2, wireValue1, wireValue2
	);
	
	memHandler mh(read1, addr1, read2, write2, value2, lb_from_memory, hb_from_memory, lb_to_mi, hb_to_mi, addr2, read3, addr3, blocked1, blocked2, addr, value, read, write);
	mem_interface mi(CLOCK_50, address, read, valueRead, write, lb_to_mi, hb_to_mi, address, value, SRAM_ADDR, SRAM_DQ, SRAM_WE_N, SRAM_OE_N, SRAM_CE_N, SRAM_UB_N, SRAM_LB_N);
	registers regs(write1, register1, regValue1, write2, register2, regValue2, 
                 readReg1, valueRead1, readReg2, valueRead2);
	//VGA vga(CLOCK_50, address3, valueRead, read3, VGA_R, VGA_G, VGA_B, CLOCK_25, VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC);
	SRAM_sim sim(SRAM_ADDR, SRAM_DQ, WE_N, OE_N, UB_N, LB_N, CE_N);
endmodule
