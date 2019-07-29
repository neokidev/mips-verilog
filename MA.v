module MA (
  input CLK, RST,
  input [31:0] Result, Rdata2, nextPC, Ins,
  output [31:0] Wdata
);
`include "common_param.vh"

  reg [31:0] DMem[0:DMEM_SIZE-1];

  always @(posedge CLK) begin
    case (Ins[31:26])
      SW: DMem[Result>>2] <= Rdata2;
    endcase
  end

  assign Wdata = Ins[31:26] == LW ? DMem[Result>>2] : Result;
endmodule
