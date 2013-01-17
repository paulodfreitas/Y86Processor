module registers(write1, register1, value1, write2, register2, value2);
	reg [7:0] regFile [31:0];
	
	always @ (write1) begin
		if (write1) begin
			regFile[register1] <= value1;
		end
	end
	
	always @ (write2) begin
		if (write2) begin
			regFile[register2] <= value2;
		end
	end
endmodule
