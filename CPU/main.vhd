----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:40:50 06/14/2020 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

entity main is
    Port ( CLOCK 				: in  STD_LOGIC;
           RESET 				: in  STD_LOGIC;
           LED_CLOCK_OUT 	: out  STD_LOGIC;
           LED_ZERO 			: out  STD_LOGIC;
           LED_NEGATIVO 	: out  STD_LOGIC;
           LED_P30 			: out  STD_LOGIC_VECTOR (4 downto 0);
			  
			  -- LCD 
           SF_D 				: out  STD_LOGIC_VECTOR (11 downto 8);
           LCD_E 				: out  STD_LOGIC;
           LCD_RS 			: out  STD_LOGIC;
           LCD_RW 			: out  STD_LOGIC;
           SF_CE0 			: out  STD_LOGIC);
end main;

architecture Behavioral of main is
	COMPONENT u_cpu
	PORT(
		CLOCK 					: IN std_logic;
		RESET 					: IN std_logic;
		Q 							: IN std_logic_vector(4 downto 0);          
		ADDR 						: OUT std_logic_vector(4 downto 0);
		DATA 						: OUT std_logic_vector(4 downto 0);
		WE 						: OUT std_logic;
		ZERO						: out STD_LOGIC;
		NEGATIVE					: out	STD_LOGIC;
		OPCODE					: out STD_LOGIC_VECTOR(4 downto 0);
		START						: out STD_LOGIC;
		CLOCK_OUT				: out STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT u_memory
	PORT(
		CLOCK : IN std_logic;
		ADDR : IN std_logic_vector(4 downto 0);
		DATA : IN std_logic_vector(4 downto 0);
		WE : IN std_logic;          
		Q : OUT std_logic_vector(4 downto 0);
		LAST_ADDRESS : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
	COMPONENT u_lcd
	PORT(
		clock : IN std_logic;
		START : IN std_logic;
		OPCODE : IN std_logic_vector(4 downto 0);          
		SF_D : OUT std_logic_vector(11 downto 8);
		LCD_E : OUT std_logic;
		LCD_RS : OUT std_logic;
		LCD_RW : OUT std_logic;
		SF_CE0 : OUT std_logic
		);
	END COMPONENT;
	
	signal memory_addr : STD_LOGIC_VECTOR(4 downto 0);
	signal memory_data : STD_LOGIC_VECTOR(4 downto 0);
	signal memory_we : STD_LOGIC;
	signal memory_q : STD_LOGIC_VECTOR(4 downto 0);
	
	signal cpu_start : STD_LOGIC;
	signal cpu_opcode : STD_LOGIC_VECTOR(4 downto 0);
	signal START_R : STD_LOGIC := '0';
   signal START_F : STD_LOGIC := '0';


begin
	process(CLOCK)
    begin
        if (CLOCK'event and CLOCK = '1') then
            START_R <= cpu_start;
        end if;
    end process;
    START_F <= cpu_start AND NOT(START_R);

	Inst_u_cpu: u_cpu PORT MAP(
		CLOCK 	=> CLOCK,
		RESET 	=> RESET,
		ADDR 		=> memory_addr,
		DATA 		=> memory_data,
		WE 		=> memory_we,
		Q 			=> memory_q,
		ZERO 		=> LED_ZERO,				
		NEGATIVE	=> LED_NEGATIVO,
		OPCODE 	=> cpu_opcode,		
		START		=> cpu_start,
		CLOCK_OUT=> LED_CLOCK_OUT
	);
	
	Inst_u_memory: u_memory PORT MAP(
		CLOCK => CLOCK,
		ADDR => memory_addr,
		DATA => memory_data,
		WE => memory_we,
		Q => memory_q,
		LAST_ADDRESS => LED_P30
	);
	
	Inst_u_lcd: u_lcd PORT MAP(
		clock => CLOCK,
		START => START_F,
		OPCODE => cpu_opcode,
		SF_D => SF_D,
		LCD_E => LCD_E,
		LCD_RS => LCD_RS,
		LCD_RW => LCD_RW,
		SF_CE0 => SF_CE0
	);


end Behavioral;

