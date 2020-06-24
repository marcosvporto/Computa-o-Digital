--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:34:49 05/03/2020
-- Design Name:   
-- Module Name:   /home/ise/ConversorBinarioBCD/bin2bcd_tb.vhd
-- Project Name:  ConversorBinarioBCD
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bin2bcd
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
 
ENTITY bin2bcd_tb IS
END bin2bcd_tb;
 
ARCHITECTURE behavior OF bin2bcd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bin2bcd
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         bin : IN  std_logic_vector(12 downto 0);
         bcd0 : OUT  std_logic_vector(3 downto 0);
         bcd1 : OUT  std_logic_vector(3 downto 0);
         bcd2 : OUT  std_logic_vector(3 downto 0);
         bcd3 : OUT  std_logic_vector(3 downto 0);
         ready : OUT  std_logic;
         done_tick : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal bin : std_logic_vector(12 downto 0) := (others => '0');

 	--Outputs
   signal bcd0 : std_logic_vector(3 downto 0);
   signal bcd1 : std_logic_vector(3 downto 0);
   signal bcd2 : std_logic_vector(3 downto 0);
   signal bcd3 : std_logic_vector(3 downto 0);
   signal ready : std_logic;
   signal done_tick : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bin2bcd PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          bin => bin,
          bcd0 => bcd0,
          bcd1 => bcd1,
          bcd2 => bcd2,
          bcd3 => bcd3,
          ready => ready,
          done_tick => done_tick
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

		reset	<= '1';
		wait for clk_period*2;
		reset	<= '0';
		wait for clk_period*2;
		bin	<= "1011101010011" ;
		wait for clk_period*2;
		start <= '1';
		wait for clk_period;
		start <= '0';
		
		wait until done_tick= '1';
		
		wait for clk_period*2;
		
      wait;
   end process;

END;
