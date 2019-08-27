module SELDIN (
  input RST, CHG,
  input [31:0] Result, Rdata1, Rdata2, nextPC, Wdata,
  output reg [9:0] LEDR,
  output [31:0] DIN
);
  always @ (posedge CHG or posedge RST) begin
    if ( RST )
      LEDR <= 1;
    else
      if (LEDR == 16)
        LEDR <= 1;
      else
        LEDR <= LEDR << 1;
  end

  assign DIN = getDIN(LEDR, Rdata1, Rdata2, Result, Wdata, nextPC);

  function [31:0] getDIN (
    input [9:0] LEDR,
    input [31:0] Rdata1, Rdata2, Result, Wdata, nextPC
  );
    case (LEDR)
      1: getDIN = Result;
      2: getDIN = Rdata1;
      4: getDIN = Rdata2;
      8: getDIN = Wdata;
      16: getDIN = nextPC;
      default: getDIN = 0;
    endcase
  endfunction
endmodule
