--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:52:35 06/15/2020
-- Design Name:   
-- Module Name:   /home/ise/CPU/main_tb.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
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
 
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         LED_CLOCK_OUT : OUT  std_logic;
         LED_ZERO : OUT  std_logic;
         LED_NEGATIVO : OUT  std_logic;
         LED_P30 : OUT  std_logic_vector(4 downto 0);
         SF_D : OUT  std_logic_vector(11 downto 8);
         LCD_E : OUT  std_logic;
         LCD_RS : OUT  std_logic;
         LCD_RW : OUT  std_logic;
         SF_CE0 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';

 	--Outputs
   signal LED_CLOCK_OUT : std_logic;
   signal LED_ZERO : std_logic;
   signal LED_NEGATIVO : std_logic;
   signal LED_P30 : std_logic_vector(4 downto 0);
   signal SF_D : std_logic_vector(11 downto 8);
   signal LCD_E : std_logic;
   signal LCD_RS : std_logic;
   signal LCD_RW : std_logic;
   signal SF_CE0 : std_logic;

   -- Clock period definitions
   constant CLOCK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          CLOCK => CLOCK,
          RESET => RESET,
          LED_CLOCK_OUT => LED_CLOCK_OUT,
          LED_ZERO => LED_ZERO,
          LED_NEGATIVO => LED_NEGATIVO,
          LED_P30 => LED_P30,
          SF_D => SF_D,
          LCD_E => LCD_E,
          LCD_RS => LCD_RS,
          LCD_RW => LCD_RW,
          SF_CE0 => SF_CE0
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
     
		reset <= '1';
		wait for 25 ms;
		reset <= '0';

      wait;
   end process;

END;
