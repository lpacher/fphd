--
-- Example clock-generator in VHDL with parameterized clock period.
--
-- Luca Pacher - pacher@to.infn,it
-- Fall 2020
--
-- **NOTE: Default clock frequency is 100 MHz (Digilent Arty A7 on-board master clock)
--

library IEEE ;
use IEEE.std_logic_1164.all ;


entity ClockGen is

   generic (
      PERIOD : time := 10 ns
   ) ;

   port (
      clk : out std_logic
   ) ;

end entity ClockGen ;


architecture stimulus of ClockGen is


   --constant PERIOD : time := 10 ns ;   -- moved to generic

begin

   process   -- process without sensitivity list
   begin

      clk <= '0' ;
      wait for PERIOD/2 ;   -- simply toggle clk signal every half-period
      clk <= '1' ;
      wait for PERIOD/2 ;

   end process ;

end architecture stimulus ;

