----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:33 05/03/2020 
-- Design Name: 
-- Module Name:    low_freq_counter - Behavioral 
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

entity low_freq_counter is
    Port ( clk : in  STD_LOGIC;
           reset 	: in  STD_LOGIC;
           start 	: in  STD_LOGIC;
           si 		: in  STD_LOGIC;
           bcd3 	: out  STD_LOGIC_VECTOR (3 downto 0);
           bcd2 	: out  STD_LOGIC_VECTOR (3 downto 0);
           bcd1 	: out  STD_LOGIC_VECTOR (3 downto 0);
           bcd0 	: out  STD_LOGIC_VECTOR (3 downto 0));
end low_freq_counter;

architecture Behavioral of low_freq_counter is

	type fsm_t is (idle, count, freq, b2bcd);
	signal state_reg, state_next : fsm_t := idle;
	
	signal prd							: std_logic_vector(9 downto 0):= (others => '0');
	signal divisor, dividend, quo	: std_logic_vector(19 downto 0) := (others => '0');
	signal prd_start					: std_logic := '0';
	signal prd_done_tick				: std_logic := '0';
	signal div_start					: std_logic := '0';
	signal div_done_tick				: std_logic := '0';
	signal b2bcd_start				: std_logic := '0';
	signal b2bcd_done_tick			: std_logic := '0';
	
	--====================================
	-- Components
	--====================================
	COMPONENT period_counter
	PORT(
		clk 			: IN 	std_logic;
		reset 		: IN 	std_logic;
		start 		: IN 	std_logic;
		si 			: IN 	std_logic;          
		ready 		: OUT std_logic;
		done_tick 	: OUT std_logic;
		period 		: OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;
	
	COMPONENT division_fsmd
	GENERIC(
		W				: natural;
		CBIT			: natural;
	);
	PORT(
		clk 			: IN 	std_logic;
		reset 		: IN 	std_logic;
		start 		: IN 	std_logic;
		divisor 		: IN 	std_logic_vector(W-1 downto 0);
		dividend 	: IN 	std_logic_vector(W-1 downto 0);          
		ready 		: OUT std_logic;
		done_tick 	: OUT std_logic;
		quotient 	: OUT std_logic_vector(W-1 downto 0);
		remainder 	: OUT std_logic_vector(W-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT bin2bcd
	PORT(
		clk 			: IN 	std_logic;
		reset 		: IN 	std_logic;
		start 		: IN 	std_logic;
		bin 			: IN 	std_logic_vector(13 downto 0);          
		bcd0 			: OUT std_logic_vector(3 downto 0);
		bcd1 			: OUT std_logic_vector(3 downto 0);
		bcd2 			: OUT std_logic_vector(3 downto 0);
		bcd3 			: OUT std_logic_vector(3 downto 0);
		ready 		: OUT std_logic;
		done_tick 	: OUT std_logic
		);
	END COMPONENT;
	
	

begin

	--===============================================
	-- component instantiation
	--===============================================
	Inst_period_counter: period_counter PORT MAP(
		clk 			=> clk,
		reset 		=> reset,
		start 		=> prd_start,
		si 			=> si,
		ready 		=> open,
		done_tick 	=> prd_done_tick,
		period 		=> prd 
	);
	
	
	Inst_division_fsmd: division_fsmd 
	GENERIC MAP (
		W 				=> 20,
		CBIT 			=> 5
	
	);
	PORT MAP(
		clk 			=> clk,
		reset 		=> reset,
		start 		=> div_start,
		divisor 		=> divisor,
		dividend 	=> dividend,
		ready 		=> open,
		done_tick 	=> div_done_tick,
		quotient 	=> quo,
		remainder 	=> open
	);
	
	
	Inst_bin2bcd: bin2bcd PORT MAP(
		clk 			=> clk,
		reset 		=> reset,
		start 		=> b2bcd_start,
		bin 			=> quo(13 downto 0),
		bcd0 			=> bcd0,
		bcd1 			=> bcd1,
		bcd2 			=> bcd2,
		bcd3 			=> bcd3,
		ready 		=> open,
		done_tick 	=> b2bcd_done_tick
	);
	
	--=============================================
	--signal width extension
	--=============================================
	-- the period must be a number between 101 and 1023 ms, thus:
	-- freq = 1_000_000 / prd = X.XXX Hz
	-- and freq in [0.997 - 9.901] Hz
	
	dividend <= std_logic_vector(to_unsigned(1_000_000, 20));
	divisor <= "0000000000" & prd;
end Behavioral;

