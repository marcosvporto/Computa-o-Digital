--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:32:29 04/12/2020
-- Design Name:   
-- Module Name:   /home/ise/lab04/sevenSeg_hex_mux_tb.vhd
-- Project Name:  lab04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sevenSeg_hex_mux
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
 
ENTITY sevenSeg_hex_mux_tb IS
END sevenSeg_hex_mux_tb;
 
ARCHITECTURE behavior OF sevenSeg_hex_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sevenSeg_hex_mux
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         hex0 : IN  std_logic_vector(3 downto 0);
         hex1 : IN  std_logic_vector(3 downto 0);
         dp_in : IN  std_logic_vector(1 downto 0);
         an : OUT  std_logic;
         sseg : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal hex0 : std_logic_vector(3 downto 0) := (others => '0');
   signal hex1 : std_logic_vector(3 downto 0) := (others => '0');
   signal dp_in : std_logic_vector(1 downto 0) := (others => '0');
   signal an : std_logic := '0';
   signal sseg : std_logic_vector(7 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sevenSeg_hex_mux PORT MAP (
          clk => clk,
          reset => reset,
          hex0 => hex0,
          hex1 => hex1,
          dp_in => dp_in,
          an => an,
          sseg => sseg
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

		hex0 <= "0111"; -- 7
		hex1 <= "0101"; -- 5
		dp_in<= "11";
      wait;
   end process;

END;
