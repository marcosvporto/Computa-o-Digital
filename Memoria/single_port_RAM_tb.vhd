--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:26:12 03/29/2020
-- Design Name:   
-- Module Name:   /home/ise/Memoria/single_port_RAM_tb.vhd
-- Project Name:  Memoria
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: single_port_RAM
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
 
ENTITY single_port_RAM_tb IS
END single_port_RAM_tb;
 
ARCHITECTURE behavior OF single_port_RAM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT single_port_RAM
    PORT(
         CLK : IN  std_logic;
         DATA_IN : IN  std_logic_vector(7 downto 0);
         ADDR : IN  std_logic_vector(6 downto 0);
         WE : IN  std_logic;
         DATA_OUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal DATA_IN : std_logic_vector(7 downto 0) := (others => '0');
   signal ADDR : std_logic_vector(6 downto 0) := (others => '0');
   signal WE : std_logic := '0';

 	--Outputs
   signal DATA_OUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: single_port_RAM PORT MAP (
          CLK => CLK,
          DATA_IN => DATA_IN,
          ADDR => ADDR,
          WE => WE,
          DATA_OUT => DATA_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		
		
		ADDR <= "1111111";
		
		DATA_IN <= "10101010";
		
		wait for CLK_period*10;
		
		WE <= '1';
		
		wait for CLK_period*10;
		
		WE <= '0';
		
		wait for CLK_period*10;
		
		DATA_IN <= "00000000";
		
		wait for CLK_period*10;
		
		ADDR <= "0000000";
		
		
		wait for CLK_period*10;
		
		ADDR <= "0010000";
		
		wait for CLK_period*10;
		
		ADDR <= "1111111";
		
		
		

      wait;
   end process;

END;
