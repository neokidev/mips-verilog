module IF (
  input CLK, RST, WE,
  input [31:0] newPC, W_Ins,
  output reg [31:0] PC, nextPC,
  output [31:0] Ins
);
`include "common_param.vh"

  reg [31:0] IMem[0:IMEM_SIZE-1];

  initial $readmemb("IMem.txt", IMem);

  always @ (posedge CLK) begin
    if ( RST ) begin
      PC = 32'b0;
      nextPC = 32'b0;
    end
    else begin
      PC = newPC;
      nextPC = PC + 3'd4;
    end
  end

  always @ (posedge CLK) begin
    if ( ~RST && WE ) IMem[PC>>2] <= W_Ins;
  end

  assign Ins = RST? 32'd0: IMem[PC>>2];
endmodule
