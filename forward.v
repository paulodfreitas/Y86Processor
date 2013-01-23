/**
 * This file has only reg forwardings, because I think memory doens't use forwarding while "all" operations (read, write) happens in same stage.
 */
module fwd_2_execute(
    applyMemFwd, mem_regA, mem_regAValue, mem_regB, mem_regBValue, 
    applyEx2Fwd, ex2_regA, ex2_regAValue
    exe_regA, exe_regAValue, exe_regB, exe_regBValue, 
    out_regAValue, out_regBValue 
);

    input applyMemFwd    [1:0];
    input mem_regA       [3:0];
    input mem_regAValue  [31:0];
    input mem_regB       [3:0];
    input mem_regBValue  [31:0];

    input applyEx2Fwd;
    input ex2_regA       [3:0];
    input ex2_regAValue  [31:0];

    input exe_regA       [3:0];
    input exe_regAValue  [31:0];
    input exe_regB       [3:0];
    input exe_regBValue  [31:0];
    
    output out_regAValue[31:0];
    output out_regBValue[31:0];

    case ({applyEx2Fwd, applyMemFwd}) begin
        'b000: begin
            assign out_regAValue = exe_regAValue;
            assign out_regBValue = exe_regBValue;
        end
        'b001: begin
            assign out_regAValue = mem_regB == exe_regA ? mem_regBValue: 
                                                          exe_regAValue;
            assign out_regBValue = mem_regB == exe_regB ? mem_regBValue: 
                                                          exe_regBValue;            
        end
        'b010: begin
            assign out_regAValue = mem_regA == exe_regA ? mem_regAValue: 
                                                          exe_regAValue;
            assign out_regBValue = mem_regA == exe_regB ? mem_regAValue:
                                                          exe_regBValue;
        end
        'b011: begin
            assign out_regAValue = mem_regA == exe_regA ? mem_regAValue: 
                                   mem_regB == exe_regA ? mem_regBValue: 
                                                          exe_regAValue;
            assign out_regBValue = mem_regA == exe_regB ? mem_regAValue:
                                   mem_regB == exe_regB ? mem_regBValue: 
                                                          exe_regBValue;
        end
        'b100: begin
            assign out_regAValue = ex2_regA == exe_regA ? ex2_regValue : exe_regAValue;
            assign out_regBValue = ex2_regA == exe_regB ? ex2_regValue : exe_regBValue;            
        end
        'b101: begin
            assign out_regAValue = ex2_regA == exe_regA ? ex2_regValue : 
                                   mem_regB == exe_regA ? mem_regBValue: 
                                                          exe_regAValue;
            assign out_regBValue = ex2_regA == exe_regB ? ex2_regValue :
                                   mem_regB == exe_regB ? mem_regBValue:
                                                          exe_regBValue;
        end
        'b110: begin
            assign out_regAValue = ex2_regA == exe_regA ? ex2_regValue : 
                                   mem_regA == exe_regA ? mem_regAValue: 
                                                          exe_regAValue;
            assign out_regBValue = ex2_regA == exe_regB ? ex2_regValue : 
                                   mem_regA == exe_regB ? mem_regAValue:
                                                          exe_regBValue;
        end
        'b111: begin
            assign out_regAValue = ex2_regA == exe_regA ? ex2_regValue : 
                                   mem_regA == exe_regA ? mem_regAValue: 
                                   mem_regB == exe_regA ? mem_regBValue: 
                                                          exe_regAValue;
            assign out_regBValue = ex2_regA == exe_regB ? ex2_regValue : 
                                   mem_regA == exe_regB ? mem_regAValue:
                                   mem_regB == exe_regB ? mem_regBValue:
                                                          exe_regBValue;
        end
    endcase
endmodule
