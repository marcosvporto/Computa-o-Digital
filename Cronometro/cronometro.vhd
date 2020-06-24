----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:53:16 04/21/2020 
-- Design Name: 
-- Module Name:    cronometro - Behavioral 
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

entity cronometro is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           go : in  STD_LOGIC;
           d1 : out  STD_LOGIC_VECTOR (3 downto 0); -- 1 seg
           d0 : out  STD_LOGIC_VECTOR (3 downto 0)); -- 100 ms
end cronometro;

architecture Behavioral of cronometro is
	
	-- clock = 50 MHz = 50e6 -- ft = 5e6
	-- DECI = 1 / (f0 / ft)  => 5e6 / 50e6 => 100 ms
	
	constant DECI : natural := 5000000;
	signal ms_reg, ms_next 	: unsigned(22 downto 0) := (others => '0');
	signal d0_reg, d0_next 	: unsigned(3 downto 0) 	:= (others => '0');
	signal d1_reg, d1_next 	: unsigned(3 downto 0) 	:= (others => '0');
	signal d1_en, d0_en		: std_logic := '0';
	signal ms_tick, d0_tick : std_logic := '0';


begin
	-- register
	process(clk)
	begin	
		if(clk'event and clk = '1') then
			ms_reg <= ms_next;
			d1_reg <= d1_next;
			d0_reg <= d0_next;
		end if;
	end process;
	
	-- next-state logic
	-- 0.1 sec tick generator: mod-5000000
	
	ms_next <= 	(others => '0') 	when clr = '1' or (ms_reg = DECI-1 and go = '1') else
					ms_reg + 1			when go = '1' else
					ms_reg;
	ms_tick <= '1' when ms_reg = DECI-1 else '0';
	
	
	-- 0.1 sec counter
	d0_en		<= '1' 					when ms_tick = '1' else '0';
	
	d0_next 	<= (others => '0') 	when clr = '1' or (d0_en = '1' and d0_reg = 9) else 
					d0_reg + 1 			when (d0_en = '1' and go = '1') else
					d0_reg;
	
	d0_tick 	<= '1' 					when d0_reg = 9 else '0';
	
	
	-- 1.0 sec counter
	d1_en <= '1' when ms_tick = '1' and d0_tick = '1' else '0';

	d1_next <= (others => '0') when clr = '1' or (d1_en = '1' and d1_reg = 9) else
					d1_reg + 1 		when (d1_en = '1' and go = '1') else
					d1_reg;
					
	-- output logic
	d0 <= STD_LOGIC_VECTOR(d0_reg);
	d1 <= STD_LOGIC_VECTOR(d1_reg);

end Behavioral;

