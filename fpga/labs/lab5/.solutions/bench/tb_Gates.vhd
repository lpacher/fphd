--
-- Example VHDL testbench to simulate basic logic gates.
--
-- The code uses a 2-bit counter running at 100 MHz to generate
-- all possible input combinations to test AND, NAND, OR, NOR etc.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--


library IEEE ;
use IEEE.std_logic_1164.all ;       -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)
use IEEE.std_logic_unsigned.all ;   -- to use + operator between std_logic_vector data types

library STD ;
use STD.env.all ;                   -- the VHDL2008 revision provides stop/finish functions similar to Verilog to end the simulation


entity tb_Gates is   -- empty entity declaration for a testbench
end entity tb_Gates ;


architecture testbench of tb_Gates is

   --------------------------------
   --   components declaration   --
   --------------------------------

   component Gates
      port (
         A : in  std_logic ;
         B : in  std_logic ;
         Z : out std_logic_vector(5 downto 0)
      ) ;
   end component ;


   ---------------------------------------------------
   --   testbench parameters and internal signals   --
   ---------------------------------------------------

   -- clock and clock period
   constant PERIOD : time := 10 ns ;
   signal clk : std_logic ;

   -- 2-bit counter initialized to zero
   signal count : std_logic_vector(1 downto 0) := "00" ;

   -- 6-bit bus to probe outputs
   signal Z : std_logic_vector(5 downto 0) ;


begin

   ---------------------------------
   --   100 MHz clock generator   --
   ---------------------------------

   clockGen : process   -- process without sensitivity list
   begin

      clk <= '0' ;
      wait for PERIOD/2 ;   -- simply toggle clk signal every half-period
      clk <= '1' ;
      wait for PERIOD/2 ;

   end process ;


   ----------------------
   --  2-bit counter   -- 
   ----------------------

   counter : process(clk)
   begin

      if( rising_edge(clk) ) then   -- use the rising_edge(clk) function in place of the verbose clk'event and clk = '1' syntax

         count <= count + '1' ;

      end if ;
   end process ;


   ---------------------------------
   --   device under test (DUT)   --
   ---------------------------------

   DUT : Gates port map (A => count(0), B => count(1), Z => Z) ;


   -----------------------
   --   main stimulus   --
   -----------------------

   stimulus : process
   begin

      wait for 4*PERIOD ;   -- simply run the simulation for 4x clock cycles to explore all possible input combinations

      finish ;   -- stop the simulation (this is a VHDL2008-only feature)

      -- **IMPORTANT: the original VHDL93 standard does not provide a routine to easily stop the simulation ! You must use a failing "assertion" for this purpose
      --assert FALSE report "Simulation Finished" severity FAILURE ;

   end process ;

end architecture testbench ;

