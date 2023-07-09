--
-- Testbench for different MUX2 implementations.
-- Update the 'configuration' section to select which
-- architecture implementation to simulate.
--
-- Luca Pacher - pacher@to.infn.it
-- Fall 2020
--

--
-- **IMPORTANT !
--
-- By default VHDL provides the + (plus) operator to perform basic additions between
-- software-like NUMBERS (e.g. 32-bit "integer" data type, but also "natural"
-- or "positive", as well as "real" numbers).
-- Due to VHDL strong data typing the usage of + between "hardware signals" (buses)
-- requires the OVERLOADING of the + operator.
--
-- As an example, a very simple
--
--    count <= count + 1 ;
--
-- is NOT allowed in VHDL if count has been declared as std_logic_vector.
--
-- In order to perform + between "hardware signals", the "legacy" VHDL introduced
-- new "vector" data types called "std_logic_signed" and "std_logic_usigned" that
-- are defined as part of IEEE.std_logic_unsigned and IEEE.std_logic_unsigned packages.
--
-- By including these packages in the preamble of the VHDL code one can declare counters
-- as std_logic_vector and the following syntax (note the usage of single quotes)
--
--    count <= count + '1' ;
--
-- properly compiles. HOWEVER, in practice the usage of these packages has been
-- de facto **DEPRACTED** for the following reasons :
--
--   1. despite the library name "IEEE" these packages are **NOT** provided
--      by IEEE, but are Synopsys proprietary !
--
--   2. despite the string "std" in (Synopsys) package names they are **NOT**
--      IEEE standard at all !
--
-- This is the reason for which the **RECOMMENDED** package to be used when dealing
-- with counters is IEEE.numeric_std that introduces new VHDL data types SIGNED and
-- UNSIGNED along with IEEE-standard definitions to overload fundamental arithmetic
-- operators such as + and - that are extensively used to generate real hardware.
--
-- For this simple testbench we still demonstrate the usage of IEEE.std_logic_unsigned
-- while later in the course IEEE.numeric_std will be adopted.
--

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_unsigned.all ;   -- to use + operator between std_logic_vector data type

library STD ;
use STD.env.all ;                   -- the VHDL2008 revision provides stop/finish functions similar to Verilog to end the simulation

library work ;
use work.all ;


entity tb_MUX2 is
end entity tb_MUX2 ;


architecture testbench of tb_MUX2 is


   --------------------------------
   --   components declaration   --
   --------------------------------

   component MUX2
      port (
         A : in  std_logic ;
         B : in  std_logic ;
         S : in  std_logic ;
         Z : out std_logic
      ) ;
   end component ;


   component ClockGen
      generic (
         PERIOD : time := 10 ns
      ) ;

      port (
         clk : out std_logic
      ) ;
   end component ;


   --------------------------
   --   internal signals   --
   --------------------------

   signal clk : std_logic ;

   signal sel : std_logic := '1' ;
   signal Z   : std_logic ;

   signal count : std_logic_vector(1 downto 0) := "00" ;


   --------------------------------------------------------
   --   component configuration (architecture binding)   --
   --------------------------------------------------------

   -- choose here which MUX2 architecture to simulate
   for DUT : MUX2
      use entity work.MUX2(if_else) ;
      --use entity work.MUX2(when_else) ;
      --use entity work.MUX2(with_select) ;
      --use entity work.MUX2(truth_table) ;
      --use entity work.MUX2(logic_equation) ;


begin


   ---------------------------------
   --   100 MHz clock generator   --
   ---------------------------------

   ClockGen_inst : ClockGen port map (clk => clk) ;


   -----------------------
   --   2-bit counter   --
   -----------------------

   process(clk)
   begin

      if( rising_edge(clk) ) then
         count <= count + '1' ;
      end if;

    end process ;


   ---------------------------------
   --   device under test (DUT)   --
   ---------------------------------

   DUT : MUX2 port map (A => count(0), B => count(1), S => sel, Z => Z) ;
   --DUT : MUX2 port map ( A => '1', B => '1', S => sel, Z => Z) ;

   -----------------------
   --   main stimulus   --
   -----------------------

   stimulus : process
   begin
      wait for 500 ns ; sel <= '0' ;
      wait for 450 ns ; sel <= '1' ;
      wait for 500 ns ; sel <= '0' ;
      wait for 450 ns ; sel <= '1' ;
      wait for 500 ns ; finish ;
   end process ;

end architecture testbench ;


--
-- **NOTE
--
-- The component configuration can be also performed outside the architecture body
-- which instantiates a certain component (aka "external" configuration declaration).
-- However this seems to be NOT supported by Xilinx Vivado. Only for reference.
--

--
--library work ;
--use work.all ;
--
--configuration tb_MUX2_config of tb_MUX2 is
--
--   for testbench
--      for DUT : MUX2
--
--         -- choose here which MUX2 architecture to simulate
--         use entity work.MUX2(if_else) ;
--         --use entity work.MUX2(when_else) ;
--         --use entity work.MUX2(with_select) ;
--         --use entity work.MUX2(truth_table) ;
--         --use entity work.MUX2(logic_equation) ;
--
--      end for ;
--   end for ;
--end configuration tb_MUX2_config ;
--
