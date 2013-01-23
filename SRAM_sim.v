module SRAM_sim(ADDR, DATA, WE_N, OE_N, UB_N, LB_N, CE_N);
input [17:0] ADDR;
inout [15:0] DATA;
input WE_N;
input OE_N;
input UB_N;
input LB_N;
input CE_N;

reg [15:0] MEM [0:262143];

assign DATA[7:0]  = (!CE_N && !OE_N && !LB_N)?Q[7:0]:8'bz;
assign DATA[15:8] = (!CE_N && !OE_N && !UB_N)?Q[15:0]:8'bz;

wire [15:0] Q = MEM[ADDR];

reg [15:0] D;

initial begin
	$readmemh("test",MEM, 0, 7);
end

always @(CE_N or WE_N or UB_N or LB_N or ADDR or DATA or D)
begin
  if (!CE_N && !WE_N)
  begin
    D[15:0] = MEM[ADDR]; 
    if (!UB_N)
    begin
      D[15:8] = DATA[15:8];
    end 
    if (!LB_N)
    begin
      D[7:0] = DATA[7:0];
    end
    MEM[ADDR] = D[15:0];
  end
end
    
endmodule
