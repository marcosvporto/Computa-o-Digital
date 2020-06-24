----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:30:47 03/30/2020 
-- Design Name: 
-- Module Name:    ParkingStateMachine - Behavioral 
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

entity ParkingStateMachine is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR (7 downto 0));
end ParkingStateMachine;

architecture Behavioral of ParkingStateMachine is
	type state_type is (s0, s1, s2, s3, s4);
	type orientation_type is (idle, exiting, entering);
	signal state_reg, state_next : state_type := s0;
	signal counter : UNSIGNED(2 downto 0) := (others => '0');
	signal orientation : orientation_type := idle;
	
begin
	-- state register
--	process(clk, reset)
--	begin
--		if reset = '1' then
--			state_reg <= s0;
--		elsif (clk'event and clk = '1') then
--			state_reg <= state_next;
--			
--		end if;
--	end process;
	
	-- next state
	process (clk, reset)
	begin
		--state_next <= state_reg;
		if (clk'event and clk = '1') then
			if reset = '1' then
				state_reg <= s0;
			else
				case state_reg is
					when s0 =>
						if(a = '1' and b = '0') then
							state_reg 	<= s1;
							--state_next 	<= s1;
							orientation <= entering;
						elsif(a = '0' and b = '1') then
							state_reg <= s3;
							--state_next <= s3;
							orientation <= exiting;
						end if;
					when s1=>
						if orientation = entering then
							if (a = '1' and b = '1') then
								state_reg <= s2;
								--state_next <= s2;
							end if;
						else
							if (a = '0' and b = '0') then
								state_reg <= s4;
								--state_next <= s4;
							end if;
						end if;
						
					when s2=>
						if orientation = entering then
							if (a = '0' and b = '1') then
								state_reg <= s3;
								--state_next <= s3;
							end if;
						else
							if (a = '1' and b = '0') then
								state_reg <= s1;
								--state_next <= s1;
							end if;
						end if;
						
					when s3=>
					
						if orientation = entering then
							if (a = '0' and b = '0') then
								state_reg <= s4;
								--state_next <= s4;
							end if;
						else
							if (a = '1' and b = '1') then
								state_reg <= s2;
								--state_next <= s2;
							end if;
						end if;
					when s4=>
						
						if orientation = entering then
							if counter < 8  then
								counter <= counter+1;
								
							end if;
						else
							-- counter down
							if counter > 0  then
								counter <= counter-1;
							end if;
						end if;
						state_reg <= s0;
						--state_next <= s0;
					when others =>
						state_reg <= s0;
						--state_next <= s0;
				end case;
			
			end if;
		
			
		
		end if;
		
	end process;
	
	
	with counter select
		z <= 
			"00000000" when	"000",
			"00000001" when  	"001",
			"00000011" when  	"010",	
			"00000111" when  	"011",	
			"00001111" when  	"100",	
			"00011111" when  	"101",	
			"00111111" when  	"110",	
			"01111111" when  	"111",	
			"01010101" when	others;

end Behavioral;

