----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:32:38 04/21/2020 
-- Design Name: 
-- Module Name:    edge_detector - Behavioral 
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

entity edge_detector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           level : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end edge_detector;

architecture Behavioral of edge_detector is
	
	type state_type is (zero, edge, one);
	signal state_reg, state_next : state_type := zero;

begin

	-- state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= zero;
		elsif	(clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	
	
	-- next state / output logic 
	process (clk, reset)
	begin
		state_next <= state_reg;
		tick <= '0';
		case state_reg is
			when zero =>
				tick <= '0';
				if level = '1' then
					state_next <= edge;
				end if;
				
			when edge =>
				tick <= '1'; -- Moore output
				if level = '1' then
					state_next <= one;
				else
					state_next <= zero;
				end if;
			when one =>
				tick <= '0';
				if level = '0' then
					state_next <= zero;
				end if;
			when others =>
				state_next <= zero;
		end case;
	end process;

end Behavioral;

