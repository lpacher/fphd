--
-- Example VHDL implementation for a simple 4-bit asynchronous ripple counter using structural code.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
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

   -- ASYNCHRONOUS reset
   process(clk,rst)
   begin
      if( rst = '1' ) then
         Qint <= '0' ;
      elsif ( rising_edge(clk) ) then -- use the rising_edge(clk) function in place of the verbose clk'event and clk = '1' syntax
         Qint <= D ;
      end if ;
   end process ;

   --
   -- EXERCISE: simulate the same design with SYNCHRONOUS reset FlipFlops. What happens ?
   --
   --process(clk)
   --begin
   --   if( rising_edge(clk) ) then
   --      if( rst = '1') then
   --         Qint <= '0' ;
   --      else
   --         Qint <= D ;
   --      end if ;
   --   end if ;
   --end process ;



   -- non inverted output
   Q <= Qint ;

   -- inverted output
   Qbar <= not Qint ;

end architecture behavioral ;
-----------------------------------------------------------------


-- if you want to implement more entities into the same file before each entity you have to declare used libraries
library IEEE ;
use IEEE.std_logic_1164.all ;

entity RippleCounter4b is

   port (
      clk : in  std_logic ;
      rst : in  std_logic ;
      Q   : out std_logic_vector(3 downto 0)
   ) ;

end entity RippleCounter4b ;

architecture structural of RippleCounter4b is

   -- component declaration
   component DFF is
      port (
         clk  : in  std_logic ;
         rst  : in  std_logic ;
         D    : in  std_logic ;
         Q    : out std_logic ;
         Qbar : out std_logic
      ) ;
   end component DFF ;

   -- 4-bit bus for internal wiring
   signal Qbar : std_logic_vector(3 downto 0) ;

begin

   --------------------
   --   up-counter   --
   --------------------

   ff_0 : DFF port map ( rst => rst, clk => clk    , D => Qbar(0), Q => Q(0), Qbar => Qbar(0) ) ;
   ff_1 : DFF port map ( rst => rst, clk => Qbar(0), D => Qbar(1), Q => Q(1), Qbar => Qbar(1) ) ;
   ff_2 : DFF port map ( rst => rst, clk => Qbar(1), D => Qbar(2), Q => Q(2), Qbar => Qbar(2) ) ;
   ff_3 : DFF port map ( rst => rst, clk => Qbar(2), D => Qbar(3), Q => Q(3), Qbar => Qbar(3) ) ;


   ----------------------
   --   down-counter   --
   ----------------------

   --ff_0 : DFF port map ( rst => rst, clk => clk , D => Qbar(0), Q => Q(0), Qbar => Qbar(0) ) ;
   --ff_1 : DFF port map ( rst => rst, clk => Q(0), D => Qbar(1), Q => Q(1), Qbar => Qbar(1) ) ;
   --ff_2 : DFF port map ( rst => rst, clk => Q(1), D => Qbar(2), Q => Q(2), Qbar => Qbar(2) ) ;
   --ff_3 : DFF port map ( rst => rst, clk => Q(2), D => Qbar(3), Q => Q(3), Qbar => Qbar(3) ) ;

end architecture structural ;

