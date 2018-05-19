// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe


module word_reader(I, L, U, V, bits, clk, reset);
   output 	I, L, U, V;
   input [1:0] 	bits;
   input 	reset, clk;

   wire         sGarbage, sGarbage_next, sBlank, sBlank_next, sI, sI_next, sI_end, 			sI_end_next, sL, sL_next, sL_end, sL_end_next, sU, sU_next, sU_end, 			sU_end_next, sVf, sVf_next, sVs, sVs_next, sVt, sVt_next, sV_end, 			sV_end_next;

   	wire in000 = bits == 3'b000;
	wire in111 = bits == 3'b011;
	wire in001 = bits == 3'b001;
	wire in010 = bits == 3'b010;

        assign sGarbage_next = reset | (sBlank & ~(in000|in111)) | (sI & ~in000) | (sI_end &(~(in000|in111))) | (sGarbage & ~in000) | (sL & ~in000) | (sL_end & (in001|in010)) | (sU & ~in000) | (sU_end & (in001|in010)) | (sVf & (in010|in111)) | (sVs & (in001|in111)) | (sVt & ~in000) | (sV_end & in001); 

	assign sBlank_next = ~reset & ((sGarbage & in000) | (sBlank & in000) | (sI_end & in000) | (sL_end & in000) | (sU_end & in000) | (sVf & in000) | (sVs & in000) | (sV_end & in000));

	assign sI_next = ~reset & ((sBlank & in111) | (sI_end & in111)| (sL_end & in111) |(sU_end & in111) | (sV_end & in111));

	assign sI_end_next = ~reset & (sI & in000); 

	assign sL_next = ~reset & (sI & in001);

	assign sL_end_next = ~reset & (sL & in000);

	assign sU_next = ~reset & (sL & in111);

	assign sU_end_next = ~reset & (sU & in000);
        
	assign sVf_next = ~reset & ((sBlank & in010) | (sV_end & in010) | (sI_end & in010) | (sL_end & in010) | (sU_end & in010));

	assign sVs_next = ~reset & (sVf & in001);

	assign sVt_next = ~reset & (sVs & in010);

	assign sV_end_next = ~reset & (sVt & in000);

    	dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
    	dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    	dffe fsI(sI, sI_next, clk, 1'b1, 1'b0);
    	dffe fsI_end(sI_end, sI_end_next, clk, 1'b1, 1'b0);
	dffe fsL(sL, sL_next, clk, 1'b1, 1'b0);
	dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);
	dffe fsU(sU, sU_next, clk, 1'b1, 1'b0);
	dffe fsU_end(sU_end, sU_end_next, clk, 1'b1, 1'b0);

	dffe fsVf(sVf, sVf_next, clk, 1'b1, 1'b0);
	dffe fsVs(sVs, sVs_next, clk, 1'b1, 1'b0);
	dffe fsVt(sVt, sVt_next, clk, 1'b1, 1'b0);
	dffe fsV_end(sV_end, sV_end_next, clk, 1'b1, 1'b0);

	assign I = sI_end;	
	assign L = sL_end;
	assign U = sU_end;
	assign V = sV_end;
   //dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
   //assign sBlank_next = reset;  // | other condition ... 
   
endmodule // word_reader
