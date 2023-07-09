--
-- Testbench module for 4-bit synchronous up-counter.
--
-- Luca Pacher - pacher@to.infn.it
-- Spring 2023
--

library IEEE ;
use IEEE.std_logic_1164.all ;       -- include extended logic values (by default VHDL only provides 0/1 with the 'bit' data type)

library STD ;
use STD.env.all ;                   -- the VHDL2008 revision provides stop/finish functions similar to Verilog to end the simulation

library UNISIM ;                    -- library to simulate Xilinx FPGA primitives
use UNISIM.vcomponents.all ;


entity tb_SyncCounter4b is
end entity tb_SyncCounter4b ;


architecture testbench of tb_SyncCounter4b is

   --------------------------------
   --   components declaration   --
   --------------------------------

   component ClockGen
      generic (
         PERIOD : time := 10 ns
      ) ;

      port (
         clk : out std_logic
      ) ;
   end component ClockGen ;

   component IBUF is
      port (
         I : in  std_logic ;
         O : out std_logic
      ) ;
   end component ;

   component SyncCounter4b is
      port (
         clk : in  std_logic ;
         rst : in  std_logic ;
         en  : in  std_logic ;
         Q   : out std_logic_vector(3 downto 0)
      ) ;
   end component SyncCounter4b ;


   --------------------------
   --   internal signals   --
   --------------------------

   signal clk, clk_buf : std_logic ;

   signal en      : std_logic := '0' ;
   signal rst     : std_logic := '0' ;
   signal count   : std_logic_vector(3 downto 0) ;

   --------------------------------------------------------
   --   component configuration (architecture binding)   --
   --------------------------------------------------------

   -- Ref also to: https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/VHDL-Component-Configuration
   for DUT : SyncCounter4b
      use entity work.SyncCounter4b(structural) ;        -- choose here which counter architecture to simulate
      --use entity work.SyncCounter4b(behavioral) ;

begin

   -------------------------
   --   clock generator   --
   -------------------------

   ClockGen_inst : ClockGen generic map ( PERIOD => 100 ns ) port map (clk => clk) ;  -- override default period as module parameter (default is 10.0 ns)


   ------------------------------------------------
   --   example Xilinx primitive instantiation   --
   ------------------------------------------------

   IBUF_inst : IBUF port map ( I => clk, O => clk_buf ) ;


   ---------------------------
   --   device under test   --
   ---------------------------

   DUT : SyncCounter4b  port map (clk => clk_buf, rst => rst, en => en, Q => count) ;


   ------------------
   --   stimulus   --
   ------------------

   process
   begin

      wait for 100 ns ; rst <= '1' ;              -- assert the reset
      wait for 150 ns ; rst <= '0' ;              -- release the reset

      wait for 500 ns ; en  <= '1' ;              -- enable counting

      wait for 500 ns ; en  <= '0' ;              -- pause
      wait for 500 ns ; en  <= '1' ;              -- restart

      wait for (20*100ns + 17 ns) ; rst <= '1' ;  -- explore all possible output codes, then assert an asynchronous reset and check what happens

      wait for 500 ns ; finish ;                  -- stop the simulation (this is a VHDL2008-only feature)

      -- **IMPORTANT: the original VHDL93 standard does not provide a routine to easily stop the simulation ! You must use a failing "assertion" for this purpose
      --wait for 500 ns ; assert FALSE report "Simulation Finished" severity FAILURE ;

   end process ;

end architecture testbench ;
