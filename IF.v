module IF (
  input CLK, RST, WE,
  input [31:0] newPC, W_Ins,
  output reg [31:0] PC, nextPC,
  output [31:0] Ins
);
`include "common_param.vh"

  reg [31:0] IMem[0:IMEM_SIZE-1];

  initial begin
    $readmemb(IMEM_FILE_PATH, IMem);
    PC = 32'b0;
    nextPC = 32'b0;
  end

  always @ (posedge CLK) begin
    if ( RST ) begin
      PC = 0;
      nextPC = 4;
    end
    else begin
      PC = newPC;
      nextPC = PC + 4;
    end
  end

  always @ (posedge CLK) begin
    if ( ~RST && WE ) IMem[PC>>2] <= W_Ins;
  end

  assign Ins = RST? 32'd0: IMem[PC>>2];
endmodule
