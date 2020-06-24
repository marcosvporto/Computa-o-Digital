--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:47:10 04/06/2020
-- Design Name:   
-- Module Name:   /home/ise/Lab03/debounce_tb.vhd
-- Project Name:  Lab03
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debounce
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
 
ENTITY debounce_tb IS
END debounce_tb;
 
ARCHITECTURE behavior OF debounce_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debounce
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         sw : IN  std_logic;
         db : OUT  std_logic;
         tick : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sw : std_logic := '1';

 	--Outputs
   signal db : std_logic;
   signal tick : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
		--constant DEB_H : time := 2.5 ms;
   	--constant DEB_L : time := 1.5 ms;
   	--constant STABLE : time := 10 ms;

			constant DEB_H : time := 0.25 ms;
		   constant DEB_L : time := 0.15 ms;
		   constant STABLE : time := 1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debounce PORT MAP (
          clk => clk,
          reset => reset,
          sw => sw,
          db => db,
          tick => tick
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
		
		wait for STABLE;
		SW <= '0'; wait for DEB_H; SW <= '1'; wait for DEB_L;
		SW <= '0';
		wait for STABLE;
		SW <= '1'; wait for DEB_H; SW <= '0'; wait for DEB_L;
      SW <= '1';
      wait for STABLE;
		
      

      wait;
   end process;

END;
