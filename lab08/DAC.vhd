
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity DAC is
    Port ( clk : 				in  STD_LOGIC;
           SPI_MOSI : 		out  STD_LOGIC;
           DAC_CS : 			out  STD_LOGIC;
           SPI_SCK : 		out  STD_LOGIC;
			  DAC_CLR : 		out STD_LOGIC;	
           SPI_MISO : 		in  STD_LOGIC;
           SPI_SS_B : 		out  STD_LOGIC;
           AMP_CS : 			out  STD_LOGIC;
           AD_CONV : 		out  STD_LOGIC;
           SF_CE0 : 			out  STD_LOGIC;
           FPGA_INIT_B : 	out  STD_LOGIC);
end DAC;

architecture Behavioral of DAC is
	
	type fsm_t is (idle, dontcare, command, address, data, dontcare2, done);
	signal state : fsm_t := idle;
	signal data_counter 	: unsigned(11 downto 0):= (others => '0');
	signal counter		  	: unsigned(3 downto 0) := (others => '0');
	signal counter_limit	: unsigned(3 downto 0) := (others => '0');
	signal counter_flag_reset 	: STD_LOGIC := '0';
	constant command_vector		: STD_LOGIC_VECTOR(3 downto 0) := "0011";
	signal counter_enable: STD_LOGIC := '0';
begin
	
	SPI_SS_B 	<= '1';
	AMP_CS 		<= '1';
	AD_CONV 		<= '0';
	SF_CE0 		<= '1';
	FPGA_INIT_B <= '1';
	SPI_SCK		<= clk;
	DAC_CLR		<= '1';
	
--	process(clk)
--	begin
--		if falling_edge(clk) then
--			if (counter_enable = '1') then
--				if (COUNTER_FLAG_RESET = '1') then
--					COUNTER <= (others => '0');
--				else
--					COUNTER <= COUNTER + 1 ;
--				end if;
--			
--			else 
--			COUNTER <= (others => '0');
--			end if;
--		end if;
--	end process;
	
	COUNTER_FLAG_RESET <= '1' when COUNTER = COUNTER_LIMIT else '0';
	
	process(clk)
	begin
		if falling_edge(clk) then
			case state is
				when idle 		=>
					COUNTER <= (others => '0');
					counter_enable <= '0';
					data_counter <= data_counter + 1;
					DAC_CS	<= '1';
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT <= to_unsigned(7, 4);
						COUNTER <= (others => '0');
						state 	<= dontcare;
					end if;
				when dontcare 	=>
					COUNTER <= COUNTER + 1 ;
					counter_enable <= '1';
					DAC_CS	<= '0';
					SPI_MOSI <= '0';
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER <= (others => '0');
						COUNTER_LIMIT <= to_unsigned(3, 4);
						state 	<= command;
					end if;
				when command 	=>
					COUNTER <= COUNTER + 1 ;
					SPI_MOSI <= command_vector(to_integer(3 - COUNTER));
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT <= to_unsigned(3, 4);
						COUNTER <= (others => '0');
						state 	<= address;
					end if;
				when address	=>
					COUNTER <= COUNTER + 1 ;
					SPI_MOSI <= '0';
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT <= to_unsigned(11, 4);
						COUNTER <= (others => '0');
						state 	<= data;
					end if;
				when data		=>
					COUNTER <= COUNTER + 1 ;
					SPI_MOSI	<= data_counter(11 - to_integer(COUNTER));
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT <= to_unsigned(3, 4);
						COUNTER <= (others => '0');
						state 	<= dontcare2;
					end if;
				when dontcare2 =>
					COUNTER <= COUNTER + 1 ;
					SPI_MOSI	<= '0';
					if (COUNTER_FLAG_RESET = '1') then
						COUNTER_LIMIT <= to_unsigned(0, 4);
						COUNTER <= (others => '0');
						state 	<= idle;
					end if;
				when others		=>
					state <= idle;
			end case;
		end if;
	end process;

end Behavioral;

