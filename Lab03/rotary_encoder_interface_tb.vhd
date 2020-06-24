--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:10:56 04/06/2020
-- Design Name:   
-- Module Name:   /home/ise/Lab03/rotary_encoder_interface_tb.vhd
-- Project Name:  Lab03
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rotary_encoder_interface
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
 
ENTITY rotary_encoder_interface_tb IS
END rotary_encoder_interface_tb;
 
ARCHITECTURE behavior OF rotary_encoder_interface_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rotary_encoder_interface
    PORT(
         clk : IN  std_logic;
         rotary_a_in : IN  std_logic;
         rotary_b_in : IN  std_logic;
         rotary_a_out : OUT  std_logic;
         rotary_b_out : OUT  std_logic;
         rotary_lft : OUT  std_logic;
         rotary_evnt : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rotary_a_in : std_logic := '0';
   signal rotary_b_in : std_logic := '0';

 	--Outputs
   signal rotary_a_out : std_logic;
   signal rotary_b_out : std_logic;
   signal rotary_lft : std_logic;
   signal rotary_evnt : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rotary_encoder_interface PORT MAP (
          clk => clk,
          rotary_a_in => rotary_a_in,
          rotary_b_in => rotary_b_in,
          rotary_a_out => rotary_a_out,
          rotary_b_out => rotary_b_out,
          rotary_lft => rotary_lft,
          rotary_evnt => rotary_evnt
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
      wait for 10 ns;	

      wait for clk_period*10;

      -- insert stimulus here
						-- virando a direita
		-- acendendo o a
		
		rotary_a_in <= '1';
		wait for clk_period*1;
			
		rotary_a_in <= '0';
		wait for clk_period*1;
		
		rotary_a_in <= '1';
		
		
		wait for clk_period*5;
		
		-- acendendo o b
		rotary_b_in <= '1';
		wait for clk_period*1;
			
		rotary_b_in <= '0';
		wait for clk_period*1;
		
		rotary_b_in <= '1';
		
		
		wait for clk_period*5;
		
		-- apagando o a
		
		rotary_a_in <= '0';
		wait for clk_period*1;
			
		rotary_a_in <= '1';
		wait for clk_period*1;
		
		rotary_a_in <= '0';
		
		wait for clk_period*5;
		
		-- apagando o b
		
		rotary_b_in <= '0';
		wait for clk_period*1;
			
		rotary_b_in <= '1';
		
		wait for clk_period*1;
		
		rotary_b_in <= '0';
		
		wait for clk_period*5;
		
				-- virando a esquerda
		-- acendendo o b
		
		rotary_b_in <= '1';
		wait for clk_period*1;
			
		rotary_b_in <= '0';
		wait for clk_period*1;
		
		rotary_b_in <= '1';
		
		
		wait for clk_period*5;
		
		-- acendendo o a
		rotary_a_in <= '1';
		wait for clk_period*1;
			
		rotary_a_in <= '0';
		wait for clk_period*1;
		
		rotary_a_in <= '1';
		
		
		wait for clk_period*5;
		
		-- apagando o b
		
		rotary_b_in <= '0';
		wait for clk_period*1;
			
		rotary_b_in <= '1';
		wait for clk_period*1;
		
		rotary_b_in <= '0';
		
		wait for clk_period*5;
		
		-- apagando o a
		
		rotary_a_in <= '0';
		wait for clk_period*1;
			
		rotary_a_in <= '1';
		
		wait for clk_period*1;
		
		rotary_a_in <= '0';
		
		wait for clk_period*5;
		
				-- virando a esquerda
		-- acendendo o b
		
		rotary_b_in <= '1';
		wait for clk_period*1;
			
		rotary_b_in <= '0';
		wait for clk_period*1;
		
		rotary_b_in <= '1';
		
		
		wait for clk_period*5;
		
		-- acendendo o a
		rotary_a_in <= '1';
		wait for clk_period*1;
			
		rotary_a_in <= '0';
		wait for clk_period*1;
		
		rotary_a_in <= '1';
		
		
		wait for clk_period*5;
		
		-- apagando o b
		
		rotary_b_in <= '0';
		wait for clk_period*1;
			
		rotary_b_in <= '1';
		wait for clk_period*1;
		
		rotary_b_in <= '0';
		
		wait for clk_period*5;
		
		-- apagando o a
		
		rotary_a_in <= '0';
		wait for clk_period*1;
			
		rotary_a_in <= '1';
		
		wait for clk_period*1;
		
		rotary_a_in <= '0';
		
		
		
		

		
		

      wait;
   end process;

END;
