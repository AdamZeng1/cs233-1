module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        # 10 A = 7; B = 6; control = `ALU_AND; // add more test cases here!
	# 10 A = 3; B = 8; control = `ALU_OR;
	# 10 A = 15;B = 9; control = `ALU_NOR;
	# 10 A = 25;B = 10; control = `ALU_XOR;
	# 10 A = 10; B = 10; control = `ALU_SUB;
	# 10 A = 31; B = 32'h7ffffff0; control = `ALU_SUB;
	# 10 A = 32'h6f00ff00; B = 32'h10ff00ff; control = `ALU_ADD;
	# 10 A = 32'h7f00ff00; B = 32'h10ff00ff; control = `ALU_ADD;
	# 10 A = 32'hcf00ff00; B = 32'h80ff00ff; control = `ALU_ADD;
	# 10 A = 32'h7f00ff00; B = 32'hcf00ff00; control = `ALU_SUB;
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
