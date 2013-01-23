module VGA(CLK, ADDRESS, PIXEL, READ, VGA_R, VGA_G, VGA_B, VGA_CLK, VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC);
	input CLK, VGA_CLK;
	input [15:0] PIXEL;
	
	output reg [9:0] VGA_R;
	output reg [9:0] VGA_B;
	output reg [9:0] VGA_G;
	output reg VGA_BLANK, VGA_HS, VGA_VS, VGA_SYNC;

	output reg [17:0] ADDRESS;

	output reg READ;
	
	
	parameter vga_cycles_backporch = 32'd50,
	          vga_cycles_sync = 32'd96,
	          vga_cycles_frontporch = 32'd14,
	          vga_cycles_display = 32'd640,
	          vga_lines_backporch = 32'd33,
	          vga_lines_sync = 32'd2,
	          vga_lines_frontporch = 32'd10,
	          vga_lines_display = 32'd480;
				 		
	parameter cyclesPerLine = vga_cycles_backporch + vga_cycles_sync + vga_cycles_frontporch + vga_cycles_display;
	parameter linesPerFrame = vga_lines_backporch + vga_lines_sync + vga_lines_frontporch + vga_lines_display;

	parameter [17:0] begin_video_memory = 18'h0;

	reg [31:0] counter;
	reg [31:0] lineCounter;
	
	reg lowBits;

	reg display_h;
	reg display_v;

	initial begin
		counter <= vga_cycles_display + vga_cycles_frontporch;
		lineCounter <= -1;
		lowBits <= 0;
		READ <= 0;
		ADDRESS <= begin_video_memory - 18'd1;
	end
	
	reg display;
	
	reg [15:0] PIXEL_AUX;
	
	always @ (posedge VGA_CLK) begin
		VGA_BLANK <= display;
		VGA_HS <= (counter < (vga_cycles_display + vga_cycles_frontporch)) | (counter >= (vga_cycles_display + vga_cycles_frontporch + vga_cycles_sync));
		VGA_VS <= (lineCounter < (vga_lines_display + vga_lines_frontporch)) | (lineCounter >= (vga_lines_display + vga_lines_frontporch + vga_lines_sync));
		VGA_SYNC <= 0;	
		
		if (READ) begin
			PIXEL_AUX = PIXEL;
		end
			
		if (lowBits) begin
			VGA_R <= (PIXEL_AUX[7:6] << 8);
			VGA_G <= (PIXEL_AUX[5:4] << 8);
			VGA_B <= (PIXEL_AUX[3:2] << 8);
		end else begin
			VGA_R <= (PIXEL_AUX[15:14] << 8);
			VGA_G <= (PIXEL_AUX[13:12] << 8);
			VGA_B <= (PIXEL_AUX[11:10] << 8);
		end
	end
	
	always @ (negedge VGA_CLK) begin
		counter = counter + 1;
	
		if (counter == cyclesPerLine) begin
			counter = 0;
			lineCounter = lineCounter + 1;

			if (lineCounter == linesPerFrame) begin
				lineCounter = 0;
				ADDRESS = begin_video_memory - 18'd1;
			end
		end
		
		display_h = counter < vga_cycles_display;
		display_v = lineCounter < vga_lines_display;
		display = display_h & display_v;
		if (display) lowBits = ~lowBits;
		READ = display & lowBits;
		if (READ) ADDRESS = ADDRESS + 18'd1;	
	end
endmodule
