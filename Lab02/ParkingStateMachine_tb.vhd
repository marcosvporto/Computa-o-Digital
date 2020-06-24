--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:23:59 03/31/2020
-- Design Name:   
-- Module Name:   /home/ise/Lab02/ParkingStateMachine_tb.vhd
-- Project Name:  Lab02
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ParkingStateMachine
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
 
USE ieee.numeric_std.ALL;
 
ENTITY ParkingStateMachine_tb IS
END ParkingStateMachine_tb;
 
ARCHITECTURE behavior OF ParkingStateMachine_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ParkingStateMachine
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         a : IN  std_logic;
         b : IN  std_logic;
         z : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal a : std_logic := '0';
   signal b : std_logic := '0';

 	--Outputs
   signal z : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ParkingStateMachine PORT MAP (
          reset => reset,
          clk => clk,
          a => a,
          b => b,
          z => z
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
      reset <='1';
        wait for clk_period*10;
        reset <='0';
        wait for clk_period*10;

        a <='0'; b <='0'; wait for clk_period*1;
        a <='1'; b <='0'; wait for clk_period*1;
        a <='1'; b <='1'; wait for clk_period*1;
        a <='0'; b <='1'; wait for clk_period*1;
        a <='0'; b <='0'; wait for clk_period*1;
        -- 1o carro entrou

        wait for clk_period*10;
        a <='0'; b <='0'; wait for clk_period*1;
        a <='1'; b <='0'; wait for clk_period*1;
        a <='1'; b <='1'; wait for clk_period*1;
        a <='0'; b <='1'; wait for clk_period*1;
        a <='0'; b <='0'; wait for clk_period*1;
        -- 2o carro entrou

        wait for clk_period*10;
        a <='0'; b <='0'; wait for clk_period*1;
        a <='0'; b <='1'; wait for clk_period*1;
        a <='1'; b <='1'; wait for clk_period*1;
        a <='1'; b <='0'; wait for clk_period*1;
        a <='0'; b <='0'; wait for clk_period*1;
        -- 1o carro saiu

        wait for clk_period*10;
        a <='0'; b <='0'; wait for clk_period*1;
        a <='0'; b <='1'; wait for clk_period*1;
        a <='1'; b <='1'; wait for clk_period*1;
        a <='1'; b <='0'; wait for clk_period*1;
        a <='0'; b <='0'; wait for clk_period*1;
        -- 2o carro saiu

      wait;
   end process;

END;
