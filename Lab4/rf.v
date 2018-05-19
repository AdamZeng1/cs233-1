// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;
 
    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;
 
    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;

	decoder2 d0(w_enable, in[1], enable);
	decoder2 d1(out[1:0], in[0], w_enable[0]);
	decoder2 d2(out[3:2], in[0], w_enable[1]);
    // implement using decoder2's
    
endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [1:0]    w_enable;

	decoder2 d3(w_enable, in[2], enable);
 	decoder4 d4(out[3:0], in[1:0], w_enable[0]);
	decoder4 d5(out[7:4], in[1:0], w_enable[1]);
    // implement using decoder2's and decoder4's
 
endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [1:0]    w_enable;
 
	decoder2 d6(w_enable, in[3], enable);
	decoder8 d7(out[7:0], in[2:0], w_enable[0]);
	decoder8 d8(out[15:8], in[2:0], w_enable[1]);
    // implement using decoder2's and decoder8's
 
endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [1:0]    w_enable;
 
	decoder2 d9(w_enable, in[4], enable);
	decoder16 d10(out[15:0], in[3:0], w_enable[0]);
	decoder16 d11(out[31:16], in[3:0], w_enable[1]);
    // implement using decoder2's and decoder16's
 
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
             wr_regnum, wr_data, writeenable, 
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;

 	wire [31:0] renable; 
	wire [31:0] rout [0:31];

	decoder32 df(renable, wr_regnum, writeenable);

	register r0(rout[0], 32'b0, clock, renable[0], reset);   
	register r1(rout[1], wr_data, clock, renable[1], reset);
	register r2(rout[2], wr_data, clock, renable[2], reset);
	register r3(rout[3], wr_data, clock, renable[3], reset);
	register r4(rout[4], wr_data, clock, renable[4], reset);
	register r5(rout[5], wr_data, clock, renable[5], reset);
	register r6(rout[6], wr_data, clock, renable[6], reset);
	register r7(rout[7], wr_data, clock, renable[7], reset);
	register r8(rout[8], wr_data, clock, renable[8], reset);
	register r9(rout[9], wr_data, clock, renable[9], reset);
	register r10(rout[10], wr_data, clock, renable[10], reset);
	register r11(rout[11], wr_data, clock, renable[11], reset);
	register r12(rout[12], wr_data, clock, renable[12], reset);
	register r13(rout[13], wr_data, clock, renable[13], reset);
	register r14(rout[14], wr_data, clock, renable[14], reset);
	register r15(rout[15], wr_data, clock, renable[15], reset);
	register r16(rout[16], wr_data, clock, renable[16], reset);
	register r17(rout[17], wr_data, clock, renable[17], reset);
	register r18(rout[18], wr_data, clock, renable[18], reset);
	register r19(rout[19], wr_data, clock, renable[19], reset);
	register r20(rout[20], wr_data, clock, renable[20], reset);
	register r21(rout[21], wr_data, clock, renable[21], reset);
	register r22(rout[22], wr_data, clock, renable[22], reset);
	register r23(rout[23], wr_data, clock, renable[23], reset);
	register r24(rout[24], wr_data, clock, renable[24], reset);
	register r25(rout[25], wr_data, clock, renable[25], reset);
	register r26(rout[26], wr_data, clock, renable[26], reset);
	register r27(rout[27], wr_data, clock, renable[27], reset);
	register r28(rout[28], wr_data, clock, renable[28], reset);
	register r29(rout[29], wr_data, clock, renable[29], reset);
	register r30(rout[30], wr_data, clock, renable[30], reset);
	register r31(rout[31], wr_data, clock, renable[31], reset);
	
	mux32v m1(rd1_data, rout[0],rout[1], rout[2], rout[3], rout[4], rout[5], rout[6], rout[7], rout[8], rout[9], rout[10], rout[11], rout[12], rout[13], rout[14], rout[15], rout[16], rout[17], rout[18], rout[19], rout[20], rout[21], rout[22], rout[23], rout[24], rout[25], rout[26], rout[27], rout[28], rout[29], rout[30], rout[31],rd1_regnum);

	mux32v m2(rd2_data, rout[0],rout[1], rout[2], rout[3], rout[4], rout[5], rout[6], rout[7], rout[8], rout[9], rout[10], rout[11], rout[12], rout[13], rout[14], rout[15], rout[16], rout[17], rout[18], rout[19], rout[20], rout[21], rout[22], rout[23], rout[24], rout[25], rout[26], rout[27], rout[28], rout[29], rout[30], rout[31],rd2_regnum);
	// build a register file!
endmodule // mips_regfile	
