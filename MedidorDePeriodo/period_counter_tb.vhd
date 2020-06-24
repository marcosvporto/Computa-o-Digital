--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:50:12 05/03/2020
-- Design Name:   
-- Module Name:   /home/ise/MedidorDePeriodo/period_counter_tb.vhd
-- Project Name:  MedidorDePeriodo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: period_counter
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
 
ENTITY period_counter_tb IS
END period_counter_tb;
 
ARCHITECTURE behavior OF period_counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT period_counter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         si : IN  std_logic;
         ready : OUT  std_logic;
         done_tick : OUT  std_logic;
         period : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal si : std_logic := '0';

 	--Outputs
   signal ready : std_logic;
   signal done_tick : std_logic;
   signal period : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: period_counter PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          si => si,
          ready => ready,
          done_tick => done_tick,
          period => period
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	si_process :process
	begin
		si <= '0';
		wait for 4 ms;
		si <= '1';
		wait for 4 ms;
	end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		wait for clk_period;
		start <= '1';
		wait for clk_period;
		start <= '0';
		wait until done_tick = '1';
		
		
		

      wait;
   end process;

END;
