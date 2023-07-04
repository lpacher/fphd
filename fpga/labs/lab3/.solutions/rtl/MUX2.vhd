--
-- VHDL description of a simple 2:1 multiplexer using different coding styles.
-- Different architectures are used, one for each proposed implementation.
-- The actual architecture to be simulated/implemented is then selected using
-- a VHDL "component configuration" statement in the testbench/top-level wrapper.
--
-- Luca Pacher - pacher@to.ifn.it
-- Spring 2023
--


library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)


entity MUX2 is

   port (
      A : in  std_logic ;
      B : in  std_logic ;
      S : in  std_logic ;   -- select bit
      Z : out std_logic
   ) ;

end entity MUX2 ;


---------------------------------
--   if/else behavioral code   --
---------------------------------
architecture if_else of MUX2 is
begin

   --process(all)    -- VHDL-2008 only feature
   process(A,B,S)  -- **IMPORTANT: this is a COMBINATIONAL block, all signals contribute to the SENSITIVITY LIST
   begin
      if(S = '0') then
         Z <= A ;
      else
         Z <= B ;
      end if ;
   end process ;

--
--   process(A,B,S)
--   begin
--      if(S = '0') then
--         Z <= A ;
--      elsif(S = '1') then
--         Z <= B ;
--      else
--         Z <= 'X'
--      end if ;
--   end process ;
--

end architecture if_else ;
-----------------------------------------------------------------


------------------------------------------
--   when/else conditional assignment   --
------------------------------------------
architecture when_else of MUX2 is
begin


   Z <= A  when S = '0' else
        B  when S = '1' else
        'X' ;   -- catch-all

end architecture when_else ;
-----------------------------------------------------------------


--------------------------------------------
--   with/select conditional assignment   --
--------------------------------------------
architecture with_select of MUX2 is
begin

   with S select

      Z <= A when '0' ,
           B when '1' ,
           'X' when others ;   -- catch-all

end architecture with_select ;
-----------------------------------------------------------------


--------------------------------------
--   truth table (case statement)   --
--------------------------------------
architecture truth_table of MUX2 is

   signal code : std_logic_vector(2 downto 0) ;

begin

   code <= S & A & B ;   -- concatenation

   process(A.B,S)
   begin

      case( code ) is

         when "000" => Z <= '0' ;   -- A
         when "001" => Z <= '0' ;   -- A
         when "010" => Z <= '1' ;   -- A
         when "011" => Z <= '1' ;   -- A
         when "100" => Z <= '0' ;   -- B
         when "101" => Z <= '1' ;   -- B
         when "110" => Z <= '0' ;   -- B
         when "111" => Z <= '1' ;   -- B

         -- catch-all
         when others => Z <= 'X' ;

      end case ;
   end process ;

--
--   with code select
--
--      Z <= '0' when "000" ,
--           '0' when "001" ,
--           '1' when "010" ,
--           '1' when "011" ,
--           '0' when "100" ,
--           '1' when "101" ,
--           '0' when "110" ,
--           '1' when "111" ,
--           'X' when others ;   -- catch-all
--

end architecture truth_table ;
-----------------------------------------------------------------


------------------------
--   logic equation   --
------------------------
architecture logic_equation of MUX2 is

   -- internal signals
   signal Sbar : std_logic ;    -- not S
   signal w1   : std_logic ;    -- A and Sbar
   signal w2   : std_logic ;    -- B and S
   --signal w3   : std_logic ;

begin

   --Z <= (A and (not S)) or (B and S) ;

   Sbar <= not S after 1ns ;

   w1 <= A and Sbar after 1ns ;
   w2 <= B and S    after 1ns ;
   --w3 <= A and B    after 1ns ;   -- fix static-1 timing hazard

   Z  <= w1 or w2 after 1ns ;
   --Z <= w1 or w2 or w3 after 1ns ;   -- fix static-1 timing hazard

end architecture logic_equation ;
-----------------------------------------------------------------
