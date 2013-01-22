module memHandler(read1, addr1, read2, write2, value2, addr2, read3, addr3, blocked1, blocked2);
	always @ (*) begin
		if (read3) begin
			blocked1 <= 1;
			blocked2 <= 1;
			read <= 1;
			write <= 0;
			addr <= addr3;
		end
		else if (read2 || write2) begin
			blocked1 <= 1;
			blocked2 <= 0;
			read <= read2;
			write <= write2;
			value <= value2;
			addr <= addr2;
		end
		else if (read1) begin
			blocked1 <= 0;
			blocked2 <= 0;
			read <= 1;
			write <= 0;
			addr <= addr1;
		end
		else begin
			blocked1 <= 0;
			blocked2 <= 0;
			read <= 0;
			write <= 0;
		end
	end
endmodule
