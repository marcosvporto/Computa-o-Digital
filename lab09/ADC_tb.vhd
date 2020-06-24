--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:10:11 06/21/2020
-- Design Name:   
-- Module Name:   /home/ise/lab09/ADC_tb.vhd
-- Project Name:  lab09
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ADC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY ADC_tb IS
END ADC_tb;
 
ARCHITECTURE behavior OF ADC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ADC
    PORT(
         clk : IN  std_logic;
         SPI_MOSI : OUT  std_logic;
         AMP_CS : OUT  std_logic;
         SPI_SCK : OUT  std_logic;
         AMP_SHDN : OUT  std_logic;
         AD_CONV : OUT  std_logic;
         AMP_DOUT : IN  std_logic;
         SPI_MISO : IN  std_logic;
         SPI_SS_B : OUT  std_logic;
         DAC_CS : OUT  std_logic;
         SF_CE0 : OUT  std_logic;
         FPGA_INIT_B : OUT  std_logic;
         LEDS : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal AMP_DOUT : std_logic := '0';
   signal SPI_MISO : std_logic := '0';

 	--Outputs
   signal SPI_MOSI : std_logic;
   signal AMP_CS : std_logic;
   signal SPI_SCK : std_logic;
   signal AMP_SHDN : std_logic;
   signal AD_CONV : std_logic;
   signal SPI_SS_B : std_logic;
   signal DAC_CS : std_logic;
   signal SF_CE0 : std_logic;
   signal FPGA_INIT_B : std_logic;
   signal LEDS : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	
	signal channel1 : std_logic_vector(13 downto 0) := "01101011101001"; -- -7191
	signal channel2 : std_logic_vector(13 downto 0) := "01101011101001"; -- 6889
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ADC PORT MAP (
          clk => clk,
          SPI_MOSI => SPI_MOSI,
          AMP_CS => AMP_CS,
          SPI_SCK => SPI_SCK,
          AMP_SHDN => AMP_SHDN,
          AD_CONV => AD_CONV,
          AMP_DOUT => AMP_DOUT,
          SPI_MISO => SPI_MISO,
          SPI_SS_B => SPI_SS_B,
          DAC_CS => DAC_CS,
          SF_CE0 => SF_CE0,
          FPGA_INIT_B => FPGA_INIT_B,
          LEDS => LEDS
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	variable msg : std_logic_vector(13 downto 0) := (others => '0');
   begin		
      for idx in 0 to 50 loop
			SPI_MISO <= 'Z';
			wait until AD_CONV = '1';
			wait until AD_CONV = '0';

			
			wait until SPI_SCK = '1';
			wait until SPI_SCK = '0';
		
			wait until SPI_SCK = '1';
			wait until SPI_SCK = '0';
		
		
			for  index  in  0 to 13  loop
				wait until SPI_SCK = '1';
				wait for 6 ns;
				--SPI_MISO <= channel1(13-index);
				msg := STD_LOGIC_VECTOR(to_signed(8191, 14) - to_signed(idx*(321),14)); 
				SPI_MISO	<= msg(13 - index);
				wait until SPI_SCK = '0';
			end loop; 
		
			wait until SPI_SCK = '1';
			wait until SPI_SCK = '0';

			
		 
			wait until SPI_SCK = '1';
			wait until SPI_SCK = '0';

			for  index  in  0 to 13  loop
				wait until SPI_SCK = '1';
				wait for 6 ns;
				--SPI_MISO <= channel2(13-index);
				msg := STD_LOGIC_VECTOR(to_signed(8191, 14) - to_signed(idx*(321),14)); 
				SPI_MISO	<= msg(13 - index);
					
				wait until SPI_SCK = '0';
			end loop; 
			
			wait until SPI_SCK = '1';
			SPI_MISO <= 'Z';
			wait until SPI_SCK = '0';
		end loop;
		
   end process;

END;
