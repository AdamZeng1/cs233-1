// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

    	wire add_inst = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
	wire sub_inst = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
	wire and_inst = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
	wire or_inst = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
	wire nor_inst = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
	wire xor_inst = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
	wire addi_inst = opcode == `OP_ADDI;
	wire andi_inst = opcode == `OP_ANDI;
	wire ori_inst = opcode == `OP_ORI;
	wire xori_inst = opcode == `OP_XORI;

	wire beq_inst = opcode == `OP_BEQ;
	wire bne_inst = opcode == `OP_BNE;
	wire j_inst = opcode == `OP_J;
	wire jr_inst = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
	wire lui_inst = opcode == `OP_LUI;
	wire slt_inst = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
	wire lw_inst = opcode == `OP_LW;
	wire lbu_inst = opcode == `OP_LBU;
	wire sw_inst = opcode == `OP_SW;
	wire sb_inst = opcode == `OP_SB;
	wire addm_inst = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

	assign alu_op[2] = and_inst | or_inst | nor_inst | xor_inst | andi_inst | ori_inst | xori_inst;
	assign alu_op[1] = add_inst | sub_inst | nor_inst | xor_inst | addi_inst | xori_inst | beq_inst | bne_inst | slt_inst | lw_inst | lbu_inst | sw_inst | sb_inst;

	assign alu_op[0] = sub_inst | or_inst | xor_inst | ori_inst | xori_inst | beq_inst | bne_inst | slt_inst;

	assign rd_src = addi_inst | andi_inst | ori_inst | xori_inst | lui_inst | lw_inst | lbu_inst | sw_inst | sb_inst;

	assign alu_src2 = addi_inst | andi_inst | ori_inst | xori_inst | lw_inst | lbu_inst | sw_inst | sb_inst;

	assign writeenable = add_inst | sub_inst | and_inst | or_inst | nor_inst | xor_inst | addi_inst | andi_inst | ori_inst | xori_inst | lui_inst | slt_inst | lw_inst | lbu_inst | addm_inst;

	assign control_type[1] = j_inst | jr_inst;
	assign control_type[0] = (beq_inst & zero) | (bne_inst & !zero) | jr_inst;
	
	assign mem_read = lw_inst | lbu_inst;
	assign word_we = sw_inst;
	assign byte_we = sb_inst;
	assign byte_load = lbu_inst;
	assign lui = lui_inst;
	assign slt = slt_inst;
	assign addm = addm_inst;

	assign except = ~(add_inst | sub_inst | and_inst | or_inst | nor_inst | xor_inst | addi_inst | andi_inst | ori_inst | xori_inst | beq_inst | bne_inst | j_inst | jr_inst | lui_inst | slt_inst | lw_inst | lbu_inst | sw_inst | sb_inst | addm_inst);

endmodule // mips_decode
