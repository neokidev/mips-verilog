module ID (
  input CLK, RST,
  input [31:0] Ins, Wdata,
  output [31:0] Rdata1, Rdata2, Ed32
);
`include "common_param.vh"

  reg [31:0] Reg[0:31];

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
  		Reg[i] <= 32'b0;
   	end
  end

  always @(posedge CLK) begin
    if (Ins[31:26] == R_FORM)
      Reg[Ins[15:11]] <= Wdata;
    else
      Reg[Ins[20:16]] <= Wdata;
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
      Outputs = {reg1, 32'b0, {{16{Ins[15]}}, Ins[15:0]}};
    end
  endfunction

endmodule
