//
// Example Verilog testbench for Counter module as Device Under Test (DUT).
//
// The module contains non-synthesizable code and generates clock, reset
// and enable control signals to verify the expected functionality of the
// design before mapping the code to FPGA. The clock stimulus is generated
// by a VHDL component in order to show how we can simulate mixed-language
// designs using the Xilinx XSim simulator without the need of a commercial
// license (on the contrary, other professional digital simulators such as
// Mentor ModelSim/QuestaSim or Cadence IES/Xcelium require a full license).
//
// Luca Pacher - pacher@to.infn.it
// Fall 2020
//


`timescale 1ns / 100ps

module tb_Counter ;   // no port declaration for a testbench


   ///////////////////////////////////////////
   //    clock generator (VHDL component)   //
   ///////////////////////////////////////////

   wire clock ;

   // if needed, override default clock period (default is 10.0 ns)
   ClockGen #(.PERIOD(10.0)) ClockGen_inst (.clk(clock)) ;            // **NOTE: PERIOD is a VHDL generic with a 'time' data type, use a Verilog 'real' value


   /////////////////////////////////
   //   device under test (DUT)   //
   /////////////////////////////////

   reg reset ;   // keep the signal uninitialized at the beginning of the simulation, what happens ?

   reg enable = 1'b0 ;

   wire [3:0] LED ;   // actually nothing interesting to see in simulation, a few least-significant bits of the internal counter probed from Tcl script

   Counter DUT (.clk(clock), .reset(reset), .enable(enable), .LED(LED)) ;


   ///////////////////////
   //   main stimulus   //
   ///////////////////////

   initial begin

      #1500  reset = 1'b1 ;     // assert the reset
      #1350  reset = 1'b0 ;     // release the reset

      #2500  enable = 1'b1 ;    // the counter is enabled, but PLL is not yet locked
      #10000 enable = 1'b0 ;

      #3000 $finish ;           // stop the simulation (Verilog task)

   end

endmodule

