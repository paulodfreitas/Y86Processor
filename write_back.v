
module write_back(
	//from previous stage
	icode, rA, rB, valE, valM,
	//external
	clock, regWrite1, regWrite2, regReg1, regReg2, regValue1, regValue2
);

	input [3:0] icode; 
	input [3:0] rA; 
	input [3:0] rB;
	input [31:0] valE; 
	input [31:0] valM;

	input clock;
	
	output reg regWrite1;
	output reg regWrite2;
	output reg [3:0] regReg1;
	output reg [3:0] regReg2;
	output reg [31:0] regValue1;
	output reg [31:0] regValue2;

	always @ (posedge clock) begin
		case (icode)
			'h0: begin
				regWrite1 <= 0;
				regWrite2 <= 0;
			end
			'h1: begin
				regWrite1 <= 0;
				regWrite2 <= 0;
			end
			'h2: begin
				regWrite1 <= 1;
				regReg1 <= rB;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'h3: begin
				regWrite1 <= 1;
				regReg1 <= rB;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'h4: begin
				regWrite1 <= 0;
				regWrite2 <= 0;
			end
			'h5: begin
				regWrite1 <= 1;
				regReg1 <= rA;
				regValue1 <= valM;
				
				regWrite2 <= 0;
			end
			'h6: begin
				regWrite1 <= 1;
				regReg1 <= rB;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'h7: begin
				regWrite1 <= 0;
				regWrite2 <= 0;
			end
			'h8: begin
				regWrite1 <= 1;
				regReg1 <= 6;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'h9: begin
				regWrite1 <= 1;
				regReg1 <= 6;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'hA: begin
				regWrite1 <= 1;
				regReg1 <= 6;
				regValue1 <= valE;
				
				regWrite2 <= 0;
			end
			'hB: begin
				regWrite1 <= 1;
				regReg1 <= 6;
				regValue1 <= valE;
				
				regWrite2 <= 1;
				regReg2 <= rA;
				regValue2 <= valM;
			end
		endcase
	end
endmodule
