// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
	
	wire [31:0] B, rtData, imm, rsData, rdData, PCnext0, PCnext1, PCnext2, out, data_out, PCnext;
    	wire [2:0] alu_op;
    	wire wr_enable, rd_src, alu_src2, overflow, zero, negative;
    	wire [4:0] Rdest;

    	wire [1:0] control_type;
    	wire       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
	wire [7:0] byte_out;
	wire [31:0] byte_out_extend, slt_in, mem_read_out, lui_in, branchoffset, mem_read_in, slt_out, addr, addm_out, lui_out;

	assign PCnext2[31:28] = PC[31:28];
	assign PCnext2[27:2] = inst[25:0];
	assign PCnext2[1:0] = 0;
	assign byte_out_extend[31:8] = 0;
	assign byte_out_extend[7:0] = byte_out[7:0];
	assign slt_in[31:1] = 0;
	assign slt_in[0] = negative ^ overflow; // slt correctness
	assign lui_in[31:16] = inst[15:0];
	assign lui_in[15:0] = 0;

    register #(32) PC_reg(PC, PCnext, clock, 1, reset);

    mux4v m2(PCnext, PCnext0, PCnext1, PCnext2, rsData, control_type);

    instruction_memory im(inst, PC[31:2]);

    alu32 a1(PCnext0, , , , PC, 32'h4, `ALU_ADD);

    alu32 a2(PCnext1, , , , PCnext0, branchoffset, `ALU_ADD);

	shift_left_two slt0(branchoffset, imm[29:0]);
    //mips_decode d0(alu_op, wr_enable, alu_src2, rd_src, except, inst[31:26], inst[5:0]);
    mips_decode d0(alu_op, wr_enable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   inst[31:26], inst[5:0], zero);

    mux2v m0(Rdest, inst[15:11], inst[20:16], rd_src);
    sign_extender s0(imm, inst[15:0]);
        
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, wr_enable, clock, reset);

    mux2v m1(B, rtData, imm, alu_src2);
    alu32 a0(out, overflow, zero, negative, rsData, B, alu_op);

//addm
	mux2v m8(addr, out, rsData, addm);	
	alu32 a3(addm_out, , , , data_out, rtData, `ALU_ADD);

	data_mem dm(data_out, addr, rtData, word_we, byte_we, clock, reset);
	mux4v m3(byte_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
	mux2v m4(mem_read_in, data_out, byte_out_extend, byte_load);
	mux2v m5(slt_out, out, slt_in, slt);
	mux2v m6(mem_read_out, slt_out, mem_read_in, mem_read);
	mux2v m7(lui_out, mem_read_out, lui_in, lui);

	mux2v m9(rdData, lui_out, addm_out, addm);
    // DO NOT comment out or rename this module
    // or the test bench will break
    //register #(32) PC_reg( /* connect signals */);

    // DO NOT comment out or rename this module
    // or the test bench will break
    //instruction_memory im( /* connect signals */ );

    // DO NOT comment out or rename this module
    // or the test bench will break
    //regfile rf ( /* connect signal wires */);

endmodule // full_machine

    /* add other modules */
module sign_extender (imm, inst);
    output [31:0] imm;
    input [15:0] inst;
    assign imm[31:16] = {16{inst[15]}};
    assign imm[15:0] = inst[15:0];
endmodule

module shift_left_two (branchoffset, imm);
    output [31:0] branchoffset;
    input [29:0] imm;
	assign branchoffset[31:2] = imm[29:0]; 
	assign branchoffset[1:0] = 0;
endmodule

