module execute();
	initial begin
		Cnd <= 0;
	end

	always @ (posedge clock) begin
		case (icode)
			2: begin
				op1 <= 0;
				op2 <= valA;
				op <= 0;
			end
			3: begin
				op1 <= 0;
				op2 <= valC;
				op <= 0;
			end
			4: begin
				op1 <= valB;
				op2 <= valC;
				op <= 0;
			end
			5: begin
				op1 <= valB;
				op2 <= valC;
				op <= 0;
			end
			6: begin
				op1 <= valB;
				op2 <= valA;
				op <= ifun;
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
			end
			8: begin
				op1 <= valB;
				op2 <= -4;
				op <= 0;
			end
			9: begin
				op1 <= valB;
				op2 <= -4;
				op <= 0;
			end
			'hA: begin
				op1 <= valB;
				op2 <= -4;
				op <= 0;
			end
			'hB: begin
				op1 <= valB;
				op2 <= 4;
				op <= 0;
			end
		endcase
		
		valE <= result;
	end
	
	ALU alu();
endmodule
