module MA (
  input CLK, RST,
  input [31:0] Result, Rdata2, nextPC, Ins,
  output [31:0] Wdata
);
`include "common_param.vh"

  reg [31:0] DMem[0:DMEM_SIZE-1];
  wire [31:0] MemData;
  assign MemData = DMem[Result];

  assign Wdata = Output(Ins, MemData, Result);

  function [31:0] Output;
    input [31:0] Ins;
    input [31:0] MemData;
    input [31:0] Result;
    case (Ins[31:26])
      LW: Output = MemData;
      default: Output = Result;
    endcase
  endfunction

  always @(posedge CLK) begin
    case (Ins[31:26])
      SW: DMem[Result] <= Rdata2;
    endcase
  end
endmodule
