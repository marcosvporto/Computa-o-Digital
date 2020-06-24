--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:38:37 04/30/2020
-- Design Name:   
-- Module Name:   /home/ise/FilaFIFO/fifo_tb.vhd
-- Project Name:  FilaFIFO
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fifo
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
 
ENTITY fifo_tb IS
END fifo_tb;
 
ARCHITECTURE behavior OF fifo_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rd_en : IN  std_logic;
         wr_en : IN  std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic_vector(7 downto 0);
         data_count : OUT  std_logic_vector(3 downto 0);
         empty : OUT  std_logic;
         full : OUT  std_logic;
         almost_empty : OUT  std_logic;
         almost_full : OUT  std_logic;
         err : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rd_en : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal data_count : std_logic_vector(3 downto 0);
   signal empty : std_logic;
   signal full : std_logic;
   signal almost_empty : std_logic;
   signal almost_full : std_logic;
   signal err : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo PORT MAP (
          clk => clk,
          reset => reset,
          rd_en => rd_en,
          wr_en => wr_en,
          data_in => data_in,
          data_out => data_out,
          data_count => data_count,
          empty => empty,
          full => full,
          almost_empty => almost_empty,
          almost_full => almost_full,
          err => err
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
		
		
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		
		rd_en <= '1';
		wait for clk_period;
		rd_en <= '0';
		
		wait for clk_period;
		data_in <= "10101010";
		wr_en <= '1';
		wait for clk_period*5;
		wr_en <= '0';
		
		wait for clk_period;
		rd_en <= '1';
		wait for clk_period*2;
		rd_en <= '0';
		
		

      wait;
   end process;

END;
