----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:27:49 04/21/2020 
-- Design Name: 
-- Module Name:    free_running_counter - Behavioral 
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

entity free_running_counter is
		generic(		
			N			: natural := 8
		);
		Port( 
			clk 		: in  STD_LOGIC;
         reset 	: in  STD_LOGIC;
         max_tick : out STD_LOGIC;
         q 			: out STD_LOGIC_VECTOR (N-1 downto 0));
end free_running_counter;

architecture Behavioral of free_running_counter is

	signal reg			: UNSIGNED(N-1 downto 0) := (others => '0');
	signal reg_next	: UNSIGNED(N-1 downto 0) := (others => '0');

begin
	-- register
	process(clk, reset)
	begin
		if (reset = '1') then
			reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			reg <= reg_next;
		end if;
	end process;
	
	-- next-state logic
	reg_next <= reg + 1;

	-- output
	q 				<= STD_LOGIC_VECTOR(reg);
	max_tick 	<= '1' when reg = (2**N - 1) else '0';
end Behavioral;

