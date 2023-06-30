--
-- A simple inverter (NOT gate) in VHDL
-- 
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--


library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)


-- entity declaration
entity Inverter is

   port (
      X  : in  std_logic ;
      ZN : out std_logic
   ) ;

end entity Inverter ;


-- architecture implementation
architecture rtl of Inverter is

begin

   -- signal assignment
   ZN <= not X ;
   --ZN <= not X after 3 ns ;   -- include 3ns propagation delay between input and output


   -- conditional signal assignment (MUX-style)
   --ZN <= '1' when X = '0' else '0' ;              -- with this code not all possible input combinations are covered
   --
   --ZN <= '1' when X = '0' else                    -- better implementation that covers all possible input combinations
   --      '0' when X = '1' else
   --      'X'   -- catch-all

end architecture rtl ;

