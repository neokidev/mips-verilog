module MA (
  input CLK, RST,
  input [31:0] Result, Rdata2, nextPC, Ins,
  output [31:0] Wdata
);
`include "common_param.vh"

  assign Wdata = Result;
endmodule
