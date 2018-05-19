module blackbox_test;
reg k_in, d_in, e_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire s_out;                        // wires for the outputs of "circuit under test"

    blackbox test (s_out, k_in, d_in, e_in);  // the circuit under test
    
    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
        $dumpfile("blackbox.vcd");                  // name of dump file to create
        $dumpvars(0,blackbox_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches
        
        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        k_in = 0; d_in = 0; e_in = 0; # 10;   // set initial values and wait 10 time units
        k_in = 0; d_in = 0; e_in = 1; # 10;             // change inputs and then wait 10 time units
        k_in = 0; d_in = 1; e_in = 0; # 10;            // as above
        k_in = 0; d_in = 1; e_in = 1; # 10;
	k_in = 1; d_in = 0; e_in = 0; # 10;
	k_in = 1; d_in = 0; e_in = 1; # 10;
	k_in = 1; d_in = 1; e_in = 0; # 10;
	k_in = 1; d_in = 1; e_in = 1; # 10;

        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, k_in = %d d_in = %d e_in = %d s_out = %d",
                 $time, k_in, d_in, e_in, s_out); 

endmodule // blackbox_test
