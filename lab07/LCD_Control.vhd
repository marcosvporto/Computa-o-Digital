
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCD_Control is
    Port ( clk 	: in  STD_LOGIC;
           SF_D 	: out STD_LOGIC_VECTOR (11 downto 8);
           LCD_E 	: out STD_LOGIC;
           LCD_RS : out STD_LOGIC;
           LCD_RW : out STD_LOGIC;
			  SF_CE0	: out	STD_LOGIC
			 );
end LCD_Control;

architecture Behavioral of LCD_Control is

	signal COUNTER					:UNSIGNED(19 downto 0) 		:= (others=> '0');
	signal COUNTER_LIMIT			:UNSIGNED(19 downto 0) 		:= (others=> '0');
	signal COUNTER_FLAG_RESET	:STD_LOGIC						:= '0';

	type fsm_t is (idle, i0, i1, i2, i3, i4, i5, i6, i7, i8,
						funcset, entrymode, onoff, clear,
						setDDram, char1, char2, char3, done);
	signal STATE					: fsm_t		:= idle;
begin

	-- Contador
	process(clk)
	begin
		if clk'event and clk = '1' then
				if COUNTER_FLAG_RESET = '1' then
					COUNTER <= (others=>'0');
				else
					COUNTER <= COUNTER + 1;
				end if;
		end if;
	
	end process;
	
	-- setando a flag para resetar o contador
	COUNTER_FLAG_RESET <= '1' when COUNTER = COUNTER_LIMIT else '0';
	
	
	-- Mquina de estados
	
	process(clk)
	begin
		if clk'event and clk = '1' then
			case STATE is
				when idle 	=>
					COUNTER_LIMIT 	<= to_unsigned(750000, COUNTER_LIMIT'length);
					STATE 	<= i0;
				when i0 	=>
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(12, COUNTER_LIMIT'length);
						SF_D 	<= x"3";
						LCD_E	<= '1';
						STATE	<= i1;
					end if;
					
				when i1 		=> 
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(205000, COUNTER_LIMIT'length);
						LCD_E	<= '0';
						STATE	<= i2;
					end if;
				
				when i2 		=> 
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(12, COUNTER_LIMIT'length);
						SF_D 	<= x"3";
						LCD_E	<= '1';
						STATE	<= i3;
					end if;
				when i3 		=> 
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(5000, COUNTER_LIMIT'length);
						LCD_E	<= '0';
						STATE	<= i4;
					end if;
					
				when i4 		=> 
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(12, COUNTER_LIMIT'length);
						SF_D 	<= x"3";
						LCD_E	<= '1';
						STATE	<= i5;
					end if;
				when i5 		=>
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2000, COUNTER_LIMIT'length);
						LCD_E	<= '0';
						STATE	<= i6;
					end if;
				
				when i6 		=>
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(12, COUNTER_LIMIT'length);
						SF_D 	<= x"2";
						LCD_E	<= '1';
						STATE	<= i7;
					end if;
				when i7 		=>
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2000, COUNTER_LIMIT'length);
						LCD_E	<= '0';
						STATE	<= i8;
					end if;
					
				when i8 		=>
					if(COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do upper nibble
						LCD_RS	<= '0';
						SF_D		<= x"2"; -- upper nibble
						STATE		<= funcset;
					end if;
				when funcset => 
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"8"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
						
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do upper nibble
						LCD_RS	<= '0';
						SF_D		<= (others => '0'); -- upper nibble;
						STATE		<= entrymode;
					end if;
					
				when entrymode =>
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"6"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do upper nibble
						LCD_RS	<= '0';
						SF_D		<= (others => '0'); -- upper nibble;
						STATE		<= onoff;
					end if;
					
				when onoff => 
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"C"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(82080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do upper nibble
						LCD_RS	<= '0';
						SF_D		<= (others => '0'); -- upper nibble;
						STATE		<= clear;
					end if;
					
				when clear =>
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"1"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do DD RAM Address = 00
						LCD_RS	<= '0';
						SF_D		<= x"8"; -- upper nibble = 1000;
						STATE		<= setDDram;
					end if;
					
					
				when setDDram =>
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= (others => '0'); -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do primeiro caracter M = x4D
						LCD_RS	<= '1';
						SF_D		<= x"4";
						STATE		<= char1;
					end if;
				when char1 =>
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"D"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do segundo caracter V = x56
						LCD_RS	<= '1';
						SF_D		<= x"5"; -- upper nibble = 1000;
						STATE		<= char2;
					end if;
									
				when char2 => 
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= x"6"; -- lower nibble
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '0'; -- inicio da escrita do terceiro caracter P = x50
						LCD_RS	<= '1';
						SF_D		<= x"5";
						STATE		<= char3;
					end if;
					
				when char3 =>
					if (COUNTER = 2) then -- 2 clks = 40 ns
						LCD_E	<= '1';
					elsif (COUNTER = 14) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 15) then --  1clk = 20ns > 10 ns - fim escrita do upper nible
						LCD_RW <= '1';
					elsif (COUNTER = 65) then -- 50 clks = 1 ms
						LCD_RW <= '0'; -- inicio da escrita do lower nibble
						SF_D		<= (others => '0');
					elsif (COUNTER = 67) then -- 2 clks = 40 ms
						LCD_E <= '1';
					elsif (COUNTER = 79) then -- 12 clks = 240 ns > 230 ns
						LCD_E <= '0';
					elsif (COUNTER = 80) then -- fim escrita do lower nibble
						LCD_RW <= '1';
					elsif (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT 	<= to_unsigned(2080, COUNTER_LIMIT'length);
						LCD_RW	<= '1'; -- apenas leitura
						LCD_RS	<= '0';
						STATE		<= done;
					end if;
					
				when done  =>
					
					
				when others =>
					STATE <= idle;
				
			end case;
		end if;
	
	end process;
	
	
	
	SF_CE0	<= '1';
		
end Behavioral;

