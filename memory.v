module memory(
	stall,
	//from previous stage
	icode, rA, rB, valA, valE, valP,
	//external
	clock, address, read, write, value, access_blocked, hb, lb, valueRead,
	//to next stage
	icode_out, rA_out, rB_out, valE_out, valM,
	//to fetch
	waiting_ret_finished, pc_from_ret
    //for fwd
    , apply_forwarding
);
	
	input [3:0] icode;
	input [3:0] rA;
	input [3:0] rB; 
	input [31:0] valA;
	input [31:0] valE;
	input [31:0] valP;
	
	input clock; 
	output reg read; 
	output reg write; 
	output reg [15:0] value; 
	input access_blocked;
	output reg [31:0] address;
	output reg hb, lb;
	input [15:0] valueRead;
	
	output reg stall;
	
	output reg [3:0] icode_out; 
	output reg [3:0] rA_out;
	output reg [3:0] rB_out;
	output reg [31:0] valE_out; 
	output reg [31:0] valM;

    output reg [1:0] apply_forwarding;	

	output reg waiting_ret_finished;
	output reg [31:0] pc_from_ret;
	
	reg [31:0] handledX;
	wire [31:0] memDest;
	wire [31:0] memValue;
	wire readOp;
	wire writeOp;
	wire aligned;
	
	initial begin
		handledX <= 0;
		waiting_ret_finished <= 0;
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
						address <= memDest / 2;
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
					
					waiting_ret_finished <= icode == 9;
					pc_from_ret <= valM;
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
			
					waiting_ret_finished <= icode == 9;
					pc_from_ret <= valM;
				end
			endcase
		end
    
        
        if(icode == 'hB) begin
            apply_forwarding = 'b11;
        end
        else 
            if(icode == 'h4) begin
                apply_forwarding = 'b10
            end
            else
                if(icode == 'h2
                || icode == 'h3
                || icode == 'h6
                || icode == 'h8
                || icode == 'h9
                || icode == 'hA) begin
                    apply_forwarding = 'b01
                end
                else
                    apply_forwarding = 'b00
                end
            end
        end
	end

endmodule
