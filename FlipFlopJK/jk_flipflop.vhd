----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:54:44 05/04/2020 
-- Design Name: 
-- Module Name:    jk_flipflop - Behavioral 
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

entity jk_flipflop is
    Port ( clk : in  STD_LOGIC;
           j 	: in  STD_LOGIC;
           k 	: in  STD_LOGIC;
           q 	: out  STD_LOGIC);
end jk_flipflop;

architecture Behavioral of jk_flipflop is
		
	signal q_reg : std_logic := '0';
	signal jk : std_logic_vector(1 downto 0);

begin
	jk <= j & k;
	process(clk)
	begin
		if(clk'event and clk = '1') then
			case jk is
				when "00" =>
					q_reg <= q_reg;
				when "01" =>
					q_reg	<= '0';
				when "11" =>
					q_reg <= not(q_reg);
				when "10" =>
					q_reg <= '1';
				when others =>
					q_reg <= q_reg;
			end case;
		end if;
	end process;
	
	--output 
	q <= 	q_reg;

end Behavioral;

