module memHandler(read1, addr1, read2, write2, value2, lb_in, hb_in, lb_out, hb_out, addr2, read3, addr3, blocked1, blocked2, addr, value, read, write);
	input read1;
	input [31:0] addr1;
	input read2;
	input write2;
	input [15:0] value2;
	input [31:0] addr2;
	input read3;
	input [31:0] addr3;
	
	input lb_in;
	input hb_in;
	
	output reg lb_out;
	output reg hb_out;
	
	output reg blocked1;
	output reg blocked2;
	output reg [31:0] addr;
	output reg [15:0]value;
	output reg read;
	output reg write;

	always @ (*) begin
		if (read3) begin
			blocked1 <= 1;
			blocked2 <= 1;
			read <= 1;
			write <= 0;
			addr <= addr3;
			lb_out <= 1;
			hb_out <= 1;
		end
		else if (read2 || write2) begin
			blocked1 <= 1;
			blocked2 <= 0;
			read <= read2;
			write <= write2;
			value <= value2;
			addr <= addr2;
			lb_out <= lb_in;
			hb_out <= hb_in;
		end
		else if (read1) begin
			blocked1 <= 0;
			blocked2 <= 0;
			read <= 1;
			write <= 0;
			addr <= addr1;
			lb_out <= 1;
			hb_out <= 1;
		end
		else begin
			blocked1 <= 0;
			blocked2 <= 0;
			read <= 0;
			write <= 0;
		end
	end
endmodule
