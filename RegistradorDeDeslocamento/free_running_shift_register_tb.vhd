--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:16:01 03/29/2020
-- Design Name:   
-- Module Name:   /home/ise/RegistradorDeDeslocamento/free_running_shift_register_tb.vhd
-- Project Name:  RegistradorDeDeslocamento
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: free_running_shift_register
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
 
ENTITY free_running_shift_register_tb IS
END free_running_shift_register_tb;
 
ARCHITECTURE behavior OF free_running_shift_register_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT free_running_shift_register
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         serial_in : IN  std_logic;
         parallel_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal serial_in : std_logic := '0';

 	--Outputs
   signal parallel_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: free_running_shift_register PORT MAP (
          clk => clk,
          reset => reset,
          serial_in => serial_in,
          parallel_out => parallel_out
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
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		serial_in <= '1';
		
		wait for clk_period;
		
		serial_in <= '0';
		
		wait for clk_period;
		
		reset <= '1';
		
		wait for clk_period*10;

      wait;
   end process;

END;
