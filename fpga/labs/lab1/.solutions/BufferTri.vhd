--
-- VHDL description for a three-state buffer using a conditional assignment.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)

entity BufferTri is

   port (
      OE  : in  std_logic ;
      X   : in  std_logic ;
      Z   : out std_logic
   ) ;

end entity BufferTri ;


architecture rtl of BufferTri is

begin

   -- conditional signal assignment (MUX-style)
   Z <= X when OE = '1' else 'Z' ; 

end architecture rtl ;
