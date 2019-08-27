module ID (
  input CLK, RST,
  input [31:0] Ins, Wdata,
  output [31:0] Rdata1, Rdata2, Ed32
);
`include "common_param.vh"

  reg [31:0] Reg[0:REGFILE_SIZE-1];

  // Create Register File
  integer i;
  initial begin
    for (i = 0; i < REGFILE_SIZE; i = i + 1) begin
      if (i == 29)
        Reg[i] <= 2048;
      else
        Reg[i] <= 0;
    end
  end

  // Write to Register
  always @ (posedge CLK) begin
    if ( ~RST ) begin
      case (Ins[31:26])
        R_FORM:
          case (Ins[5:0])
            // Not Write to Any Register
            MULT:;
            DIV:;
            MULTU:;
            DIVU:;
            MTHI:;
            MTLO:;
            JR:;
            // Write to rd Register
            default: Reg[Ins[15:11]] <= Wdata;
          endcase
        // Not Write to Any Register
        SW:;
        BEQ:;
        BNE:;
        BGEZ:;
        BGTZ:;
        BLEZ:;
        J:;
        // Write to $ra Register
        JAL: Reg[REGFILE_SIZE - 1] <= Wdata;
        // Write to rt Register
        default: Reg[Ins[20:16]] <= Wdata;
      endcase
    end
  end

  assign {Rdata1, Rdata2, Ed32} = Outputs(RST, Ins, Reg[Ins[25:21]], Reg[Ins[20:16]]);

  function [95:0] Outputs ( // Outputs = {Rdata1, Rdata2, Ed32}
    input [31:0] RST, Ins, Rdata1, Rdata2
  );
    if ( RST ) begin
      Outputs = 0;
    end
    else begin
      // R format
      if (Ins[31:26] == R_FORM) begin
        Outputs = {Rdata1, Rdata2, 32'b0};
      end
      // I format
      else begin
        case (Ins[31:26])
          // Calculate Ed32 with Unsigned Extension
          ANDI: Outputs = {Rdata1, Rdata2, {16'b0, Ins[15:0]}};
          ORI: Outputs = {Rdata1, Rdata2, {16'b0, Ins[15:0]}};
          XORI: Outputs = {Rdata1, Rdata2, {16'b0, Ins[15:0]}};
          LW: Outputs = {Rdata1, Rdata2, {16'b0, Ins[15:0]}};
          SW: Outputs = {Rdata1, Rdata2, {16'b0, Ins[15:0]}};
          // Calculate Ed32 with Signed Extension
          default: Outputs = {Rdata1, Rdata2, {{16{Ins[15]}}, Ins[15:0]}};
        endcase
      end
    end
  endfunction
endmodule
