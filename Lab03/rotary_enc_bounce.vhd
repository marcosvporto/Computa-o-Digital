----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:46 04/01/2020 
-- Design Name: 
-- Module Name:    rotary_enc_bounce - Behavioral 
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

entity rotary_enc_bounce is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rot_a : in  STD_LOGIC;
           rot_b : in  STD_LOGIC;
           rot_center : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
end rotary_enc_bounce;

architecture Behavioral of rotary_enc_bounce is

	COMPONENT rotary_encoder_interface
		PORT(
			clk : IN std_logic;
			rotary_a_in : IN std_logic;
			rotary_b_in : IN std_logic;          
			rotary_a_out : OUT std_logic;
			rotary_b_out : OUT std_logic;
			rotary_lft : OUT std_logic;
			rotary_evnt : OUT std_logic
			);
	END COMPONENT;
	
	COMPONENT debounce
	GENERIC (
		clk_freq 	: natural;
		stable_time : natural
	);
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		sw : IN std_logic;          
		db : OUT std_logic;
		tick : OUT std_logic
		);
	END COMPONENT;
	
	type state_type is (regular, inverted);
	signal led_state : state_type := regular;
	
	signal db_rot_center	: STD_LOGIC := '0';
	signal rotary_lft 	: STD_LOGIC := '0';
	signal rotary_evnt	: STD_LOGIC := '0';
	
	signal reg				: STD_LOGIC_VECTOR(7 downto 0) := (others =>'0');
	--signal reg_next		: STD_LOGIC_VECTOR(7 downto 0) := (others =>'0');




begin

	Inst_rotary_encoder_interface: rotary_encoder_interface PORT MAP(
		clk => clk,
		rotary_a_in => rot_a,
		rotary_b_in => rot_b,
		rotary_a_out => open,
		rotary_b_out => open,
		rotary_lft => rotary_lft,
		rotary_evnt => rotary_evnt 
	);
	
	Inst_debounce: debounce
	GENERIC MAP (
		clk_freq 	=> 50_000_000,
		stable_time => 10
	)
	PORT MAP(
		clk => clk,
		reset => reset,
		sw => rot_center,
		db => db_rot_center,
		tick => open
	);
	
	process(rotary_evnt, reset, rotary_lft)
	begin
		if ( reset = '1' ) then
			reg <= ( others =>'0' );
			
		elsif ( rotary_evnt = '1' ) then
			if( rotary_lft = '1' ) then
				if (reg = "10000000") then
					reg <= ( 0 => '1', others =>'0');
				elsif (reg = "00000000") then
					reg <= ( 0 => '1', others =>'0');
				else 
					reg <=  reg(6 downto 0) & '0';
				end if;
				
			else
				if (reg = "00000001") then
					reg <= ( 7 => '1', others =>'0');
				elsif (reg = "00000000") then
					reg <= ( 7 => '1', others =>'0');
				else
					reg <= '0' & reg(7 downto 1);
				end if;
				
			end if;
		
		end if;
	end process;
	
	process(reset, db_rot_center)
	begin
		if reset = '1' then
			led_state <= regular;
		elsif (db_rot_center = '1') then
			if (led_state = regular) then 
				led_state <= inverted;
			else
				led_state <= regular;
			end if;
		end if;
	end process;
	
	leds <= 	reg when led_state = regular else
				not(reg);
	
	
end Behavioral;

