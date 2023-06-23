--
-- Example VHDL wrapper to show how to instantiate and simulate Xilinx FPGA device
-- primitives in VHDL or in a mixed-language project.
-- In this case the code "wrappers" a global-buffer BUFG cell available in the FPGA
-- in order to buffer the PLL output clock.
--
-- Note the usage of the pre-compiled Xilinx UNISIM library in order to resolve
-- and simulate FPGA device primitives as VHDL external components.
--
-- Luca Pacher - pacher@to.infn.it
-- Fall 2020
--


-- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)
library IEEE ;
use IEEE.std_logic_1164.all ;


-- external library required to simulate Xilinx FPGA device primitives
library UNISIM ;
use UNISIM.vcomponents.all ;


entity ClockBuffer is

   port (
      ClkIn  : in  std_logic ;
      ClkOut : out std_logic
   ) ;

end entity ClockBuffer ;


architecture rtl of ClockBuffer is

   component BUFG is
      port (
         I : in std_logic ;
         O : out std_logic
      ) ;
   end component ;

begin

   BUFG_inst : BUFG port map(I => ClkIn, O => ClkOut) ;   -- simply instantiate the device primitive

end architecture rtl ;

