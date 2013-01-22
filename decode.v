module decode();
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
	end
endmodule
