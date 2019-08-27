module SEG7DEC (DIN, nHEX);
  input [3:0] DIN;
  output reg [7:0] nHEX;

  always @ (DIN) begin
    case (DIN)
      4'h0: // 0
		    nHEX <= 8'b11000000;
      4'h1: // 1
        nHEX <= 8'b11111001;
      4'h2: // 2
        nHEX <= 8'b10100100;
      4'h3: // 3
        nHEX <= 8'b10110000;
      4'h4: // 4
        nHEX <= 8'b10011001;
      4'h5: // 5
        nHEX <= 8'b10010010;
      4'h6: // 6
        nHEX <= 8'b10000010;
      4'h7: // 7
        nHEX <= 8'b11011000;
      4'h8: // 8
        nHEX <= 8'b10000000;
      4'h9: // 9
        nHEX <= 8'b10010000;
      4'ha: // A
        nHEX <= 8'b10001000;
      4'hb: // b
        nHEX <= 8'b10000011;
      4'hc: // C
        nHEX <= 8'b11000110;
      4'hd: // d
        nHEX <= 8'b10100001;
      4'he: // E
        nHEX <= 8'b10000110;
		4'hf: // F
		  nHEX <= 8'b10001110;
      default:
        nHEX <= 8'b10111111;
    endcase
  end
endmodule
