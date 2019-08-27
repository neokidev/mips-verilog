module EX (
  input CLK, RST,
  input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC,
  output [31:0] Result, newPC
);
`include "common_param.vh"

  assign Result = getResult(RST, Ins, Rdata1, Rdata2, Ed32);
  assign newPC = getnewPC(RST, Ins, Rdata1, Rdata2, Ed32, nextPC);

  reg [31:0] HI, LO;

  always @ (posedge CLK) begin
    if (Ins[31:26] == R_FORM)
      case (Ins[5:0])
        MULT: {HI, LO} = {32'b0, Rdata1} * {32'b0, Rdata2};
        MULTU: {HI, LO} = {{32{Rdata1[31]}}, Rdata1} * {{32{Rdata2[31]}}, Rdata2};
        DIV: {HI, LO} = {Rdata1 % Rdata2, Rdata1 / Rdata2};
        DIVU: {HI, LO} = {Rdata1 % Rdata2, Rdata1 / Rdata2};
        MTHI: HI = Rdata1;
        MTLO: LO = Rdata1;
      endcase
  end

  function [31:0] getResult (
    input [31:0] RST, Ins, Rdata1, Rdata2, Ed32
  );
    if ( RST )
      getResult = 0;
    else
      // R format
      if (Ins[31:26] == R_FORM) begin
        case (Ins[5:0])
          // Add
          ADD: getResult = Rdata1 + Rdata2;
          // Add Unsigned
          ADDU: getResult = Rdata1 + Rdata2;
          // Subtract
          SUB: getResult = Rdata1 - Rdata2;
          // Subtract Unsigned
          SUBU: getResult = Rdata1 - Rdata2;
          // And
          AND: getResult = Rdata1 & Rdata2;
          // Or
          OR: getResult = Rdata1 | Rdata2;
          // Exclusive Or
          XOR: getResult = Rdata1 ^ Rdata2;
          // Nor
          NOR: getResult = ~(Rdata1 | Rdata2);
          // Set on Less Than
          SLT: getResult = $signed(Rdata1) < $signed(Rdata2) ? 1 : 0;
          // Set on Less Than Unsigned
          SLTU: getResult = Rdata1 < Rdata2 ? 1 : 0;
          // Shift Left Logical
          SLL: getResult = Rdata2 << Ins[10:6];
          // Shift Right Logical
          SRL: getResult = Rdata2 >> Ins[10:6];
          // Shift Right Arithmetic
          SRA: getResult = $signed(Rdata2) >>> Ins[10:6];
          // Shift Left Logical Variable
          SLLV: getResult = Rdata2 << Rdata1;
          // Shift Right Logical Variable
          SRLV: getResult = Rdata2 >> Rdata1;
          // Shift Right Arithmetic Variable
          SRAV: getResult = $signed(Rdata2) >>> Rdata1;
          // Move from HI
          MFHI: getResult = HI;
          // Move from LO
          MFLO: getResult = LO;
          default: getResult = 0;
        endcase
      end
      // I and J format
      else begin
        case (Ins[31:26])
          // Load Word
          LW: getResult = Rdata1 + Ed32;
          // Store Word
          SW: getResult = Rdata1 + Ed32;
          // Add Immediate
          ADDI: getResult = Rdata1 + Ed32;
          // Add Immediate Unsigned
          ADDIU: getResult = Rdata1 + Ed32;
          // Set on Less Than Immediate
          SLTI: getResult = $signed(Rdata1) < $signed(Ed32) ? 1 : 0;
          // Set on Less Than Immediate Unsigned
          SLTIU: getResult = Rdata1 < Ed32 ? 1 : 0;
          // And Immediate
          ANDI: getResult = Rdata1 & Ed32;
          // Or Immediate
          ORI: getResult = Rdata1 | Ed32;
          // Exclusive Or Immediate
          XORI: getResult = Rdata1 ^ Ed32;
          default: getResult = 0;
        endcase
      end
  endfunction

  function [31:0] getnewPC (
    input [31:0] RST, Ins, Rdata1, Rdata2, Ed32, nextPC
  );
    if ( ~RST ) begin
      case (Ins[31:26])
        R_FORM:
          case (Ins[5:0])
            // Jump Register
            JR: getnewPC = Rdata1;
            // Jump and Link Register
            JALR: getnewPC = Rdata1;
            // Others
            default: getnewPC = nextPC;
          endcase
        // Jump
        J: getnewPC = {nextPC[31:28], 4 * Ins[25:0]};
        // Jump and Link
        JAL: getnewPC = {nextPC[31:28], 4 * Ins[25:0]};
        // Branch on Equal
        BEQ: getnewPC = Rdata1 == Rdata2 ? nextPC + 4 * Ed32 : nextPC;
        // Branch on Not Equal
        BNE: getnewPC = Rdata1 != Rdata2 ? nextPC + 4 * Ed32 : nextPC;
        // BLTZ & BGEZ
        BLTZ:
          case (Ins[20:16])
            // Branch on Less Than Zero
            BLTZ_r: getnewPC = Rdata1 < 0 ? nextPC + 4 * Ed32 : nextPC;
            // Branch on Greater Than or Equal to Zero
            BGEZ_r: getnewPC = Rdata1 >= 0 ? nextPC + 4 * Ed32 : nextPC;
          endcase
        // Branch on Less Than or Equal to Zero
        BLEZ: getnewPC = Rdata1 <= 0 ? nextPC + 4 * Ed32 : nextPC;
        // Branch on Greater Than Zero
        BGTZ: getnewPC = Rdata1 > 0 ? nextPC + 4 * Ed32 : nextPC;
        // Others
        default: getnewPC = nextPC;
      endcase
    end
  endfunction
endmodule
