module fetch();
	initial begin
		handledX <= 0;
		size <= 50;
	end
	
	always @ (posedge clock) begin
		if (read_blocked) begin
			//stall etc
		end
		else begin
			if (handledX < size) begin
				stall <= 1;
			
				case (handledX) 
					0: begin
						read <= 1;
						address <= pc / 2;
						size <= (icode == 0 || icode == 1 || icode == 9) ? 1 :
								  ((icode == 2 || icode == 6 || icode == 'hA || icode == 'hB) ? 2 :
								  ((icode ==  7 || icode == 8) ? 5 : 6));
						aligned <= pc % 2 == 0;
						handledX <= handledX + 2 - (pc % 2);
					end
					1: begin
						inst[7:0] <= valueRead[15:8];
						address <= address + 1;
						handledX <= handledX + 2;
					end
					2: begin
						inst[15:0] <= valueRead[15:0];
						address <= address + 1;
						handledX <= handledX + 2;
					end
					3: begin
						inst[23:8] <= valueRead[15:0];
						address <= address + 1;
						handledX <= handledX + 2;
					end
					4: begin
						inst[31:16] <= valueRead[15:0];
						address <= address + 1;
						handledX <= handledX + 2;
					end
					5: begin
						inst[39:24] <= valueRead[15:0];
						address <= address + 1;
						handledX <= handledX + 2;
					end
				endcase
			end
			else begin
				stall <= 0;
				read <= 0;
				handledX <= 0;
				pc <= pc + size;
				ret_lock <= 1;
				
				case (size)
					1: begin
						if (aligned) begin
							icode <= valueRead[3:0];
							ifun <= valueRead[7:4]; 
						end
						else begin
							icode <= valueRead[11:8];
							ifun <= valueRead[15:12];
						end
					end
					2: begin
						pc <= pc + 2;
						
						if (aligned) begin
							icode <= valueRead[3:0];
							ifun <= valueRead[7:4];
							rA <= valueRead[11:8];
							rB <= valueRead[15:12];
						end
						else begin
							icode <= inst[3:0];
							ifun <= inst[7:4];
							rA <= valueRead[3:0];
							rB <= valueRead[7:4];
						end
					end
					5: begin
						if (aligned) begin
							icode <= inst[3:0];
							ifun <= inst[7:4];
							valC <= {valueRead[7:0], inst[31:8]};
						end
						else begin
							icode <= inst[3:0];
							ifun <= inst[7:4];
							valC <= {valueRead[15:0], inst[23:8]};
						end
					end
					6: begin
						if (aligned) begin
							icode <= inst[3:0];
							ifun <= inst[7:4];
							rA <= inst[11:8];
							rB <= inst[15:12];
							valC <= {valueRead[15:0], inst[31:16]};
						end
						else begin
							icode <= inst[3:0];
							ifun <= inst[7:4];
							rA <= inst[11:8];
							rB <= inst[15:12];
							valC <= {valueRead[7:0], inst[39:16]};
						end
					end
				endcase
			end
		end
	end
endmodule
