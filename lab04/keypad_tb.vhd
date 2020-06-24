--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:30:55 05/17/2020
-- Design Name:   
-- Module Name:   /home/ise/lab04/keypad_tb.vhd
-- Project Name:  lab04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: keypad
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
 
ENTITY keypad_tb IS
END keypad_tb;
 
ARCHITECTURE behavior OF keypad_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT keypad
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         row : IN  std_logic_vector(3 downto 0);
         col : OUT  std_logic_vector(3 downto 0);
         hex_out : OUT  std_logic_vector(3 downto 0);
         tick_event : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal row : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal col : std_logic_vector(3 downto 0);
   signal hex_out : std_logic_vector(3 downto 0);
   signal tick_event : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	constant DEB_H : time := 0.25 ms;
	constant DEB_L : time := 0.15 ms;
	constant STABLE : time := 1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: keypad PORT MAP (
          clk => clk,
          reset => reset,
          row => row,
          col => col,
          hex_out => hex_out,
          tick_event => tick_event
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
		
		
	
			-- simulando o teclado
		
				--tecla 8 foi pressionada (debounce)
				
			wait until col = "1011";
			--row <= "1101";
			
			row(0)<= '1';
			row(2)<= '1';
			row(3)<= '1';
			row(1) <= '0'; wait for DEB_H; row(1) <= '1'; wait for DEB_L;
			row(1) <= '0';
			
			wait until col = "1101";
			row <= "1111";
			
			wait for 5 ms;
			
				-- tecla E sendo pressionada = 1110 (sem debounce)
				
			wait until col = "1101";
			
			row <= "1110";
			wait until col = "1110";
			row <= "1111";
			
			wait for 5 ms;
				-- tecla C sendo pressionada = 1100 (debounce)
				
			wait until col = "1110";
			row(0)<= '1';
			row(2)<= '1';
			row(3)<= '1';
			row(1) <= '0'; wait for DEB_H; row(1) <= '1'; wait for DEB_L;
			row(1) <= '0';
			
			wait until col = "0111";
			row <= "1111";
			
			
			


      wait;
   end process;

END;
