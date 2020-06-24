--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:55:18 05/03/2020
-- Design Name:   
-- Module Name:   /home/ise/MedidorDePeriodo/division_fsmd_tb.vhd
-- Project Name:  MedidorDePeriodo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: division_fsmd
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
 
ENTITY division_fsmd_tb IS
END division_fsmd_tb;
 
ARCHITECTURE behavior OF division_fsmd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT division_fsmd
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         divisor : IN  std_logic_vector(7 downto 0);
         dividend : IN  std_logic_vector(7 downto 0);
         ready : OUT  std_logic;
         done_tick : OUT  std_logic;
         quotient : OUT  std_logic_vector(7 downto 0);
         remainder : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal divisor : std_logic_vector(7 downto 0) := (others => '0');
   signal dividend : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal ready : std_logic;
   signal done_tick : std_logic;
   signal quotient : std_logic_vector(7 downto 0);
   signal remainder : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: division_fsmd PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          divisor => divisor,
          dividend => dividend,
          ready => ready,
          done_tick => done_tick,
          quotient => quotient,
          remainder => remainder
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
		
		reset <= '1';
		wait for clk_period*2;
		reset <= '0';
		wait for clk_period*2;
		dividend	<= "11110000";
		divisor	<= "01010000";
		wait for clk_period;
		start	<= '1';
		wait for clk_period;
		start	<= '0';
		wait until done_tick = '1';
		
		

      wait;
   end process;

END;
