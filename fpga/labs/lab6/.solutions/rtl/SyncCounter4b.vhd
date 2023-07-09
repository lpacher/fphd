--
-- Example VHDL implementation for a simple 4-bit synchronous up-counter using
-- either structural or behavioral coding styles.
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

   -- SYNCHRONOUS reset
   process(clk)
   begin
      if( rising_edge(clk) ) then   -- use the rising_edge(clk) function in place of the verbose clk'event and clk = '1' syntax
         if( rst = '1') then
            Qint <= '0' ;
         else
            Qint <= D ;
         end if ;
      end if ;
   end process ;

   -- ASYNCHRONOUS reset
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
-----------------------------------------------------------------


library IEEE ;
use IEEE.std_logic_1164.all ;

entity TFF is

   port (
      clk : in  std_logic ;
      rst : in  std_logic ;
      T   : in  std_logic ;
      Q   : out std_logic
   ) ;

end entity TFF ;


-----------------------------------
--   structural implementation   --
-----------------------------------
architecture structural of TFF is

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

   -- extra signals for internal wiring
   signal Dint : std_logic ;
   signal Qint : std_logic ;

begin

   ff : DFF port map ( clk => clk, rst => rst, D => Dint, Q => Qint, Qbar => open ) ;    -- use the 'open' clause to leave output ports unconnected

   Dint <= T xor Qint ;
   Q <= Qint ;

end architecture structural ;


-----------------------------------
--   behavioral implementation   --
-----------------------------------
architecture behavioral of TFF is

   signal Dint : std_logic ;
   signal Qint : std_logic ;

begin

   Dint <= T xor Qint ;

   -- SYNCHRONOUS reset
   process(clk)
   begin
      if( rising_edge(clk) ) then
         if( rst = '1' ) then
            Qint <= '0' ;
         else
            Qint <= Dint ;
         end if ;
      end if ;
   end process ;

   -- ASYNCHRONOUS reset
   -- process(clk,rst)
   --begin
   --   if( rst = '1' ) then
   --      Qint <= '0' ;
   --   else
   --      Qint <= Dint ;
   --end process ;

   Q <= Qint ;

end architecture behavioral ;
-----------------------------------------------------------------


library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.numeric_std.all ;

--use IEEE.std_logic_arith.all ;     **DEPRECATED**
--use IEEE.std_logic_signed.all ;    **DEPRECATED**
--use IEEE.std_logic_unsigned.all ;  **DEPRECATED** (see below)

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

entity SyncCounter4b is

   port (
      clk : in  std_logic ;
      rst : in  std_logic ;
      en  : in  std_logic ;
      Q   : out std_logic_vector(3 downto 0)
   ) ;

end entity SyncCounter4b ;


-----------------------------------
--   structural implementation   --
-----------------------------------
architecture structural of SyncCounter4b is

   -- component declaration
   component TFF is
      port (
         clk  : in  std_logic ;
         rst  : in  std_logic ;
         T    : in  std_logic ;
         Q    : out std_logic
      ) ;
   end component TFF ;

   -- 4-bit buses for internal wiring
   signal Tint : std_logic_vector(3 downto 0) ;
   signal Qint : std_logic_vector(3 downto 0) ;


   ---------------------------------
   --   component configuration   --
   ---------------------------------

   -- Ref also to: https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/VHDL-Component-Configuration
   for all : TFF use entity work.TFF(structural) ;      -- choose here which TFF architecture to simulate
   --for all : TFF use entity work.TFF(behavioral) ;

begin

   Tint(0) <= en ;
   Tint(1) <= Qint(0) and Tint(0) ;
   Tint(2) <= Qint(1) and Tint(1) ;
   Tint(3) <= Qint(2) and Tint(2) ;

   ff_0 : TFF port map ( clk => clk, rst => rst, T => Tint(0), Q => Qint(0) ) ;
   ff_1 : TFF port map ( clk => clk, rst => rst, T => Tint(1), Q => Qint(1) ) ;
   ff_2 : TFF port map ( clk => clk, rst => rst, T => Tint(2), Q => Qint(2) ) ;
   ff_3 : TFF port map ( clk => clk, rst => rst, T => Tint(3), Q => Qint(3) ) ;

   Q <= Qint ;

end architecture structural ;


-----------------------------------
--   behavioral implementation   --
-----------------------------------
architecture behavioral of SyncCounter4b is

   -- **NOTE: 4-bit "internal" counter declared as a "VHDL unsigned" to work with IEEE.numeric_std
   signal count : unsigned(3 downto 0) ;                -- uninitialized count value
   --signal count : unsigned(3 downto 0) := "0000" ;    -- initialized count value (you can also use (others => '0') which is smarter)

begin

   process(clk)
   begin
      if( rising_edge(clk) ) then

         if( rst = '1' ) then
            count <= "0000" ;
            --count <= (others => '0' ) ;

         elsif ( en = '1' ) then
            count <= count + 1 ;    -- **NOTE: be aware of the usage of + 1 and not + '1'

         -- else ? Keep memory ! Same as else count <= count ; end if ;
         end if ;
      end if ;
   end process ;

   --
   -- EXERCISE: implement the same counter but with ASYNCHRONOUS reset
   --
   --process(clk,rst)
   --begin
   --
   --   if( rst = '1' ) then
   --      count <= (others => '0') ;
   --
   --   elsif( rising_edge(clk) ) then
   --         count <= count + 1 ;
   --   end if ;
   --end process ;
   --

   -- type casting
   Q <= std_logic_vector(count) ;   -- convert "unsigned" to "std_logic_vector" using the "std_logic_vector()" function from IEEE.numeric_std

   -- **NOTE: due to VHDL strong data typing this gives a **COMPILATION ERROR** instead :
   -- Q <= count ;

end architecture behavioral ;
