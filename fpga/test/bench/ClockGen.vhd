--
-- Example clock-generator in VHDL with parameterized clock period.
-- The default clock frequency is 100 MHz (Digilent Arty A7 on-board
-- XTAL oscillator). Override the default value of the PERIOD generic
-- when instantiating the block into a testbench in order to change
-- the frequency of the clock signal as needed.
--
-- Luca Pacher - pacher@to.infn,it
-- Fall 2020
--
--


-- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)
library IEEE ;
use IEEE.std_logic_1164.all ;


entity ClockGen is

   generic (
      PERIOD : time := 10.0 ns
   ) ;

   port (
      clk : out std_logic
   ) ;

end entity ClockGen ;


architecture stimulus of ClockGen is

begin

   process   -- process without sensitivity list
   begin

      clk <= '0' ;
      wait for PERIOD/2 ;   -- simply toggle clk signal every half-period
      clk <= '1' ;
      wait for PERIOD/2 ;

   end process ;

end architecture stimulus ;

