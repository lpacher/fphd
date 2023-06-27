--
-- Simple testbench for the Inverter module
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

library IEEE ;
use IEEE.std_logic_1164.all ;   -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)

library STD ;
use STD.env.all ;               -- the VHDL2008 revision provides stop/finish functions similar to Verilog to end the simulation


entity tb_Inverter is   -- empty entity declaration for a testbench
end entity tb_Inverter ;


architecture testbench of tb_Inverter is

   --------------------------------
   --   components declaration   --
   --------------------------------

   component Inverter
      port (
         X  : in  std_logic ;
         ZN : out std_logic
      ) ;
   end component ;


   --------------------------
   --   internal signals   --
   --------------------------

   signal X  : std_logic ;
   signal ZN : std_logic ;


begin


   ---------------------------------
   --   device under test (DUT)   --
   ---------------------------------
   
   --DUT : Inverter port map (X, ZN) ;            -- ORDERED (positional) port mapping
   DUT : Inverter port map (X => X, ZN => ZN) ;   -- BY-NAME port mapping


   -----------------------
   --   main stimulus   --
   -----------------------

   stimulus : process
   begin
   
      wait for 500 ns ; X <= '0' ;
      wait for 200 ns ; X <= '1' ;
      wait for 750 ns ; X <= '0' ;

      wait for 500 ns ; finish ;     -- stop the simulation (this is a VHDL2008-only feature)

      -- **IMPORTANT: the original VHDL93 standard does not provide a routine to easily stop the simulation ! You must use a failing "assertion" for this purpose
      --wait for 500 ns ; assert FALSE report "Simulation Finished" severity FAILURE ;

   end process ;

end architecture testbench ;

