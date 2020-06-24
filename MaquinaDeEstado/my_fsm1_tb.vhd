--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:20:26 03/29/2020
-- Design Name:   
-- Module Name:   /home/ise/MaquinaDeEstado/my_fsm1_tb.vhd
-- Project Name:  MaquinaDeEstado
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_fsm1
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
 
ENTITY my_fsm1_tb IS
END my_fsm1_tb;
 
ARCHITECTURE behavior OF my_fsm1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT my_fsm1
    PORT(
         TOG_EN : IN  std_logic;
         CLK : IN  std_logic;
         CLR : IN  std_logic;
         Z1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal TOG_EN : std_logic := '0';
   signal CLK : std_logic := '0';
   signal CLR : std_logic := '0';

 	--Outputs
   signal Z1 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: my_fsm1 PORT MAP (
          TOG_EN => TOG_EN,
          CLK => CLK,
          CLR => CLR,
          Z1 => Z1
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
		
		
		TOG_EN <= '1';
	
		wait for CLK_period*5;
		
		TOG_EN <= '0';
		
		wait for CLK_period*5;
		
		TOG_EN <= '1';
		
		wait for CLK_period*5;
		
		CLR <= '1';
		
		wait for CLK_period*5;
		
		CLR <= '0';
		
		wait for CLK_period*5;
		
		TOG_EN <= '0';

      wait;
   end process;
	
	
	
	
	
	
	
	
	
	

END;
