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


architecture if_else of MUX2 is

begin

   ---------------------------------
   --   if/else behavioral code   --
   ---------------------------------

   --process(all)    -- VHDL-2008 only feature
   process(A,B,S)  -- **IMPORTANT: this is a COMBINATIONAL block, all signals contribute to the SENSITIVITY LIST
   begin
      if(S = '0') then
         Z <= A ;
      else
         Z <= B ;
      end if ;
   end process ;

end architecture if_else ;
-----------------------------------------------------------------


architecture when_else of MUX2 is

begin

   ------------------------------------------
   --   when/else conditional assignment   --
   ------------------------------------------

   Z <= A  when S = '0' else
        B  when S = '1' else
        'X' ;   -- catch-all

end architecture when_else ;
-----------------------------------------------------------------


architecture with_select of MUX2 is

begin

   --------------------------------------------
   --   with/select conditional assignment   --
   --------------------------------------------

   with S select

      Z <= A when '0',
           B when '1',
           'X' when others ;   -- catch-all

end architecture with_select ;
-----------------------------------------------------------------


architecture truth_table of MUX2 is

   signal SAB : std_logic_vector(2 downto 0) ;


begin

   SAB <= S & A & B ;   -- concatenation


   --------------------------------------
   --   truth table (case statement)   --
   --------------------------------------

   process(A,B,S)
   begin

      case( SAB ) is

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

end architecture truth_table ;
-----------------------------------------------------------------


architecture logic_equation of MUX2 is

   -- internal signals
   signal Sbar : std_logic ;    -- not S
   signal w1   : std_logic ;    -- A and Sbar
   signal w2   : std_logic ;    -- B and S

begin

   ------------------------
   --   logic equation   --
   ------------------------

   --Z <= (A and (not S)) or (B and S) ;

   Sbar <= not S after 1ns ;

   w1 <= A and Sbar after 1ns ;
   w2 <= B and S    after 1ns ;
   w3 <= A and B    after 1ns ;

   Z  <= w1 or w2 after 1ns ;

end architecture logic_equation ;

