----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:22:23 03/29/2020 
-- Design Name: 
-- Module Name:    my_fsm2 - Behavioral 
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

entity my_fsm2 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           y0 : out  STD_LOGIC;
           y1 : out  STD_LOGIC);
end my_fsm2;

architecture Behavioral of my_fsm2 is

	type state_type is (s0, s1, s2);
	signal state_reg, state_next : state_type := s0;
	
begin
	--state register
	process(clk,reset)
	begin
		is reset = '1' then
			state_reg <= s0;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;

	--next state / output logic
	process(clk, reset)
	begin
		state_next 	<= state_reg;
		y0				<= '0';
		y1				<= '0';
		case state_reg is
			when s0 =>
				if a = '1' then
					if b = '1' then
						state_next 	<= s2;
						y0 			<= '1';
					else
						state_next	<= s1;
					end if;
				end if;
			
			when s1 =>
				y1	<= '1';
				if a = '1' then
					state_next	<= s0;
				end if;
			when s2 =>
				state_next	<= s0;
			when others =>
				state_next	<= s0;
		end case;
	end process;

end Behavioral;

