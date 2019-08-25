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

  assign Wdata = wdata(Ins[31:26], DMem[Result>>2], Rdata2, Result, nextPC);

  function [31:0] wdata;
    input [5:0] op;
    input [31:0] rdata, rdata2, result, nextpc;

    if (op == LW)
      wdata = rdata;
    else if (op == SW)
      wdata = rdata2;
    else if (op == JAL)
      wdata = nextpc;
    else if (op == JALR)
      wdata = nextpc;
    else
      wdata = result;
  endfunction
endmodule
