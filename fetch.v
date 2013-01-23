module fetch(
	stall,
	//to next stage
	icode, ifun, rA, rB, valC, valP, pred, 
	//external
	clock, address, read, read_blocked, valueRead,
	//from branch prediction
	pred_table, wrong_pred,
	//from "ret" processing
	pc_from_ret, waiting_ret_finished
);

	input clock;
	input [15:0] pred_table;
	input wrong_pred;
	input [31:0] pc_from_ret;
	input waiting_ret_finished;
	
	input read_blocked;
	input [15:0] valueRead;
	
	output reg [31:0] address;
	output reg read;
	
	output reg [3:0] icode; 
	output reg [3:0] ifun; 
	output reg [3:0] rA; 
	output reg [3:0] rB;
	output reg [31:0] valC; 
	output reg [31:0] valP; 
	output reg pred;
	output reg stall;
	
	reg [31:0] handledX;
	reg [31:0] size;
	reg [31:0] pc;
	reg [31:0] otherPC;
	reg waiting_ret;
	reg aligned;
	reg [47:0] inst;

	initial begin
		handledX <= 0;
		size <= 50;
		waiting_ret <= 0;
	end
	
	function branch_pred;
		input [31:0] pc;
		begin
			//the table has an index of 4 bits and a value of 2 bits
			branch_pred = pred_table[pc[3:0] + 5]; 
		end
	endfunction
	
	always @ (posedge clock) begin
		if (wrong_pred) begin
			pc <= otherPC;
		end
	
		if (read_blocked || waiting_ret && ~ waiting_ret_finished) begin
			stall <= 1;
		end
		else begin
			if (waiting_ret) begin
				pc <= pc_from_ret;
				handledX <= 0;
			end
		
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
						handledX <= 2 - (pc % 2);
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
				waiting_ret <= icode == 9; 
				size <= 50;
				
				case (size)
					1: begin
						pc <= pc + 1;
					
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
						
						if (icode == 7) begin
							//jmp
							pred <= branch_pred(pc) || ifun == 0; //if it is a (inconditional) jmp then of course the prediction should be 1 (taken)
							
							if (pred) begin
								pc <= valC;
								otherPC <= pc + 5;
							end 
							else begin
								pc <= pc + 5;
								otherPC <= valC;
							end
						end
						else begin
							//call
							pc <= valC;
						end
					end
					6: begin
						pc <= pc + 6;
						
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
				
				valP <= pc;
			end
		end
	end
endmodule
