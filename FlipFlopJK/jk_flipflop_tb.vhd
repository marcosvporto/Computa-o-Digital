--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:05:44 05/04/2020
-- Design Name:   
-- Module Name:   /home/ise/FlipFlopJK/jk_flipflop_tb.vhd
-- Project Name:  FlipFlopJK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: jk_flipflop
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY jk_flipflop_tb IS
END jk_flipflop_tb;
 
ARCHITECTURE behavior OF jk_flipflop_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT jk_flipflop
    PORT(
         clk : IN  std_logic;
         j : IN  std_logic;
         k : IN  std_logic;
         q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal j : std_logic := '0';
   signal k : std_logic := '0';

 	--Outputs
   signal q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: jk_flipflop PORT MAP (
          clk => clk,
          j => j,
          k => k,
          q => q
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		-- set
		j <= '1';
		k <= '0';
		wait for clk_period*10;
		-- reset
		j <= '0';
		k <= '1';
		wait for clk_period*10;
		--latch
		j <= '0';
		k <= '0';
		wait for clk_period*10;
		-- toggle
		j <= '1';
		k <= '1';
		wait for clk_period*10;
		-- reset
		j <= '0';
		k <= '1';
		wait for clk_period*10;
		-- set
		j <= '1';
		k <= '0';
		wait for clk_period*10;
		
      wait;
   end process;

END;
