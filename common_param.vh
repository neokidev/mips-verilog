// common_param.vh

// global parameters
parameter WIDTH = 32;
parameter IMEM_SIZE = 64;
parameter REGFILE_SIZE = 32;
parameter DMEM_SIZE = 1024;

parameter IMEM_FILE_PATH = "samples/sample01.txt";

// operation codes (*) Op==6'd0
parameter R_FORM = 6'd0;

// Op:operation codes (w/o function code)
parameter LW   = 6'd35;
parameter SW   = 6'd43;

// Func:function codes (ALU) Op==6'd0
parameter ADD  = 6'd32;
parameter ADDU = 6'd33;
parameter SUB  = 6'd34;
parameter SUBU = 6'd35;
parameter AND  = 6'd36;
parameter OR   = 6'd37;
parameter XOR  = 6'd38;
parameter NOR  = 6'd39;
parameter SLT  = 6'd42;
parameter SLTU = 6'd43;

// Op:operation codes (w/o function code)
parameter ADDI  = 6'd8;
parameter ADDIU = 6'd9;
parameter SLTI  = 6'd10;
parameter SLTIU = 6'd11;
parameter ANDI  = 6'd12;
parameter ORI   = 6'd13;
parameter XORI  = 6'd14;
//parameter LUI   = 6'd15;

// Func:function codes (Shift) Op==6'd0
parameter SLL   = 6'd0;
parameter SRL   = 6'd2;
parameter SRA   = 6'd3;
parameter SLLV  = 6'd4;
parameter SRLV  = 6'd6;
parameter SRAV  = 6'd7;

// Func:function codes (Mult & Div) Op==6'd0
parameter MFHI   = 6'd16;
parameter MTHI   = 6'd17;
parameter MFLO   = 6'd18;
parameter MTLO   = 6'd19;
parameter MULT   = 6'd24;
parameter MULTU  = 6'd25;
parameter DIV    = 6'd26;
parameter DIVU   = 6'd27;

// Func:function codes (Jump) Op==6'd0 (w/o function code)
parameter JR     = 6'd8;
parameter JALR   = 6'd9;

// Op:operation codes (Jump & Branch)
parameter BLTZ   = 6'd1;
parameter BGEZ   = 6'd1;
//parameter BLTZAL = 6'd1;
//parameter BGEZAL = 6'd1;
parameter J      = 6'd2;
parameter JAL    = 6'd3;
parameter BEQ    = 6'd4;
parameter BNE    = 6'd5;
parameter BLEZ   = 6'd6;
parameter BGTZ   = 6'd7;

// rt[20:16] field codes (BLTZ or BGEZ)
parameter BLTZ_r = 5'd0;
parameter BGEZ_r = 5'd1;

// End of common_param.vh
