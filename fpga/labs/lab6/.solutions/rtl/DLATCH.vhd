--
-- VHDL code for a simple D-Latch. 
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)

-- entity declaration
entity DLATCH is

   port (
      D    : in  std_logic ;
      EN   : in  std_logic ;
      Q    : out std_logic ;
      Qbar : out std_logic       -- optionally, generate also the inverted output
   ) ;

end entity DLATCH ;


-- architecture implementation
architecture behavioral of DLATCH is

   signal Qint : std_logic ;

begin

   process(D,EN)
   begin
      if (EN = '1') then
         Qint <= D ;
      --else                    -- **IMPORTANT: in this case the 'else' clause is optional, if you don't specify the 'else' condition the tool automatically infers MEMORY for you!
      --     Qint <= Qint ;     --              Please not that a simple Q <= Q would be **WRONG** because in VHDL an output port can be only written. The same applies to Q <= not Q
      end if ;
   end process ;

   -- non inverted output
   Q <= Qint ;

   -- inverted output
   Qbar <= not Qint ;           -- a simpler Qbar <= not Q would be **WRONG**

end architecture behavioral ;
