module MA (
  input CLK, RST,
  input [31:0] Result, Rdata2, nextPC, Ins,
  output [31:0] Wdata
);
`include "common_param.vh"

  reg [31:0] DMem[0:DMEM_SIZE-1];

  always @(posedge CLK) begin
    if ( ~RST ) begin
      case (Ins[31:26])
        SW: DMem[Result>>2] <= Rdata2;
      endcase
    end
  end

  assign Wdata = getWdata(RST, Ins, DMem[Result>>2], Rdata2, Result, nextPC);

  function [31:0] getWdata (
    input [31:0] RST, Ins, Rdata, Rdata2, Result, nextPC
  );
    if ( RST ) begin
      getWdata = 0;
    end
    else begin
      if (Ins[31:26] == R_FORM) begin
        case (Ins[5:0])
          JALR: getWdata = nextPC;
          default: getWdata = Result;
        endcase
      end
      else begin
        case (Ins[31:26])
          LW: getWdata = Rdata;
          SW: getWdata = Rdata2;
          JAL: getWdata = nextPC;
          default: getWdata = Result;
        endcase
      end
    end
  endfunction
endmodule
