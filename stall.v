module stall_instr(curr_icode, stall, clock);

    input [3:0] curr_icode;
    input       clock;

    output reg  stall;

    reg [3:0] last_icode;

    initial begin
        last_icode <= 'h0;
    end
    
    always @ (posedge clock) begin
        if (( last_icode == 'hB || last_icode == 'h5)
          && (curr_icode == 'h2 || curr_icode == 'h4 || curr_icode == 'h6 || curr_icode == 'hA)
        ) begin
            stall <= 1;
        end
        else
            stall <= 0;
        end
    end

    always @ (negedge clock) begin
        last_icode <= cur_icode;
    end
endmodule;

module stall_rdy(
    in_fetch, in_decode, in_execute, in_memory, in_wb,
    out_fetch, out_decode, out_execute, out_memory, out_wb,
    clock    
);

    input in_wb;
    input in_memory;
    input in_execute;
    input in_decode;
    input in_fetch;

    output out_wb;
    output out_memory;
    output out_execute;
    output out_decode;
    output out_fetch;

    input clock;
    
    always @(negedge clock) begin        
        out_wb      <= in_wb;
        out_memory  <= in_wb || in_memory;
        out_execute <= in_wb || in_memory || in_execute;
        out_decode  <= in_wb || in_memory || in_execute || in_decode;
        out_fetch   <= in_wb || in_memory || in_execute || in_decode || in_fetch;
    end
endmodule   

module stall_fetch();

endmodule;

module stall_decode(
	icode, ifun, rA, rB, valC, valP, pred,
    out_icode, out_ifun, out_rA, out_rB, out_valC, out_valP, out_pred,
    stall, clock
);
    
    input           stall;
    input           clock;

    input [3:0]     icode;
    input [3:0]     ifun;
    input [3:0]     rA;
    input [3:0]     rB;
    input [31:0]    valC;
    input [31:0]    valP;
    input           pred;

    output reg [3:0]     out_icode;
    output reg [3:0]     out_ifun;
    output reg [3:0]     out_rA;
    output reg [3:0]     out_rB;
    output reg [31:0]    out_valC;
    output reg [31:0]    out_valP;
    output reg           out_pred;

    reg [3:0]     old_icode;
    reg [3:0]     old_ifun;
    reg [3:0]     old_rA;
    reg [3:0]     old_rB;
    reg [31:0]    old_valC;
    reg [31:0]    old_valP;
    reg           old_pred;
    
    always @(negedge clock) begin
        if (stall) begin
            out_icode   <= old_icode;
            out_ifun    <= old_ifun;
            out_rA      <= old_rA;
            out_rB      <= old_rB;
            out_valC    <= old_valC;
            out_valP    <= old_valP;
        end 
        else
            out_icode   <= icode;
            out_ifun    <= ifun;
            out_rA      <= rA;
            out_rB      <= rB;
            out_valC    <= valC;
            out_valP    <= valP;

            old_icode   <= icode;
            old_ifun    <= ifun;
            old_rA      <= rA;
            old_rB      <= rB;
            old_valC    <= valC;
            old_valP    <= valP;
        end
    end

endmodule;

