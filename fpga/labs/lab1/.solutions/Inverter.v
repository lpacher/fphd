//
// A simple inverter (NOT-gate) in Verilog
//
// Luca Pacher - pacher@to.infn.it
// Spring 2023
//

// this is a C-style single-line comment

/*

this is another C-style comment
but distributed across multiple lines

*/


`timescale 1ns / 100ps     // specify time-unit and time-precision, this is only for simulation purposes

module Inverter (

   input  wire X,
   output wire ZN ) ;      // this is redundant, by default I/O ports are always considered WIRES unless otherwise specified


   // continuous assignment
   assign ZN = ~X ;

   // conditional assignment
   //assign ZN = (X == 1'b1) ? 1'b0 : 1'b1 ;

   // primitive instantiation
   //not(ZN, X) ;

endmodule

