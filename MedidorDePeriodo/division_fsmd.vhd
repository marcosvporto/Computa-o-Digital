----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:07:56 05/03/2020 
-- Design Name: 
-- Module Name:    division_fsmd - Behavioral 
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

entity division_fsmd is
	generic(
		W						: natural := 8;
		CBIT					: natural := 4  -- CBIT = log2(W) + 1

	);
   Port (  clk 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           start 			: in  STD_LOGIC;
           divisor 		: in  STD_LOGIC_VECTOR (W-1 downto 0);
           dividend 		: in  STD_LOGIC_VECTOR (W-1 downto 0);
           ready 			: out STD_LOGIC;
           done_tick 	: out STD_LOGIC;
           quotient 		: out STD_LOGIC_VECTOR (W-1 downto 0);
           remainder 	: out STD_LOGIC_VECTOR (W-1 downto 0)
	);
end division_fsmd;

architecture Behavioral of division_fsmd is

	type fsm_t is (idle, op, last, done);
	signal state_reg, state_next	: fsm_t := idle;
	
	signal rh_reg, rh_next		: unsigned(W-1 downto 0) := (others => '0');
	signal rl_reg, rl_next		: std_logic_vector(W-1 downto 0) := (others => '0');
	signal rh_tmp					: unsigned(W-1 downto 0) := (others => '0');
	signal d_reg, d_next			: unsigned(W-1 downto 0) := (others => '0');
	signal n_reg, n_next			: unsigned(CBIT-1 downto 0) := (others => '0');
	signal q_bit					: std_logic := '0';
	
	
begin

	-- fsmd state and data registers
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				state_reg 	<= idle;
				rh_reg		<= (others 	=> '0');
				rl_reg		<= (others 	=> '0');
				d_reg			<= (others 	=> '0');
				n_reg			<= (others	=> '0');
			else
				state_reg 	<= state_next;
				rh_reg		<= rh_next;
				rl_reg		<= rl_next;
				d_reg			<= d_next;
				n_reg			<= n_next;
			end if;
		end if;
	end process;
	
	-- fsmd next-state logic and data path logic
	process (state_reg, n_reg, rh_reg, rl_reg, d_reg, start, dividend, divisor,
				q_bit, rh_tmp, n_next)
	
	begin
		ready			<= '0';
		done_tick	<= '0';
		state_next	<= state_reg;
		rh_next		<= rh_reg;
		rl_next		<= rl_reg;
		d_next		<= d_reg;
		n_next		<= n_reg;
		
		
		case state_reg is
			when idle 	=>
				if (start = '1') then
					rh_next		<= (others => '0');
					rl_next		<= dividend;
					d_next		<= unsigned(divisor);
					n_next		<= to_unsigned(W+1, CBIT);
					state_next <= op;
				end if;
			when op 		=>
				--shift rh and rl left
				rh_next	<= rh_tmp(W-2 downto 0) & rl_reg(W-1);
				rl_next	<= rl_reg(W-2 downto 0) & q_bit;
				-- decrease index
				n_next	<= n_reg - 1;
				if (n_next = 1) then
					state_next	<= last;
				end if;
			when last	=> -- last iteration, rh remain rh
				rh_next		<= rh_tmp;
				rl_next		<= rl_reg(W-2 downto 0) & q_bit;
				state_next	<= done;
				
			when done	=>
				state_next	<= idle;
				done_tick	<= '1';
			when others	=>
				state_next	<= idle;
		end case;
	end process;
	
	
	-- compare and subtract
	process(rh_reg, d_reg)
	begin
		if (rh_reg >= d_reg) then
			rh_tmp	<= rh_reg - d_reg;
			q_bit		<= '1';
			
		else
			rh_tmp	<= rh_reg;
			q_bit		<= '0';
		end if;
	end process;
	
	
	-- output
	quotient		<= rl_reg;
	remainder	<= std_logic_vector(rh_reg);


end Behavioral;

