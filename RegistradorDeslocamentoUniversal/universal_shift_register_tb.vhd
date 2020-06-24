--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:50:38 03/29/2020
-- Design Name:   
-- Module Name:   /home/ise/RegistradorDeslocamentoUniversal/universal_shift_register_tb.vhd
-- Project Name:  RegistradorDeslocamentoUniversal
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: universal_shift_register
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
 
ENTITY universal_shift_register_tb IS
END universal_shift_register_tb;
 
ARCHITECTURE behavior OF universal_shift_register_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT universal_shift_register
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ctrl : IN  std_logic_vector(1 downto 0);
         d : IN  std_logic_vector(7 downto 0);
         q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ctrl : std_logic_vector(1 downto 0) := (others => '0');
   signal d : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal q : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: universal_shift_register PORT MAP (
          clk => clk,
          reset => reset,
          ctrl => ctrl,
          d => d,
          q => q
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
		
		ctrl <= "00";
		
		d <= "01010101";
		
		wait for clk_period*10;
		
		ctrl <="11";        -- load
		
		wait for clk_period*10;
		
		ctrl <="01";       -- shift left
		
		wait for clk_period*4;
		
		ctrl <="00";
		
		wait for clk_period*4;
		
		ctrl <="10";
		
		wait for clk_period*4;
		
		ctrl <="00";
		
		d <= "11010101";
		
		
		wait for clk_period*4;
		
		ctrl <="10";
		
		wait for clk_period*4;
		
		ctrl <="00";
		
		
		 
		
		
      wait;
   end process;

END;
