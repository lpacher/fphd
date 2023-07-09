--
-- VHDL code for a simple D-FlipFlop. Modify the sensitivity list of the
-- process block in order to switch between synchronous and asynchronous reset.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2020
--


library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)

-- entity declaration
entity DFF is

   port (
      clk  : in  std_logic ;     -- clock
      rst  : in  std_logic ;     -- reset, active-high (then can be synchronous or asynchronous according to sensitivity list)
      D    : in  std_logic ;
      Q    : out std_logic ;
      Qbar : out std_logic       -- optionally, generate also the inverted output
   ) ;

end entity DFF ;


-- architecture implementation
architecture behavioral of DFF is

    signal Qint : std_logic ;

begin

   -- simple FlipFlop without reset
   --process(clk)
   --begin
   --   if ( rising_edge(clk) ) then     -- use the rising_edge(clk) function in place of the verbose clk'event and clk = '1' syntax
   --      Qint <= D ; 
   --   end if ;
   --end process ;

   -- FlipFlop with SYNCHRONOUS reset
   process(clk)
   begin
      if( rising_edge(clk) ) then
         if( rst = '1') then
            Qint <= '0' ;
         else
            Qint <= D ;
         end if ;
      end if ;
   end process ;

   -- FlipFlop with ASYNCHRONOUS reset
   --process(clk,rst)
   --begin
   --   if( rst = '1' ) then
   --      Qint <= '0' ;
   --   elsif ( rising_edge(clk) ) then
   --      Qint <= D ;
   --   end if ;
   --end process ;

   -- non inverted output
   Q <= Qint ;

   -- inverted output
   Qbar <= not Qint ;

end architecture behavioral ;
