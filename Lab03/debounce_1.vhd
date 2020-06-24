----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:35:03 04/01/2020 
-- Design Name: 
-- Module Name:    debounce_1 - Behavioral 
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

entity debounce_1 is
    Port ( 	clk				: in 		STD_LOGIC;
				rotary_a_in 	: in  	STD_LOGIC;
				rotary_b_in 	: in  	STD_LOGIC;
				rotary_q1 		: out  	STD_LOGIC;
				rotary_q2 		: out  	STD_LOGIC;
				rotary_event 	: out  	STD_LOGIC;
				rotary_left 	: out  	STD_LOGIC);
end debounce_1;

architecture Behavioral of debounce_1 is

	signal rotary_in : std_logic_vector (1 downto 0) <= (others => '0');

begin

rotary_filter: process(clk)


		begin
			if clk'event and clk='1' then
			
				rotary_in <= rotary_b_in & rotary_a_in;
				
				case rotary_in is
				
					when "00" => 	rotary_q1 <= '0';
										rotary_q2 <= rotary_q2;
										
										
					when "01" => 	rotary_q1 <= rotary_q1;
										rotary_q2 <= '0';
										
										
					when "10" => 	rotary_q1 <= rotary_q1;					
										rotary_q2 <= '1';
										
										
					when "11" => 	rotary_q1 <= '1';			
										rotary_q2 <= rotary_q2;
										
										
					when others => rotary_q1 <= rotary_q1;					
										rotary_q2 <= rotary_q2;
										
				end case;
			end if;
		end process rotary_filter;



end Behavioral;

