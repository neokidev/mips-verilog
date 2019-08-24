module ID (
  input CLK, RST,
  input [31:0] Ins, Wdata, nextPC,
  output [31:0] Rdata1, Rdata2, Ed32
);
`include "common_param.vh"

  reg [31:0] Reg[0:REGFILE_SIZE-1];

  integer i;
  initial begin
    Reg[0] <= 32'b0; // $zero
    for (i = 1; i < REGFILE_SIZE; i = i + 1) begin
  		Reg[i] <= 32'd2048;
   	end
  end

  always @(posedge CLK) begin
    case (Ins[31:26])
      R_FORM:
        case (Ins[5:0])
          JALR: Reg[Ins[15:11]] <= nextPC;
          default Reg[Ins[15:11]] <= Wdata;
        endcase
      JAL: Reg[REGFILE_SIZE - 1] <= nextPC;
      default: Reg[Ins[20:16]] <= Wdata;
    endcase
  end

  wire [31:0] reg1, reg2;
  assign reg1 = Reg[Ins[25:21]];
  assign reg2 = Reg[Ins[20:16]];

  assign {Rdata1, Rdata2, Ed32} = Outputs(Ins, reg1, reg2);

  function [95:0] Outputs; // Outputs = {Rdata1, Rdata2, Ed32}
    input [31:0] Ins, reg1, reg2;

    // R format
    if (Ins[31:26] == R_FORM) begin
      Outputs = {reg1, reg2, 32'b0};
    end
    // I format
    else begin
      case (Ins[31:26])
        // Calculate Ed32 with Unsigned Extension
        ANDI: Outputs = {reg1, reg2, {16'b0, Ins[15:0]}};
        ORI: Outputs = {reg1, reg2, {16'b0, Ins[15:0]}};
        XORI: Outputs = {reg1, reg2, {16'b0, Ins[15:0]}};
        LW: Outputs = {reg1, reg2, {16'b0, Ins[15:0]}};
        SW: Outputs = {reg1, reg2, {16'b0, Ins[15:0]}};
        // Calculate Ed32 with Signed Extension
        default: Outputs = {reg1, reg2, {{16{Ins[15]}}, Ins[15:0]}};
      endcase
    end
  endfunction

endmodule
