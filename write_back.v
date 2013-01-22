
module write_back(
	//from previous stage
	icode, rA, rB, valE, valM
	//external
	clock, regWrite1, regWrite2, regReg1, regReg2, regValue1, regValue2
);
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
