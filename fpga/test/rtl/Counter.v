//
// Sample Verilog code for a 26-bit synchronous counter with active-high synchronous
// reset and count-enable.
// The RTL also instantiates VHDL components, a Phase-Locked Loop (PLL) IP core to divide
// by a factor 10 the default 100 MHz on-board clock frequency and additional Xilinx FPGA
// device primitives such as pre-placed buffer cells.
// The code is fully synthesizable and can be mapped on a Digilent Arty-A7 board as used
// through the course.
//
// The aim of this RTL example is to help students in testing all software installations
// and to show how to simulate, build and install on real hardware a mixed-language HDL
// design targeting Xilinx FPGA devices.
//
// Luca Pacher - pacher@to.infn.it
// Fall 2020
//


`timescale 1ns / 100ps

module Counter (

   input  wire clk,           // input clock, assume 100 MHz clock frequency from Digilent Arty A7 on-board XTAL oscillator
   input  wire enable,        // count-enable (slide switch)
   input  wire reset,         // synchronous reset, active-high (push button, no debouncer)
   output wire [3:0] LED      // map the 4 most-significant bits (MSBs) of the 26-bit counter to general-purpose LEDs on the board

   ) ;


   ///////////////////////////////////////////////////////////////////////
   //   pre-place buffers on input signals (use IBUF FPGA primitives)   //
   ///////////////////////////////////////////////////////////////////////

   // declare buffered internal signals
   wire clk_buf ;
   wire reset_buf  ;
   wire enable_buf ;

   // input-buffer on external clock 
   IBUF IBUF_clk_inst (.I (clk), .O (clk_buf)) ;   // **NOTE: device primitives require glbl.v to be compiled and elaborated along with other sources

   // input-buffer on external reset
   IBUF IBUF_reset_inst (.I(reset), .O(reset_buf)) ;

   // input-buffer of count-enable
   IBUF IBUF_enable_inst (.I(enable), .O(enable_buf)) ;


   ///////////////////////////////////////////////////////////
   //   Phase-Locked Loop (PLL) IP core (Clocking Wizard)   //
   ///////////////////////////////////////////////////////////

   // PLL output signals
   wire pll_clk, pll_locked ;

   PLL PLL_inst (

      .CLK_IN  ( clk_buf    ),   // input clock: 100 MHz
      .CLK_OUT ( pll_clk    ),   // divided output clock: 10 MHz
      .LOCKED  ( pll_locked )

      ) ;


   ///////////////////////////////////////////////////////////////
   //   global-buffer on PLL output clock (from VHDL wrapper)   //
   ///////////////////////////////////////////////////////////////

   // this is the actual clock signal to be used in RTL 
   wire pll_clk_buf ;

   ClockBuffer ClockBuffer_inst (.ClkIn(pll_clk), .ClkOut(pll_clk_buf)) ;


   ///////////////////////////////////////////////////////
   //   26-bit synchronous counter (behavioural code)   //
   ///////////////////////////////////////////////////////

   reg [25:0] count ;

   always @(posedge pll_clk_buf) begin

      if( reset_buf | (~pll_locked) ) begin   // synchronous reset, active-high
         count <= 'b0 ;
      end

      else if( enable_buf ) begin
         count <= count + 'b1 ;
      end

   end  // always


   /////////////////////
   //   LED mapping   //
   /////////////////////

   // map to on-board LEDs only the MSBs of the 26-bit count

   assign LED[0] = count[22] ;   // LD4 (right-most, LSB)
   assign LED[1] = count[23] ;   // LD5
   assign LED[2] = count[24] ;   // LD6
   assign LED[3] = count[25] ;   // LD7 (left-most, MSB)

endmodule

