----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:15:55 05/03/2020 
-- Design Name: 
-- Module Name:    period_counter - Behavioral 
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

entity period_counter is
    Port ( clk 		: in  STD_LOGIC;
           reset 		: in  STD_LOGIC;
           start 		: in  STD_LOGIC;
           si 			: in  STD_LOGIC;
           ready 		: out  STD_LOGIC;
           done_tick : out  STD_LOGIC;
           period 	: out  STD_LOGIC_VECTOR (9 downto 0)); -- 0 to 1023 ms
end period_counter;

architecture Behavioral of period_counter is

	constant	CLK_MS_COUNT	: natural := 50_000; -- 1 ms tick
	
	type fsm_t is (idle, waite, count, done);
	signal state_reg, state_next : fsm_t := idle;
	
	
	-- 2^16 = 65536
	signal t_reg, t_next			: unsigned (15 downto 0):= (others => '0');
	-- 2^10 = 1024					
	signal p_reg, p_next			: unsigned (9 downto 0) := (others => '0');
	signal delay_reg				: std_logic		:= '0';
	signal edge						: std_logic		:= '0';
	
begin

	-- state and data register
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				state_reg	<= idle;
				t_reg			<= (others => '0');
				p_reg			<= (others => '0');
				delay_reg	<= '0';
			else
				state_reg	<= state_next;
				t_reg			<= t_next;
				p_reg			<= p_next;
				delay_reg	<= si;
			end if;
		end if;
	end process;
	
	
	-- edge detector circuit
	edge		<= (not delay_reg) and si;
	
	-- fsmd next-state logic and data path operations
	
	process(start, edge, state_reg, t_reg, t_next, p_reg)
	begin
	
		ready			<= '0';
		done_tick	<= '0';
		state_next	<= state_reg;
		p_next		<= p_reg;
		t_next		<= t_reg;
		
		case state_reg is
			when idle 	=>
				ready	<= '1';
				if (start = '1') then
					state_next	<= waite;
				end if;
			when waite	=> -- wait for the first edge
				if (edge = '1') then
					state_next	<= count;
					t_next		<= (others => '0');
					p_next		<= (others => '0');
				end if;
			when count	=>
				if (edge = '1') then -- 2nd edge arrived
					state_next	<= done;
				else
					if (t_reg = CLK_MS_COUNT-1) then -- 1ms tick
						t_next		<= (others => '0');
						p_next		<= p_reg + 1;
					else
						t_next		<= t_reg + 1;
					end if;
				end if;
			when done	=>
				done_tick	<= '1';
				state_next	<= idle;
			when others	=>
				state_next	<= idle;
		end case;
	
	end process;


	period	<= std_logic_vector(p_reg);
	

end Behavioral;

