----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:17:34 05/18/2020 
-- Design Name: 
-- Module Name:    ps2_keyb - Behavioral 
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

entity ps2_keyb is
    Port ( clk : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
           sseg : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC);
end ps2_keyb;

architecture Behavioral of ps2_keyb is

	type fsm_t is (idle, startbit, rxing, done);
	signal state_reg, state_next 	: fsm_t := idle;
	signal counter						: unsigned(2 downto 0) := (others=>'1');
	signal hex0_reg, hex0_next		: std_logic_vector(3 downto 0):= (others=>'0');
	signal hex1_reg, hex1_next		: std_logic_vector(3 downto 0):= (others=>'0');
	signal data_in, data_in_tmp	: std_logic_vector(7 downto 0):= (others=>'0');
	
	COMPONENT sevenSeg_hex_mux
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		hex0 : IN std_logic_vector(3 downto 0);
		hex1 : IN std_logic_vector(3 downto 0);          
		an : OUT std_logic;
		sseg : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

begin

	Inst_sevenSeg_hex_mux: sevenSeg_hex_mux PORT MAP(
		clk => clk,
		reset => '0',
		hex0 => hex0_reg,
		hex1 => hex1_reg,
		an => an,
		sseg => sseg  
	);

	process(clk)
	begin
		if clk'event and clk= '1' then
				state_reg <= state_next;
		end if;
		
	end process;

	process(ps2_clk,ps2_data)
	begin
		if falling_edge(ps2_clk) then
			case state_reg is
			
				when idle 		=>
					if ps2_data = '0' then
						state_next <= startbit;
					else
						state_next <= state_reg;
					end if;
					
				when startbit	=>
					counter 		<= (others => '1');
					data_in_tmp	<= (others => '0');
					state_next 	<= rxing;
					
				when rxing 		=>
					if counter = "000" then
						state_next <= done;
					else
						counter <= counter - 1;
						state_next 	<= state_reg;
						data_in_tmp <= ps2_data & data_in_tmp(7 downto 1);
					end if;
				
				when done		=>
					data_in <= data_in_tmp;
					state_next <= idle;
				when others		=>
					state_next <= idle;
			end case;
		end if;
	end process;
	
	hex0_reg <= data_in(7 downto 4);
	hex1_reg <= data_in(3 downto 0);

end Behavioral;

