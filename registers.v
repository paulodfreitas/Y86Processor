module registers(write1, register1, value1, write2, register2, value2, 
                 readReg1, valueRead1, readReg2, valueRead2);
    
    input write1;
    input register1 [3:0];    
    input value1    [31:0];

    input write2;
    input register2 [3:0];    
    input value2    [31:0];

    output  readReg1    [3:0];
    output  valueRead1  [31:0];
    output  readReg2    [3:0];
    output  valueRead2  [31:0];

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
