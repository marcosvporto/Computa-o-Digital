----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:32:39 04/20/2020 
-- Design Name: 
-- Module Name:    DisplayKeypad - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DisplayKeypad is
    Port ( clk 	: in  	STD_LOGIC;
           reset 	: in  	STD_LOGIC;
           row 	: in  	STD_LOGIC_VECTOR (3 downto 0);
           col 	: out  	STD_LOGIC_VECTOR (3 downto 0);
           an 		: out  	STD_LOGIC;
           sseg 	: out  	STD_LOGIC_VECTOR (7 downto 0));
end DisplayKeypad;

architecture Behavioral of DisplayKeypad is

COMPONENT keypad
	PORT(
		clk 			: IN std_logic;
		reset 		: IN std_logic;
		row 			: IN std_logic_vector(3 downto 0);          
		col 			: OUT std_logic_vector(3 downto 0);
		hex_out 		: OUT std_logic_vector(3 downto 0);
		tick_event 	: OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT sevenSeg_hex_mux
	PORT(
		clk 			: IN std_logic;
		reset 		: IN std_logic;
		hex0 			: IN std_logic_vector(3 downto 0);
		hex1 			: IN std_logic_vector(3 downto 0);
		dp_in 		: IN std_logic_vector(1 downto 0);          
		an 			: OUT std_logic;
		sseg 			: OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal hexout_reg				:	std_logic_vector(3 downto 0) 	:= (others => 'Z');
	signal hex0_reg				:	std_logic_vector(3 downto 0) 	:= (others => 'Z');
	signal hex0_tmp				:	std_logic_vector(3 downto 0) 	:= (others => 'Z');
	signal hex1_reg 				:	std_logic_vector(3 downto 0) 	:= (others => 'Z');
	signal sseg_dpin				: 	std_logic_vector(1 downto 0)	:= (others => '0');
	signal keypad_tick  			:	std_logic			:= '0';
	
	
begin

Inst_keypad: keypad PORT MAP(
		clk => clk,
		reset => reset,
		row => row,
		col => col ,
		hex_out => hexout_reg,
		tick_event => keypad_tick 
	);
	
	Inst_sevenSeg_hex_mux: sevenSeg_hex_mux PORT MAP(
		clk => clk,
		reset => reset,
		hex0 => hex0_reg,
		hex1 => hex1_reg,
		dp_in => sseg_dpin,
		an => an,
		sseg => sseg
	);
	
	process(keypad_tick) 
	begin
		if keypad_tick'event and keypad_tick = '1' then
			if reset = '1' then
				hex0_reg 	<= (others => 'Z');
				hex1_reg 	<= (others => 'Z');
				sseg_dpin 	<= "00";
			elsif keypad_tick =  '1' then
				hex0_tmp <= hex0_reg;
				hex0_reg	<= hexout_reg;
				hex1_reg <= hex0_tmp;
				
				if hex1_reg = "ZZZZ" then
					sseg_dpin <= "01";
				else
					sseg_dpin <= "11";
				end if;
			end if;
		end if;
	end process;
	
	


end Behavioral;

