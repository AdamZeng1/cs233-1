// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC; 
    wire [31:0] B, rtData, imm, rsData, rdData, PCnext;
    wire [2:0] alu_op;
    wire wr_enable, rd_src, alu_src2, overflow, zero, negative;
    wire [4:0] Rdest;

    register #(32) PC_reg(PC, PCnext, clock, 1, reset);

    instruction_memory im(inst, PC[31:2]);

    alu32 a1(PCnext, , , , PC, 32'h4, `ALU_ADD);
    mips_decode d0(alu_op, wr_enable, alu_src2, rd_src, except, inst[31:26], inst[5:0]);
    mux2v m0(Rdest, inst[15:11], inst[20:16], rd_src);
    sign_extender s0(imm, inst[15:0]);
        
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, wr_enable, clock, reset);
    mux2v m1(B, rtData, imm, alu_src2);
    alu32 a0(rdData, overflow, zero, negative, rsData, B, alu_op);

    /* add other modules */
   
endmodule // arith_machine

module sign_extender (imm, inst);
    output [31:0] imm;
    input [15:0] inst;
    assign imm[31:16] = {16{inst[15]}};
    assign imm[15:0] = inst[15:0];
endmodule
