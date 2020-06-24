----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:44:00 03/25/2020 
-- Design Name: 
-- Module Name:    maq_estado - Behavioral 
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity maq_estado is
    Port ( reset : in  STD_LOGIC;
           a : in  STD_LOGIC;
           b : in  STD_LOGIC;
			  clk : STD_LOGIC
           z : out  STD_LOGIC_VECTOR (7 downto 0));
end maq_estado;

architecture Behavioral of maq_estado is

	type state_type is (idle, S01, S02, S03, inc_counter)
	signal actual_state  : state_type := idle;
	
	signal shift_register : STD_LOGIC_VECTOR (7 downto 0) := (others => '0')
	signal shift_register_zero : STD_LOGIC_VECTOR := '0';
	
begin
	
	shift_register_zero <= '1' when shift_register = std_logic_vector(to_unsigned (0 , shift_register'lenght))) else 0;
	process (clk)
	begin
		if rising_edge(clk) then
			case actual_state is
				when idle =>
				when inc_counter =>
					if (shift_register_zero = '1') then
					shift_register <= ( 0 => '1', others => '0'); -- "00000001"
					else
						-- append 1's
						-- "00000001" --> "00000011" --> "00000111"
						shift_register =< shift_register(6 downto 0) & '1';
					end if;
					actual_state <= idle
				when others =>
					actual_state <= idle
	end process
end Behavioral;

