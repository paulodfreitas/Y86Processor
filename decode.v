module decode(
	//from previous stage
	icode, ifun, rA, rB, valC, valP, pred,
	//external
	clock, reg1, reg2, value1, value2, 
	//to next stage
	icode_out, ifun_out, rA_out, rB_out, valA, valB, valC_out, valP_out, pred_out
);
	
	input [3:0] icode; 
	input [3:0] ifun; 
	input [3:0] rA; 
	input [3:0] rB; 
	input [31:0] valC; 
	input [31:0] valP; 
	input pred;
	
	input clock;
	 
	output reg [3:0] icode_out; 
	output reg [3:0] ifun_out; 
	output reg [3:0] rA_out; 
	output reg [3:0] rB_out; 
	output reg [31:0] valA; 
	output reg [31:0] valB; 
	output reg [31:0] valC_out; 
	output reg [31:0] valP_out; 
	output reg pred_out;
	
	output reg [3:0] reg1;
	output reg [3:0] reg2;
	input [31:0] value1;
	input [31:0] value2;

	always @ (posedge clock) begin
		if (icode == 'hA || icode == 8 || icode == 9) begin
			reg1 <= rA;
			reg2 <= 6;
		end
		else if (icode == 'hB) begin
			reg1 <= 6;
			reg2 <= 6;
		end
		else begin
			reg1 <= rA;
			reg2 <= rB;
		end
		
		valA <= value1;
		valB <= value2;
		
		icode_out <= icode;
		ifun_out <= ifun; 
		rA_out <= rA; 
		rB_out <= rB;
		valC_out <= valC;
		valP_out <= valP; 
		pred_out <= pred;
	end
endmodule
