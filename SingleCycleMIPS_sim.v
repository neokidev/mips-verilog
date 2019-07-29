`timescale 1 ps/ 1 ps

module SingleClockMIPS_sim();
  parameter PERIOD=10000;  // (clock period)/2

  // constants
  // general purpose registers
  reg clk;
  reg rst;
  reg WE;
  reg [31:0] W_Ins;
  // wires
  wire [31:0] PC, Result;

  // assign statements (if any)
  SingleClockMIPS SingleClockMIPS0 (
  // port map - connection between master ports and signals/registers
    .CLK(clk),
    .RST(rst),
    .W_Ins(W_Ins),
    .WE(WE),
    .PC(PC),
    .Result(Result)
  );

  initial begin
    WE = 1'b0;
    W_Ins = 32'b0;
  end

  always begin
    rst =      1'b1;
    rst = #500 1'b0;
          #50000;
  end

  always begin
    clk =      1'b0;
    clk = #500 1'b1;
          #500;
  end
endmodule
