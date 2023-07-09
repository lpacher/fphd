--
-- Testbench module for DLATCH and DFF fundamental sequential circuits.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

library IEEE ;
use IEEE.std_logic_1164.all ;       -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)
use IEEE.numeric_std.all ;          -- to use the 'to_unsigned' conversion function
use IEEE.math_real.all;             -- additional package to generate random numbers

library STD ;
use STD.env.all ;                   -- the VHDL2008 revision provides stop/finish functions similar to Verilog to end the simulation

library UNISIM ;                    -- library to simulate Xilinx FPGA primitives
use UNISIM.vcomponents.all ;


entity tb_sequential is
end entity tb_sequential ;


architecture testbench of tb_sequential is

   --------------------------------
   --   components declaration   --
   --------------------------------

   component ClockGen
      generic (
         PERIOD : time := 10 ns
      ) ;

      port (
         clk : out std_logic
      ) ;
   end component ClockGen ;

   component DLATCH is
      port (
         D    : in  std_logic ;
         EN   : in  std_logic ;
         Q    : out std_logic ;
         Qbar : out std_logic
      ) ;
   end component DLATCH ;

   component DFF is
      port (
         clk  : in  std_logic ;
         rst  : in  std_logic ;
         D    : in  std_logic ;
         Q    : out std_logic ;
         Qbar : out std_logic
      ) ;
   end component DFF ;

   -- IBUF Xilinx FPGA device primitive (assume default generics)
   component IBUF is
      port (
         I : in  std_logic ;
         O : out std_logic
      ) ;
   end component ;


   --------------------------
   --   internal signals   --
   --------------------------

   signal clk, clk_buf : std_logic ;

   signal rst    : std_logic := '0' ;
   signal en     : std_logic ;
   signal D      : std_logic ;
   signal Qlatch : std_logic ;
   signal Qff    : std_logic ;

   signal irand : integer ;                         -- 32-bit INTEGER random number 0 or 1
   signal vrand : std_logic_vector(31 downto 0) ;   -- 32-bit random number casted to std_logic_vector

begin

   -------------------------
   --   clock generator   --
   -------------------------

   ClockGen_inst : ClockGen generic map ( PERIOD => 100 ns ) port map (clk => clk) ;  -- override default period as module parameter (default is 10.0 ns)


   ------------------------------------------------
   --   example Xilinx primitive instantiation   --
   ------------------------------------------------

   IBUF_inst : IBUF port map ( I => clk, O => clk_buf ) ;


   -------------------------------------------
   --   devices under test (DLATCH + DFF)   --
   -------------------------------------------

   en <= not clk_buf ;

   --D <= irand(0) ;

   DLATCH_inst : DLATCH port map ( D => D, en => en, Q => Qlatch, Qbar => open ) ;
   DFF_inst : DFF port map ( clk => clk_buf, rst => rst, D => D, Q => Qff, Qbar => open ) ;


   ------------------
   --   stimulus   --
   ------------------

   -- use the IEEE.math_real.uniform pseudo-random generator to generate a random input pattern
   process

      variable seed1, seed2 : positive ;   -- seed values for random generator
      variable rrand        : real ;       -- random real-number value in range 0 to 1.0  

   begin

      -- generate real random number between 0. and 1. with uniform distribution
      uniform(seed1, seed2, rrand) ;

      -- convert REAL random number INTEGER to either 0 or 1
      irand <= integer(floor(rrand + 0.5)) ;

      -- repeat every 20 ns
      wait for 20 ns ;

   end process;

   -- convert INTEGER random number to UNSIGNED integer and then to std_logic_vector
   vrand <= std_logic_vector(to_unsigned(irand, vrand'length)) ; D <= vrand(0) ;   -- strong VHDL data typing!

   process
   begin

      wait for  100ns ; rst <= '0' ;   -- release the reset signal
      wait for 1500ns ; rst <= '1' ;   -- assert the reset

      wait for  300ns ; finish ;       -- stop the simulation (this is a VHDL2008-only feature)

      -- **IMPORTANT: the original VHDL93 standard does not provide a routine to easily stop the simulation ! You must use a failing "assertion" for this purpose
      --wait for 500 ns ; assert FALSE report "Simulation Finished" severity FAILURE ;

   end process ;

end architecture testbench ;
