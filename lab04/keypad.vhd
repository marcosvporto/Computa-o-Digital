----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:18:46 04/20/2020 
-- Design Name: 
-- Module Name:    keypad - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity keypad is
    Port ( clk, reset	: 	in  	STD_LOGIC;
           row 			: 	in  	STD_LOGIC_VECTOR (3 downto 0);
           col 			: 	out  	STD_LOGIC_VECTOR (3 downto 0);
           hex_out 		: 	out  	STD_LOGIC_VECTOR (3 downto 0);
			  tick_event	:	out 	STD_LOGIC);
end keypad;

 architecture Behavioral of keypad is
 
	COMPONENT debounce
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		sw : IN std_logic;          
		db : OUT std_logic;
		tick : OUT std_logic
		);
	END COMPONENT;
	
	type col_state is (col1, col2, col3, col4);
	
	signal current_col			 	: col_state 							:= col1;
	signal counter,counter_next 	: unsigned(20 downto 0)	 			:= (others => '0');
	signal db_row  					: std_logic_vector(3 downto 0) 	:= (others => '1');
	signal next_col					: std_logic 							:= '0';
	signal hex_reg, hex_next		: std_logic_vector(3 downto 0)	:= (others => 'Z');
	
begin

	row0_db: debounce PORT MAP(
		clk => clk,
		reset => next_col,
		sw => row(0),
		db => db_row(0),
		tick => open
	);
	row1_db: debounce PORT MAP(
		clk => clk,
		reset => next_col,
		sw => row(1),
		db => db_row(1),
		tick => open
	);
	row2_db: debounce PORT MAP(
		clk => clk,
		reset => next_col,
		sw => row(2),
		db => db_row(2),
		tick => open
	);
	row3_db: debounce PORT MAP(
		clk => clk,
		reset => next_col,
		sw => row(3),
		db => db_row(3),
		tick => open
	);

	process(clk,reset)
	begin
		if clk'event and clk = '1' then
			if reset = '1' then
				counter <= (others => '0');
			else
				counter <= counter_next;
				hex_reg <= hex_next;
			end if;
		end if;
	end process;
	
	counter_next <= (others => '0') when counter = "000011000011010100000" else
						 counter + 1;

	next_col     <= '1' when counter = "000011000011010100000" else '0';
	
	process(clk,current_col,next_col)
	begin
		if clk'event and clk = '1' and next_col = '1' then
			case current_col is
				when col1 =>
					
					current_col <= col2;
					col <= "1011";
					
				when col2 =>
					current_col <= col3;
					col <= "1101";
					
				when col3 =>
					current_col <= col4;
					col <= "1110";
					
				when col4 =>
					current_col <= col1;
					col <= "0111";
					
				when others =>
					current_col <= col1;
					col <= "0111";
			
			end case;
		end if;
	end process;
	
	process(clk, db_row, current_col, hex_next, hex_reg)
	begin
		case current_col is
			when col1 => -- 1 , 4 , 7 , 0
				case db_row is
					when "0111" => -- 1
						hex_next <= "0001";
						tick_event <= '1';
					when "1011" => -- 4
						hex_next <= "0100";
						tick_event <= '1';
					when "1101" => -- 7
						hex_next <= "0111";
						tick_event <= '1';
					when "1110" => -- 0
						hex_next <= "0000";
						tick_event <= '1';
					when others => --
						hex_next <= hex_reg;
						tick_event <= '0';
				end case;
			
			when col2 => -- 2 , 5 , 8 , F
				case db_row is
					when "0111" => -- 2
						hex_next <= "0010";
						tick_event <= '1';
					when "1011" => -- 5
						hex_next <= "0101";
						tick_event <= '1';
					when "1101" => -- 8
						hex_next <= "1000";
						tick_event <= '1';
					when "1110" => -- F
						hex_next <= "1111";
						tick_event <= '1';
					when others => --
						hex_next <= hex_reg;
						tick_event <= '0';
				end case;
				
			when col3 => -- 3 , 6 , 9 , E
				case db_row is
					when "0111" => -- 3
						hex_next <= "0111";
						tick_event <= '1';
					when "1011" => -- 6
						hex_next <= "0110";
						tick_event <= '1';
					when "1101" => -- 9
						hex_next <= "1001";
						tick_event <= '1';
					when "1110" => -- E
						hex_next <= "1110";
						tick_event <= '1';
					when others => --
						hex_next <= hex_reg;
						tick_event <= '0';
				end case;				
			when col4 => -- A , B , C , D
				case db_row is
					when "0111" => -- A
						hex_next <= "1010";
						tick_event <= '1';
					when "1011" => -- B
						hex_next <= "1011";
						tick_event <= '1';
					when "1101" => -- C
						hex_next <= "1100";
						tick_event <= '1';
					when "1110" => -- D
						hex_next <= "1101";
						tick_event <= '1';
					when others => -- 
						hex_next <= hex_reg;
						tick_event <= '0';
				end case;
				
			when others =>
				hex_next <= hex_reg;
				tick_event <= '0';
			
		end case;
	end process;
	
	
	hex_out <= hex_reg;

end Behavioral;

