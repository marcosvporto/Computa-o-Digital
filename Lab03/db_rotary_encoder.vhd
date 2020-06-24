----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:05:33 04/05/2020 
-- Design Name: 
-- Module Name:    db_rotary_encoder - Behavioral 
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

entity db_rotary_encoder is
    Port ( clk : in  STD_LOGIC;
           rotary_a_in 		: in  	STD_LOGIC;
           rotary_b_in 		: in  	STD_LOGIC;
           rotary_a_out 	: out  	STD_LOGIC;
           rotary_b_out 	: out  	STD_LOGIC;
           rotary_is_left 	: out  	STD_LOGIC);
end db_rotary_encoder;

architecture Behavioral of db_rotary_encoder is

	signal rotary_q1			: STD_LOGIC := '0';
	signal rotary_q2			: STD_LOGIC := '0';
	signal rotary_left		: STD_LOGIC := '0';
	signal rotary_event 		: STD_LOGIC := '0';
	signal delay_rotary_q1 	: STD_LOGIC := '0';

	signal rotary_in			: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	
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
		
		
	direction: process(clk)
		begin
			if clk'event and clk='1' then
				delay_rotary_q1 <= rotary_q1;
				if rotary_q1='1' and delay_rotary_q1='0' then
					rotary_event <= '1';
					rotary_left <= rotary_q2;
				else
					rotary_event <= '0';
					rotary_left <= rotary_left;
				end if;
			end if;
		end process direction;
		
		rotary_a_out 	<= rotary_q1;
		rotary_b_out 	<= rotary_q2;
		rotary_is_left <= rotary_left;

end Behavioral;

