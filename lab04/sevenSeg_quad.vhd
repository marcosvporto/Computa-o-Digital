----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:20:00 04/12/2020 
-- Design Name: 
-- Module Name:    sevenSeg_quad - Behavioral 
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

entity sevenSeg_quad is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           in0 : in  STD_LOGIC_VECTOR (7 downto 0);
           in1 : in  STD_LOGIC_VECTOR (7 downto 0);
           in2 : in  STD_LOGIC_VECTOR (7 downto 0);
           in3 : in  STD_LOGIC_VECTOR (7 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           sseg : out  STD_LOGIC_VECTOR (7 downto 0));
end sevenSeg_quad;

architecture Behavioral of sevenSeg_quad is
	--refresh rate ~ 763 Hz (50 MHz / 2^16 = 762.9394)
	-- portanto precisamos de mais 2 bits para controlar 4 saidas
	constant N					: natural := 18;
	signal counter, c_next	: unsigned(N-1 downto 0) := (others => '0');
	signal sel					: STD_LOGIC_VECTOR(1 downto 0) := (others=> '0');
begin
	-- register
	process(clk, reset)
	begin
		if (clk'event and clk = '1') then 
			if (reset = '1') then
				counter <= (others => '0');
			else
				counter <= c_next;
			end if;
		end if;
	end process;

	-- next state logic for the counter
	c_next <= counter + 1;
	
	-- 2 MSB to control the 4-to-1 mux
	-- and generate active-low "an" signal
	sel <= STD_LOGIC_VECTOR(counter(N-1 downto N-2));
	
	process(sel, in0, in1, in2, in3)
	begin
		case sel is
			when "00" =>
				an <= "1110";
				sseg <= in0;
			when "01" =>
				an <= "1101";
				sseg <= in1;
			when "10" =>
				an <= "1011";
				sseg <= in2;
			when "11" =>
				an <= "0111";
				sseg <= in3;
			when others =>
				an <= "1111";
				sseg <= in0;
		end case;
	end process;

end Behavioral;

