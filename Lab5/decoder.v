// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

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

	assign alu_op[2] = and_inst | or_inst | nor_inst | xor_inst | andi_inst | ori_inst | xori_inst;
	assign alu_op[1] = add_inst | sub_inst | nor_inst | xor_inst | addi_inst | xori_inst;
	assign alu_op[0] = sub_inst | or_inst | xor_inst | ori_inst | xori_inst;
	assign rd_src = addi_inst | andi_inst | ori_inst | xori_inst;
	assign alu_src2 = addi_inst | andi_inst | ori_inst | xori_inst;
	assign writeenable = add_inst | sub_inst | and_inst | or_inst | nor_inst | xor_inst | addi_inst | andi_inst | ori_inst | xori_inst;

	assign except = ~((opcode == `OP_OTHER0 & (funct == `OP0_SUB | funct == `OP0_AND | funct == `OP0_OR | funct == `OP0_NOR | funct == `OP0_XOR | funct == `OP0_ADD)) | opcode == `OP_ADDI | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI);

endmodule // mips_decode
