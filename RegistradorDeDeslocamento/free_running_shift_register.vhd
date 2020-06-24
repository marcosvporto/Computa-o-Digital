----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:55:39 03/29/2020 
-- Design Name: 
-- Module Name:    free_running_shift_register - Behavioral 
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

entity free_running_shift_register is

	 generic(
				N 					:natural := 8;
				SHIFT_RIGHT		:boolean := TRUE
	 
	 );
    Port ( clk 				: in  STD_LOGIC;
           reset 				: in  STD_LOGIC;
           serial_in 		: in  STD_LOGIC;
           parallel_out 	: out  STD_LOGIC_VECTOR(N-1 downto 0)
	 );
end free_running_shift_register;

architecture Behavioral of free_running_shift_register is

	signal reg		: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
	signal reg_next: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');


begin
	process (clk, reset)
	begin
	
			if(reset = '1') then
				reg <= (others => '0');
			elsif (clk'event and clk = '1') then
				reg <= reg_next;
			end if;		
	end process;
	-- reg = "10010100"      serial_in = '1'

	--	reg_next = 1 + 1001010
	if_shift_right : if (SHIFT_RIGHT = TRUE) generate 
		reg_next <= serial_in & reg(N-1 downto 1);
	end generate if_shift_right;
	
	
	-- reg = "10010100"      serial_in = '1'

	--	reg_next = 0010100 + 1
	
	if_shift_left : if (SHIFT_RIGHT = FALSE) generate
		reg_next <= reg(N-2 downto 0) & serial_in;
	end generate if_shift_left;
	
	parallel_out <= reg;

end Behavioral;

