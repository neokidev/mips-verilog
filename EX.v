module EX (CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
  input CLK, RST;
  input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
  output [31:0] Result, newPC;

  wire [5:0] Op, Func;
  wire [4:0] Shamt;
  wire [25:0] Address;

  assign Op = Ins[31:26];
  assign Func = Ins[5:0];
  assign Shamt = Ins[10:6];
  assign Address = Ins[25:0];

  assign Result = result(Op, Func, Rdata1, Rdata2, Ed32, Shamt);
  assign newPC = newpc(Op, Func, Rdata1, Rdata2, Ed32, nextPC, Shamt, Address);

  reg [31:0] HI, LO;

  // always @ (posedge CLK) begin
  //  HI <= ;
  //  LO <= ;
  // end

  function [31:0] result;
    input [5:0] op, func;
    input [31:0] rdata1, rdata2, ed32;
    input [4:0] shamt;

    // R format
    if (op == R_FORM) begin
      case (func)
        // Add
        ADD: result = rdata1 + rdata2;
        // Add Unsigned
        ADDU: result = rdata1 + rdata2;
        // Subtract
        SUB: result = rdata1 - rdata2;
        // Subtract Unsigned
        SUBU: result = rdata1 - rdata2;
        // And
        AND: result = rdata1 & rdata2;
        // Or
        OR: result = rdata1 | rdata2;
        // Exclusive Or
        XOR: result = rdata1 ^ rdata2;
        // Nor
        NOR: result = ~(rdata1 | rdata2);
        // Set on Less Than
        SLT: result = $signed(rdata1) < $signed(rdata2) ? 32'd1 : 32'd0;
        // Set on Less Than Unsigned
        SLTU: result = rdata1 < rdata2 ? 32'd1 : 32'd0;
        // Shift Left Logical
        SLL: result = rdata2 << shamt;
        // Shift Right Logical
        SRL: result = rdata2 >> shamt;
        // Shift Right Arithmetic
        SRA: result = $signed(rdata2) >>> shamt;
        // Shift Left Logical Variable
        SLLV: result = rdata2 << rdata1;
        // Shift Right Logical Variable
        SRLV: result = rdata2 >> rdata1;
        // Shift Right Arithmetic Variable
        SRAV: result = $signed(rdata2) >>> rdata1;
        // Multiply
      endcase
    end
    // I and J format
    else begin
      case (Op)
        // Load Word
        LW: result = rdata1 + ed32;
        // Store Word
        SW: result = rdata1 + ed32;
        // Add Immediate
        ADDI: result = rdata1 + ed32;
        // Add Immediate Unsigned
        ADDIU: result = rdata1 + ed32;
        // Set on Less Than Immediate
        SLTI: result = $signed(rdata1) < $signed(ed32) ? 32'd1 : 32'd0;
        // Set on Less Than Immediate Unsigned
        SLTIU: result = rdata1 < ed32 ? 32'd1 : 32'd0;
        // And Immediate
        ANDI: result = rdata1 & ed32;
        // Or Immediate
        ORI: result = rdata1 | ed32;
        // Exclusive Or Immediate
        XORI: result = rdata1 ^ ed32;
      endcase
    end
  endfunction


  function [31:0] newpc;
    input [5:0] op, func;
    input [31:0] rdata1, rdata2, ed32, nextpc;
    input [4:0] shamt;
    input [25:0] address;

    case (op)
      R_FORM:
        case (func)
          // Jump Register
          JR: newpc = rdata1;
          // Others
          default: newpc = nextpc;
        endcase
      // Jump
      J: newpc = {nextpc[31:28], address};
      // Others
      default: newpc = nextpc;
    endcase
  endfunction

endmodule