module stall_execute(
	icode, ifun, rA, rB, valA, valB, valC, valP, pred,
	out_icode, out_ifun, out_rA, out_rB, out_valA, out_valB, out_valC, out_valP, out_pred,
    clock, stall
);
    
    input           stall;
    input           clock;

    input [3:0]     icode;
    input [3:0]     ifun;
    input [3:0]     rA;
    input [3:0]     rB;
    input [31:0]    valA;
    input [31:0]    valB;
    input [31:0]    valC;
    input [31:0]    valP;
    input           pred;

    output reg [3:0]     out_icode;
    output reg [3:0]     out_ifun;
    output reg [3:0]     out_rA;
    output reg [3:0]     out_rB;
    output reg [31:0]    out_valA;
    output reg [31:0]    out_valB;
    output reg [31:0]    out_valC;
    output reg [31:0]    out_valP;
    output reg           out_pred;

    reg [3:0]     old_icode;
    reg [3:0]     old_ifun;
    reg [3:0]     old_rA;
    reg [3:0]     old_rB;
    reg [31:0]    old_valA;
    reg [31:0]    old_valB;
    reg [31:0]    old_valC;
    reg [31:0]    old_valP;
    reg           old_pred;

    always @(negedge clock) begin
        if (stall) begin
            out_icode   <= old_icode;
            out_ifun    <= old_ifun;
            out_rA      <= old_rA;
            out_rB      <= old_rB;
            out_valA    <= old_valA;
            out_valB    <= old_valB;
            out_valC    <= old_valC;
            out_valP    <= old_valP;
            out_pred    <= old_pred;
        end 
        else
            out_icode   <= icode;
            out_ifun    <= ifun;
            out_rA      <= rA;
            out_rB      <= rB;
            out_valA    <= valA;
            out_valB    <= valB;
            out_valC    <= valC;
            out_valP    <= valP;
            out_pred    <= pred;

            old_icode   <= icode;
            old_ifun    <= ifun;
            old_rA      <= rA;
            old_rB      <= rB;
            old_valA    <= valA;
            old_valB    <= valB;
            old_valC    <= valC;
            old_valP    <= valP;
            old_pred    <= pred;
        end
    end
endmodule;

module stall_memory(
	icode, rA, rB, valA, valE, valP,
    out_icode, out_rA, out_rB, out_valA, out_valE, out_valP,
    clock, stall 
);
    
    input           stall;
    input           clock;

    input [3:0]     icode;
    input [3:0]     rA;
    input [3:0]     rB;
    input [31:0]    valA;
    input [31:0]    valE;
    input [31:0]    valP;

    output reg [3:0]     out_icode;
    output reg [3:0]     out_rA;
    output reg [3:0]     out_rB;
    output reg [31:0]    out_valA;
    output reg [31:0]    out_valE;
    output reg [31:0]    out_valP;

    reg [3:0]     old_icode;
    reg [3:0]     old_rA;
    reg [3:0]     old_rB;
    reg [31:0]    old_valA;
    reg [31:0]    old_valE;
    reg [31:0]    old_valP;
    
    always @(negedge clock) begin
        if (stall) begin
            out_icode   <= old_icode;
            out_rA      <= old_rA;
            out_rB      <= old_rB;
            out_valA    <= old_valA;
            out_valE    <= old_valE;
            out_valP    <= old_valP;
        end 
        else
            out_icode   <= icode;
            out_rA      <= rA;
            out_rB      <= rB;
            out_valA    <= valA;
            out_valE    <= valE;
            out_valP    <= valP;

            old_icode   <= icode;
            old_rA      <= rA;
            old_rB      <= rB;
            old_valA    <= valA;
            old_valE    <= valE;
            old_valP    <= valP;
        end
    end
endmodule;

module stall_writeback(
	icode, rA, rB, valE, valM,
	out_icode, out_rA, out_rB, out_valE, out_valM,
    stall, clock
);    

    input           stall;
    input           clock;

    input [3:0]     icode;
    input [3:0]     rA;
    input [3:0]     rB;
    input [31:0]    valE;
    input [31:0]    valM;

    output reg [3:0]     out_icode;
    output reg [3:0]     out_rA;
    output reg [3:0]     out_rB;
    output reg [31:0]    out_valE;
    output reg [31:0]    out_valM;

    reg [3:0]     old_icode;
    reg [3:0]     old_rA;
    reg [3:0]     old_rB;
    reg [31:0]    old_valE;
    reg [31:0]    old_valM;
    
    always @(negedge clock) begin
        if (stall) begin
            out_icode   <= old_icode;
            out_rA      <= old_rA;
            out_rB      <= old_rB;
            out_valE    <= old_valE;
            out_valM    <= old_valM;
        end 
        else
            out_icode   <= icode;
            out_rA      <= rA;
            out_rB      <= rB;
            out_valE    <= valE;
            out_valM    <= valM;

            old_icode   <= icode;
            old_rA      <= rA;
            old_rB      <= rB;
            old_valE    <= valE;
            old_valM    <= valM;
        end
    end
endmodule;
