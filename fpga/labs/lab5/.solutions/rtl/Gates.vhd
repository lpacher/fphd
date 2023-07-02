--
-- Describe basic logic gates in VHDL using signal assignments and logic operators.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

--
-- Available VHDL basic logical operators are :
--
-- not
-- and
-- nand
-- or
-- nor
-- xor
-- xnor (introduced by VHDL93, originally not implemented in VHDL87)
--


library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)


-- entity declaration
entity Gates is

   port (
      A : in  std_logic ;
      B : in  std_logic ;
      Z : out std_logic_vector(5 downto 0)   -- note that Z is declared as a 6-bit width output BUS
   ) ;

end entity Gates ;


-- architecture implementation
architecture rtl of Gates is

begin

   -- AND
   Z(0) <= A and B ;

   -- NAND
   Z(1) <= A nand B ;      -- same as Z(1) <= not (A and B)

   -- OR
   Z(2) <= A or B ;

   -- NOR
   Z(3) <= A nor B ;       -- same as Z(3) <= not (A or B)

   -- XOR
   Z(4) <= A xor B ;

   -- XNOR
   Z(5) <= A xnor B ;      -- same as Z(5) <= not (A xor B)

end architecture rtl ;

