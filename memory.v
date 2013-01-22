module memory(
	//from previous stage
	icode, rA, rB, valA, valE, valP,
	//external
	clock, read, write, value, access_blocked, 
	//to next stage
	icode_out, rA_out, rB_out, valE_out, valM
);
	
	reg [31:0] handledX;
	
	initial begin
		handledX <= 0;
	end
	
	assign memDest = (icode == 4 || icode == 5 || icode == 'hA || icode == 8) ? valE : valA;
	assign memValue = (icode == 4 || icode == 'hA) ? valA : valP;
	assign readOp = icode == 5 || icode == 'hB || icode == 9;
	assign writeOp = icode == 4 || icode == 'hA || icode == 8;
	assign aligned = memDest % 2 == 0;
	
	always @ (posedge clock) begin
		if (access_blocked) begin
			stall <= 1;
		end
		else begin
			case (handledX)
				0: begin
					if (readOp || writeOp) begin
						stall <= 1;
						adress <= memDest / 2;
						read <= readOp;
						write <= writeOp;		
						
						if (aligned) begin
							value <= memValue[15:0];
							lb <= 1; 
							hb <= 1;
							handledX <= handledX + 2; 
						end
						else begin
							lb <= 1;
							hb <= 0;
							value <= {8'h0, memValue[7:0]};
							handledX <= handledX + 1; 
						end
					end
					else begin
						read <= 0;
						write <= 0;
						stall <= 0;
						//setting output for next stage
					end
				end
				1: begin
					valM[7:0] <= valueRead[15:8];
					address <= address + 1;
					value <= memValue[23:8];
					lb <= 1;
					hb <= 1; 
					handledX <= handledX + 2;
				end
				2: begin
					valM[15:0] <= valueRead[15:0];
					address <= address + 1;
					value <= memValue[31:16];
					handledX <= handledX + 2;
				end
				3: begin
					valM[23:8] <= valueRead[15:0];
					address <= address + 1;
					value <= {8'h0, memValue[31:24]};
					lb <= 1;
					hb <= 0;
					handledX <= handledX + 2;
				end
				4: begin
					stall <= 0;
					valM[31:16] <= valueRead[15:0];
					handledX <= 0;
					//setting output for next stage
					icode_out <= icode;
					rA_out <= rA;
					rB_out <= rB;
					valE_out <= valE;
					
				end
				5: begin
					stall <= 0;
					valM[31:24] <= valueRead[7:0];
					handledX <= 0;
					//setting output for next stage
					icode_out <= icode;
					rA_out <= rA;
					rB_out <= rB;
					valE_out <= valE;
			
				end
			endcase
		end
	end
endmodule
