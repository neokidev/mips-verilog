module SingleClockMIPS (
  input CLK, RST, WE, CHG,
  input [31:0] W_Ins,
  output [9:0] LEDR,
  output [31:0] PC, Result, DIN
);
`include "common_param.vh"
  wire [31:0] newPC, nextPC, Ins;
  wire [31:0] Rdata1, Rdata2, Ed32, Wdata;

  reg [2:0] SEL;

  IF IF0 (.CLK(CLK), .RST(RST), .newPC(newPC), .PC(PC), .W_Ins(W_Ins), .WE(WE), .nextPC(nextPC), .Ins(Ins));
  ID ID0 (.CLK(CLK), .RST(RST), .Ins(Ins), .Wdata(Wdata),
          .Rdata1(Rdata1), .Rdata2(Rdata2), .Ed32(Ed32));
  EX EX0 (.CLK(CLK), .RST(RST), .Ins(Ins), .Rdata1(Rdata1), .Rdata2(Rdata2),
          .Ed32(Ed32), .nextPC(nextPC), .Result(Result), .newPC(newPC));
  MA MA0 (.CLK(CLK), .RST(RST), .Result(Result), .Rdata2(Rdata2), .nextPC(nextPC),
          .Ins(Ins), .Wdata(Wdata));
  SELDIN SELDIN0 (.RST(RST), .CHG(CHG), .Result(Result), .Rdata1(Rdata1), .Rdata2(Rdata2), .nextPC(nextPC), .Wdata(Wdata),
                  .LEDR(LEDR), .DIN(DIN));
endmodule
