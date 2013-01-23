`include "alu.v"

module execute(
	//from previous stage
	icode, ifun, rA, rB, valA, valB, valC, valP, pred,
	//external
	clock, 
	//to next stage
	icode_out, rA_out, rB_out, valA_out, valE, valP_out,
	//to fetch
	wrong_pred
    //to forwarding
    , apply_forwarding
);

	input [3:0] icode;
	input [3:0] ifun; 
	input [3:0] rA; 
	input [3:0] rB;
	input [31:0] valA; 
	input [31:0] valB; 
	input [31:0] valC; 
	input [31:0] valP; 
	input pred;

	input clock;
	
	output reg [3:0] icode_out;
	output reg [3:0] rA_out;
	output reg [3:0] rB_out; 
	output reg [31:0] valA_out; 
	output reg [31:0] valE; 
	output reg [31:0] valP_out;
	output reg wrong_pred;
    output reg apply_forwarding;
	    
	reg Cnd;
	reg [15:0] pred_table;
	reg [15:0] aux_table;
	reg [31:0] op1; 
	reg [31:0] op2; 
	reg [3:0] op; 
	wire [31:0] result;
	wire SF; 
	wire ZF; 
	wire OF;

	//add declaration to ALU

	initial begin
		Cnd <= 0;
        apply_forwarding <= 0;
	end

	always @ (posedge clock) begin
		case (icode)
			2: begin
				op1 <= 0;
				op2 <= valA;
				op <= 0;
                apply_forwarding <= 1;
			end
			3: begin
				op1 <= 0;
				op2 <= valC;
				op <= 0;
                apply_forwarding <= 1;
			end
			4: begin
				op1 <= valB;
				op2 <= valC;
				op <= 0;
                apply_forwarding <= 0;
			end
			5: begin
				op1 <= valB;
				op2 <= valC;
				op <= 0;
                apply_forwarding <= 0;
			end
			6: begin
				op1 <= valB;
				op2 <= valA;
				op <= ifun;
                apply_forwarding <= 1;
			end
			7: begin
				case (ifun)
					0: Cnd <= 1;
					1: Cnd <= (SF ^ OF) || ZF;
					2: Cnd <= SF ^ OF;
					3: Cnd <= ZF;
					4: Cnd <= ~ ZF;
					5: Cnd <= ~ (SF ^ OF);
					6: Cnd <= ~ (SF ^ OF) & ~ ZF;
				endcase
				
				wrong_pred <= pred != Cnd;
				
				if (pred_table[valP[3:0]] == Cnd) begin
					aux_table[valP[3:0]] <= Cnd;
				end
				else begin
					pred_table[valP[3:0]] = aux_table[valP[3:0]];
					aux_table[valP[3:0]] = Cnd;
				end
                apply_forwarding <= 0;
			end
			8: begin
				op1 <= valB;
				op2 <= -4;
				op <= 0;
                apply_forwarding <= 1;
			end
			9: begin
				op1 <= valB;
				op2 <= 4;
				op <= 0;
                apply_forwarding <= 1;
			end
			'hA: begin
				op1 <= valB;
				op2 <= -4;
				op <= 0;
                apply_forwarding <= 1;
			end
			'hB: begin
				op1 <= valB;
				op2 <= 4;
				op <= 0;
                apply_forwarding <= 1;
			end
		endcase
		
		valE <= result;
		icode_out <= icode;
		rA_out <= rA; 
		rB_out <= rB; 
		valA_out <= valA;
		valP_out <= valP;
	end
	
	ALU alu(op1, op2, op, result, SF, ZF, OF);
endmodule
