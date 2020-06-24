----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:08:58 03/29/2020 
-- Design Name: 
-- Module Name:    my_fsm1 - Behavioral 
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

entity my_fsm1 is
    Port ( TOG_EN : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           CLR : in  STD_LOGIC;
           Z1 : out  STD_LOGIC);
end my_fsm1;

architecture Behavioral of my_fsm1 is

	type state_type is (ST0, ST1);
	signal PSt, NSt : state_type := ST0;
	
	

begin

	sync_proc : process(CLK, CLR, NSt)
	begin
	
		--take carte of the asynchronous input
		if (CLR = '1') then
			PSt <= ST0;
		elsif rising_edge(CLK) then
			PSt <= NSt;
		end if;
	end process;
	
	-- comb process
	comb_process : process(PSt, TOG_EN)
	begin
		Z1 <= '0'; -- pre-assign output 
		case PSt is
			when ST0 =>
				Z1 <= '0' ;--Moore output
				if (TOG_EN = '1') then 	NSt <= ST1;
				else							NST <= ST0;
				end if;
			when ST1 =>
				Z1 <= '1' ; -- Moore output
				if (TOG_EN = '1') then 	NSt <= ST0;
				else							NSt <= ST1;
				end if;
			when others => -- the catch-all conditional
				Z1 <= '0';  --arbitrary; it should never
				NSt <= ST0; --make it to these two statements
		end case;
	end process;


end Behavioral;

