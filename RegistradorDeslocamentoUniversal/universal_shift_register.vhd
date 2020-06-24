----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:32:31 03/29/2020 
-- Design Name: 
-- Module Name:    universal_shift_register - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity universal_shift_register is
	 generic(
				N		: natural := 8
		
	 );
    Port ( clk 	: in  STD_LOGIC;
           reset 	: in  STD_LOGIC;
           ctrl 	: in  STD_LOGIC_VECTOR(1 downto 0);
           d 		: in  STD_LOGIC_VECTOR(N-1 downto 0);
           q 		: out  STD_LOGIC_VECTOR(N-1 downto 0)
	 );
end universal_shift_register;

architecture Behavioral of universal_shift_register is

		signal reg  		: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
		signal reg_next 	: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');

begin

	--register
	process(clk, reset)
	begin
		if (reset = '1') then
			reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			reg<=reg_next;
		end if;
	end process;
	
	
	--next-state logic
	
	with ctrl select
		reg_next <=
			reg										when "00",  -- no op
			reg(N-2 downto 0) & d(0)			when "01",  -- shift left
			d(N-1) & reg(N-1 downto 1)			when "10",  -- shift right
			d											when others;

	-- output
	
	q <= reg;
end Behavioral;

