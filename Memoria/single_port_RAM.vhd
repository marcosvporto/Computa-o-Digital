----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:14:52 03/27/2020 
-- Design Name: 
-- Module Name:    single_port_RAM - Behavioral 
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
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity single_port_RAM is
	 Generic(
			  DATA_WIDTH	: NATURAL := 8; 	--each word has 8 bits
			  SIZE			: NATURAL := 128	--we have 128 word with 8 bits each
	 
	 
	 );
    Port ( CLK 			: in  STD_LOGIC;
           DATA_IN 		: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)  ;
           ADDR 			: in  STD_LOGIC_VECTOR(natural(ceil(log2(real(SIZE))))-1 downto 0);
           WE 				: in  STD_LOGIC;
           DATA_OUT 		: out  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
	 );
end single_port_RAM;

architecture Behavioral of single_port_RAM is

	type memory_t is array(SIZE-1 downto 0) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	signal memory : memory_t := (others => (others => '0'));
	

begin
	process(CLK)
	begin
		if (CLK'event and CLK='1') then
			if(WE = '1') then
				memory( to_integer(unsigned(ADDR)) ) <= DATA_IN;
			end if;
		end if;
	end process;


	DATA_OUT <= memory( to_integer(unsigned(ADDR)));
end Behavioral;

