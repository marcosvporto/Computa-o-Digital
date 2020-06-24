----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:57:15 05/03/2020 
-- Design Name: 
-- Module Name:    bin2bcd - Behavioral 
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

entity bin2bcd is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           bin : in  STD_LOGIC_VECTOR (12 downto 0);
           bcd0 : out  STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : out  STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : out  STD_LOGIC_VECTOR (3 downto 0);
           bcd3 : out  STD_LOGIC_VECTOR (3 downto 0);
           ready : out  STD_LOGIC;
           done_tick : out  STD_LOGIC);
end bin2bcd;

architecture Behavioral of bin2bcd is

	type fsm_t is (idle, op, done);
	signal state_reg, state_next 	: fsm_t := idle;
	signal p2s_reg, p2s_next		: std_logic_vector (12 downto 0) := (others => '0');
	signal n_reg, n_next				: unsigned(3 downto 0)				:= (others => '0');
	signal bcd3_reg, bcd3_next		: unsigned(3 downto 0)				:= (others => '0');
	signal bcd2_reg, bcd2_next		: unsigned(3 downto 0)				:= (others => '0');
	signal bcd1_reg, bcd1_next		: unsigned(3 downto 0)				:= (others => '0');
	signal bcd0_reg, bcd0_next		: unsigned(3 downto 0)				:= (others => '0');
	signal bcd3_tmp   				: unsigned(2 downto 0)				:= (others => '0');
	signal bcd2_tmp   				: unsigned(3 downto 0)				:= (others => '0');
	signal bcd1_tmp   				: unsigned(3 downto 0)				:= (others => '0');
	signal bcd0_tmp   				: unsigned(3 downto 0)				:= (others => '0');


begin

	-- state and data registers
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				state_reg 	<= idle;
				p2s_reg		<= (others => '0');
				n_reg			<= (others => '0');
				bcd3_reg		<= (others => '0');
				bcd2_reg		<= (others => '0');
				bcd1_reg		<= (others => '0');
				bcd0_reg		<= (others => '0');
			else
				state_reg 	<= state_next;
				p2s_reg		<= p2s_next;
				n_reg			<= n_next;
				bcd3_reg		<= bcd3_next;
				bcd2_reg		<= bcd2_next;
				bcd1_reg		<= bcd1_next;
				bcd0_reg		<= bcd0_next;
			end if;
		end if;
	end process;


	-- fsmd next-state logic / data path operations
	process (state_reg, start, p2s_reg, n_reg, n_next, bin,
				bcd3_reg, bcd2_reg, bcd1_reg, bcd0_reg,
				bcd3_tmp, bcd2_tmp, bcd1_tmp, bcd0_tmp)
	begin
	
		state_next 	<= state_reg;
		ready 		<= '0';
		done_tick 	<= '0';
		p2s_next		<= p2s_reg;
		n_next		<= n_reg;
		bcd3_next	<= bcd3_reg;
		bcd2_next	<= bcd2_reg;
		bcd1_next	<= bcd1_reg;
		bcd0_next	<= bcd0_reg;
		
		case state_reg is
			when idle 	=>
				ready <= '1';
				if (start = '1') then
					bcd3_next	<= (others => '0');
					bcd2_next	<= (others => '0');
					bcd1_next	<= (others => '0');
					bcd0_next	<= (others => '0');
					n_next		<= "1101";	--index
					p2s_next		<= bin;		-- input shift register
					state_next	<= op;
				end if;
				
			when op		=>
				-- shift 4 BCD digits
				bcd3_next		<= bcd3_tmp(2 downto 0) & bcd2_tmp(3);
				bcd2_next		<= bcd2_tmp(2 downto 0) & bcd1_tmp(3);
				bcd1_next		<= bcd1_tmp(2 downto 0) & bcd0_tmp(3);
				bcd0_next		<= bcd0_tmp(2 downto 0) & p2s_reg(12);
				
				-- shift input
				p2s_next 		<= p2s_reg(11 downto 0) & '0';

				-- iteration counter
				n_next 			<= n_reg - 1;
				if (n_next = 0) then
					state_next 	<= done;				
				end if;
				
			when done	=>
				state_next		<= idle;
				done_tick		<= '1';
				
			when others	=>
				state_next		<= idle;
		end case;
	end process;
	
	-- data path function units
	-- four BCD adjustments circuits
	
	bcd0_tmp		<= bcd0_reg + 3 when bcd0_reg > 4 else bcd0_reg;
	bcd1_tmp		<= bcd1_reg + 3 when bcd1_reg > 4 else bcd1_reg;
	bcd2_tmp		<= bcd2_reg + 3 when bcd2_reg > 4 else bcd2_reg;
	bcd3_tmp		<= resize(bcd3_reg + 3, 3) when bcd3_reg > 4 else bcd3_reg(2 downto 0);
	
	-- output
	bcd0	<= std_logic_vector (bcd0_reg);
	bcd1	<= std_logic_vector (bcd1_reg);
	bcd2	<= std_logic_vector (bcd2_reg);
	bcd3	<= std_logic_vector (bcd3_reg);


end Behavioral;

