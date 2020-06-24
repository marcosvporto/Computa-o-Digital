--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:30:34 04/05/2020
-- Design Name:   
-- Module Name:   /home/ise/Lab03/rotary_enc_bounce_tb.vhd
-- Project Name:  Lab03
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rotary_enc_bounce
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
 
ENTITY rotary_enc_bounce_tb IS
END rotary_enc_bounce_tb;
 
ARCHITECTURE behavior OF rotary_enc_bounce_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rotary_enc_bounce
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rot_a : IN  std_logic;
         rot_b : IN  std_logic;
         rot_center : IN  std_logic;
         leds : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
	
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rot_a : std_logic := '0';
   signal rot_b : std_logic := '0';
   signal rot_center : std_logic := '0';

 	--Outputs
   signal leds : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
		constant DEB_H : time := 2.5 ms;
   	constant DEB_L : time := 1.5 ms;
   	constant STABLE : time := 10 ms;
		
		
--		constant clk_period : time := 1 ns;
--		constant DEB_H : time := 0.25 ms;
--   	constant DEB_L : time := 0.15 ms;
--   	constant STABLE : time := 1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rotary_enc_bounce PORT MAP (
          clk => clk,
          reset => reset,
          rot_a => rot_a,
          rot_b => rot_b,
          rot_center => rot_center,
          leds => leds
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
      wait for STABLE;
		
		RESET <= '1';
		wait for clk_period*5;
		RESET <= '0';
		wait for clk_period*5;
		for j in 0 to 1 loop

            report LF & "----------------------------" & LF & "TURNING RIGHT" & LF & "----------------------------";
            -- ROT_A
            -- ROT_A + ROT_B
            --         ROT_B

            for i in 0 to 3 loop
                ROT_A <= '1'; wait for DEB_H; ROT_A <= '0'; wait for DEB_L;
                ROT_A <= '1';
                wait for STABLE;
                ROT_B <= '1'; wait for DEB_H; ROT_B <= '0'; wait for DEB_L;
                ROT_A <= '1'; ROT_B <= '1';
                wait for STABLE;
                ROT_A <= '0'; wait for DEB_H; ROT_A <= '1'; wait for DEB_L;
                ROT_A <= '0';
                wait for STABLE;
                ROT_B <= '0'; wait for DEB_H; ROT_B <= '1'; wait for DEB_L;
                ROT_B <= '0';
                wait for STABLE;
            end loop;
            
            report LF & "----------------------------" & LF & "TURNING RIGHT" & LF & "----------------------------";
            --         ROT_B
            -- ROT_B + ROT_A
            -- ROT_A 

            for i in 0 to 1 loop
                ROT_B <= '1'; wait for DEB_H; ROT_B <= '0'; wait for DEB_L;
                ROT_B <= '1';
                wait for STABLE;
                ROT_A <= '1'; wait for DEB_H; ROT_A <= '0'; wait for DEB_L;
                ROT_A <= '1'; ROT_B <= '1';
                wait for STABLE;
                ROT_B <= '0'; wait for DEB_H; ROT_B <= '1'; wait for DEB_L;
                ROT_B <= '0';
                wait for STABLE;
                ROT_A <= '0'; wait for DEB_H; ROT_A <= '1'; wait for DEB_L;
                ROT_A <= '0';
                wait for STABLE;
            end loop;
				
				report LF & "----------------------------" & LF & "PRESSING ROTARY CENTER" & LF & "----------------------------";
            ROT_CENTER <= '1'; wait for DEB_H; ROT_CENTER <= '0'; wait for DEB_L;
            ROT_CENTER <= '1';
            wait for STABLE;
            ROT_CENTER <= '0'; wait for DEB_H; ROT_CENTER <= '1'; wait for DEB_L;
            ROT_CENTER <= '0';
            wait for STABLE;
				
			end loop;
		
		
      wait;
   end process;

END;
