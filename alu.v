module ALU(A, B, OP, OUT, SF, ZF, OF);
	input [31:0] A, B;
	input [3:0] OP;

	output reg [31:0] OUT;
	output reg SF;
	output reg ZF;
	output reg OF;

	
	parameter
		ADD = 4'd0,
		SUB = 4'd1,
		AND = 4'd2,
		XOR = 4'd3,
		INC = 4'd4,
		DEC = 4'd5,
		NOT = 4'd6,
		OR =  4'd7,
		SHL = 4'd8,
		SHR = 4'd9;

	always @ (A or B or OP) begin
		case (OP)
			ADD: 
				begin 
					OUT = A + B;
					OF = (A[31] == B[31]) &  (A[31] != OUT[31]);
				end 
			SUB: 
				begin
					OUT = A - B;
					OF = (A[31] != B[31]) & (B[31] == OUT[31]);
				end
			AND: OUT = A & B;
			XOR: OUT = A ^ B;
			INC: OUT = A + 1;
			DEC: OUT = A - 1;
			NOT: OUT = ~A;
			OR:  OUT = A | B;
			SHL: OUT = B << A;
			SHR: OUT = B >> A;
		endcase 
	end

	always @ (OUT) begin
		SF <= OUT[31];
		ZF <= OUT == 32'b0;
	end
endmodule
