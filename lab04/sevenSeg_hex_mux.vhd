----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:11 04/12/2020 
-- Design Name: 
-- Module Name:    sevenSeg_hex_mux - Behavioral 
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

entity sevenSeg_hex_mux is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           hex0 : in  STD_LOGIC_VECTOR (3 downto 0);
           hex1 : in  STD_LOGIC_VECTOR (3 downto 0);
           dp_in : in  STD_LOGIC_VECTOR (1 downto 0);
           an : out  STD_LOGIC;
           sseg : out  STD_LOGIC_VECTOR (7 downto 0));
end sevenSeg_hex_mux;

 architecture Behavioral of sevenSeg_hex_mux is
	-- refresh rate ^ 26 ms (50 MHz / 2^17 = 381 Hz)
	constant N					: natural := 18;
	signal counter, c_next	: unsigned(N-1 downto 0) := (others => '0');
	signal sel					: STD_LOGIC := '0';
	signal hex					: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal dp					: STD_LOGIC := '0';
		
begin

	-- register
	process(clk, reset)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				counter <= (others => '0');
			else
				counter <= c_next;
			end if;
		end if;
	end process;
	
	
	-- next-state logic for the counter
	c_next <= counter + 1;
	
	-- 2 MSB to control the 4-to-1 mux
	-- and generate active-low "an" signal
	sel <= STD_LOGIC(counter(N-1));
	
	process(sel, hex0, hex1, dp_in)
	begin
		case sel is
			when '0' =>
				an 	<= '0';
				hex 	<= hex0;
				dp		<= dp_in(0);
			when '1' =>
				an 	<= '1';
				hex 	<= hex1;
				dp		<= dp_in(1);
			when others =>
				an <= '0';
		end case;
	end process;
	
	-- SSEG(7 downto 0)
	--			(7,	6,		5,		4,		3,		2,		1,		0)
	--			(DP,	A,		B,		C,		D,		E,		F,		G)
	-- hex to 7 deg decoding
	
	with hex select
		sseg(6 downto 0) <=
			"1111110" when "0000", -- 0
			"0110000" when "0001", -- 1
			"1101101" when "0010", -- 2
			"1111001" when "0011", -- 3
			"0110011" when "0100", -- 4
			"1011011" when "0101", -- 5
			"1011111" when "0110", -- 6
			"1110000" when "0111", -- 7
			"1111111" when "1000", -- 8
			"1111011" when "1001", -- 9
			"1110111" when "1010", -- A
			"0011111" when "1011", -- b
			"1001110" when "1100", -- C
			"0111101" when "1101", -- d
			"1001111" when "1110", -- E
			"1000111" when "1111", -- F
			"0110111" when others; -- H
			
		-- decimal point
		sseg(7) <= dp;
		
end Behavioral;

