module registers(write1, register1, value1, write2, register2, value2, 
                 readReg1, valueRead1, readReg2, valueRead2);
   input write1;
   input [3:0] register1; 
   input [31:0] value1; 
   input write2; 
   input [3:0] register2; 
   input [31:0] value2; 
	input [3:0] readReg1; 
	output reg [31:0] valueRead1; 
	input [3:0] readReg2; 
	output reg [31:0] valueRead2;
                 
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
	
	always @ (readReg1 or readReg2) begin
		valueRead1 <= regFile[readReg1];
		valueRead2 <= regFile[readReg2];
	end
endmodule
