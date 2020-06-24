--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:11:12 06/16/2020
-- Design Name:   
-- Module Name:   /home/ise/CPU/u_memory_tb.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: u_memory
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
 
ENTITY u_memory_tb IS
END u_memory_tb;
 
ARCHITECTURE behavior OF u_memory_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT u_memory
    PORT(
         CLOCK : IN  std_logic;
         ADDR : IN  std_logic_vector(4 downto 0);
         DATA : IN  std_logic_vector(4 downto 0);
         WE : IN  std_logic;
         Q : OUT  std_logic_vector(4 downto 0);
         LAST_ADDRESS : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal ADDR : std_logic_vector(4 downto 0) := (others => '0');
   signal DATA : std_logic_vector(4 downto 0) := (others => '0');
   signal WE : std_logic := '0';

 	--Outputs
   signal Q : std_logic_vector(4 downto 0);
   signal LAST_ADDRESS : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: u_memory PORT MAP (
          CLOCK => CLOCK,
          ADDR => ADDR,
          DATA => DATA,
          WE => WE,
          Q => Q,
          LAST_ADDRESS => LAST_ADDRESS
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 
		ADDR <= "00000";
		
		wait for CLOCK_period*2;
		ADDR <= "00001";

      wait;
   end process;

END;
