----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:28:22 06/14/2020 
-- Design Name: 
-- Module Name:    ADC - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC is
    Port ( clk 			: in  STD_LOGIC;
           SPI_MOSI 		: out	STD_LOGIC;
           AMP_CS 		: out	STD_LOGIC;
           SPI_SCK 		: out	STD_LOGIC;
           AMP_SHDN 		: out	STD_LOGIC;
           AD_CONV 		: out	STD_LOGIC;
           AMP_DOUT 		: in  STD_LOGIC;
           SPI_MISO 		: in  STD_LOGIC;
			  SPI_SS_B		: out STD_LOGIC;
           DAC_CS 		: out STD_LOGIC;
			  SF_CE0			: out STD_LOGIC;
			  FPGA_INIT_B 	: out STD_LOGIC;
			  LEDS			: out STD_LOGIC_VECTOR(7 downto 0)
			  );
end ADC;

architecture Behavioral of ADC is

	type fsm_t is (idle, gain,adconv1, adconv0, rxing, decode);
	signal state 		: fsm_t := idle;
	signal spi_clk 	: std_logic := '0';
	signal amp_gain 	: std_logic_vector(0 to 7) 		:= "00010001";
	signal adc_msg		: std_logic_vector(33 downto 0) 	:= (others => '0');
	signal ch1_msg		: std_logic_vector(13 downto 0)	:= (others => '0');
	signal signed_msg	: signed(13 downto 0)	:= (others => '0');
	signal data_value	: unsigned(13 downto 0)	:= (others => '0');
	signal counter		: unsigned(3 downto 0) 	:= (others => '0');
	signal bit_counter: unsigned(5 downto 0) 	:= (others => '0');
	signal ad_conv_reg: std_logic := '0';
	signal amp_cs_reg	: std_logic := '1';
	
begin

	AMP_SHDN		<= '0';
	SPI_SS_B		<= '1';		
   DAC_CS 		<= '1';
	SF_CE0		<= '1';
	FPGA_INIT_B <= '0';
	SPI_SCK		<= spi_clk;
	AD_CONV		<= ad_conv_reg;
	AMP_CS		<= amp_cs_reg;
	process(clk)
	begin
		if falling_edge(clk) then
			if counter = "100" then
				counter	<= (others => '0');
				spi_clk 	<= not(spi_clk);
			else 
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	
	
	
	process(spi_clk)
	begin
		if falling_edge(spi_clk) then
			amp_cs_reg <= '1';
			case state is
				when idle	=>
					bit_counter <= (others => '0');
					state	<= gain;
				when gain	=>
					amp_cs_reg <= '0';
					bit_counter <= bit_counter + 1;
					spi_mosi <= amp_gain(to_integer(bit_counter));
					if (bit_counter = 7) then
						state <= adconv1;
						bit_counter <= (others => '0');
					end if;	
				when adconv1 =>
					ad_conv_reg	<= '1';
					state <= adconv0;
				when adconv0	=>
					ad_conv_reg	<= '0';
					state	<= rxing;
				when rxing	=>
					ad_conv_reg	<= '0';
					bit_counter <= bit_counter + 1;
					adc_msg( 33 - to_integer(bit_counter)) <= spi_miso;
					if (bit_counter = 33) then
						bit_counter <= (others => '0');
						state <= decode;
						ad_conv_reg	<= '0';
					end if;
				when decode	=>
					ch1_msg <= adc_msg(31 downto 18);
					signed_msg <= signed(ch1_msg);
					state <= gain;
				when others	=>
				
			end case;
		end if;
	end process;
	
	LEDS <= 
		"00000000" when signed_msg > 6553 else
		"00000001" when signed_msg <= 6553 and signed_msg > 4587 else
		"00000011" when signed_msg <= 4587 and signed_msg > 2621 else
		"00000111" when signed_msg <= 2621 and signed_msg > 983 else
		"00001111" when signed_msg <= 983 and signed_msg > -983 else
		"00011111" when signed_msg <= -983 and signed_msg > -2621 else
		"00111111" when signed_msg <= -2621 and signed_msg > -4587 else
		"01111111" when signed_msg <= -4587 and signed_msg > -6553 else
		"11111111" ;
		
	
	 

end Behavioral;

