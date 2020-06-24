

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity u_lcd is
    Port ( clock 	: in  	STD_LOGIC;
           START 	: in  	STD_LOGIC;
           OPCODE : in  	STD_LOGIC_VECTOR (4 downto 0);
           SF_D 	: out  	STD_LOGIC_VECTOR (11 downto 8);
           LCD_E 	: out  	STD_LOGIC;
           LCD_RS : out  	STD_LOGIC;
           LCD_RW : out  	STD_LOGIC;
           SF_CE0 : out  	STD_LOGIC
			 );
end u_lcd;

architecture Behavioral of u_lcd is

	type FSM_t is (idle, init_a, init_b, conf_a, conf_b, write_a, write_b, finish);
    signal STATE : FSM_t := idle;
    
    signal SF_D_REG           : std_logic_vector(11 downto 8) := (others => '0');
    signal LCD_E_REG          : std_logic := '0';
    signal LCD_RS_REG         : std_logic := '0';
    signal LCD_RW_REG         : std_logic := '0';

    type INIT_DATA_t is array (0 to 3) of std_logic_vector(3 downto 0);
    signal INIT_DATA : INIT_DATA_t := (0 => x"3", 1 => x"3", 2 => x"3", 3 => x"2");

    type INIT_TIME_t is array (0 to 7) of std_logic_vector(19 downto 0);
    signal INIT_TIME : INIT_TIME_t := (
       0 => std_logic_vector(to_unsigned(12, 20)),
       1 => std_logic_vector(to_unsigned(205000, 20)),
       2 => std_logic_vector(to_unsigned(12, 20)),
       3 => std_logic_vector(to_unsigned(5000, 20)),
       4 => std_logic_vector(to_unsigned(12, 20)),
       5 => std_logic_vector(to_unsigned(2000, 20)),
       6 => std_logic_vector(to_unsigned(12, 20)),
       7 => std_logic_vector(to_unsigned(2000, 20))
    );
	 
	 type CONF_DATA_t is array (0 to 7) of std_logic_vector(3 downto 0);
    signal CONF_DATA : CONF_DATA_t := (
        0 => x"2", 1 => x"8",
        2 => x"0", 3 => x"6",
        4 => x"0", 5 => x"C",
        6 => x"0", 7 => x"1"
    );

    type CONF_TIME_t is array (0 to 15) of std_logic_vector(19 downto 0);
    signal CONF_TIME : CONF_TIME_t := (
       0  => std_logic_vector(to_unsigned(12, 20)),
       1  => std_logic_vector(to_unsigned(50, 20)),
       2  => std_logic_vector(to_unsigned(12, 20)),
       3  => std_logic_vector(to_unsigned(2000, 20)),
       4  => std_logic_vector(to_unsigned(12, 20)),
       5  => std_logic_vector(to_unsigned(50, 20)),
       6  => std_logic_vector(to_unsigned(12, 20)),
       7  => std_logic_vector(to_unsigned(2000, 20)),
       8  => std_logic_vector(to_unsigned(12, 20)),
       9  => std_logic_vector(to_unsigned(50, 20)),
       10 => std_logic_vector(to_unsigned(12, 20)),
       11 => std_logic_vector(to_unsigned(2000, 20)),
       12 => std_logic_vector(to_unsigned(12, 20)),
       13 => std_logic_vector(to_unsigned(50, 20)),
       14 => std_logic_vector(to_unsigned(12, 20)),
       15 => std_logic_vector(to_unsigned(82000, 20))
   );
	
	-- 18 / 2 = 9 bytes
    type WRITE_DATA_t is array (0 to 17) of std_logic_vector(3 downto 0);
    signal WRITE_DATA : WRITE_DATA_t := (
        0 => x"2", 1 => x"0", --  
        2 => x"2", 3 => x"0", --  
        4 => x"2", 5 => x"0", --  
        6 => x"2", 7 => x"0", --  
        8 => x"2", 9 => x"0", --  
       10 => x"2",11 => x"0", --  
       12 => x"2",13 => x"0", --  
       14 => x"2",15 => x"0", -- 
		 16 => x"2",17 => x"0"		 
		);
    constant MOV_A : WRITE_DATA_t := (
        0 => x"4", 1 => x"D", -- M
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"6", -- V
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"5",13 => x"B", -- [
       14 => x"2",15 => x"3", -- #
       16 => x"5",17 => x"D"  -- ]
    );
    constant MOV_B : WRITE_DATA_t := (
        0 => x"4", 1 => x"D", -- M
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"6", -- V
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"2", -- B
       10 => x"2",11 => x"C", -- ,
       12 => x"5",13 => x"B", -- [
       14 => x"2",15 => x"3", -- #
       16 => x"5",17 => x"D"  -- ]
    );
	 constant MOV_endA : WRITE_DATA_t := (
        0 => x"4", 1 => x"D", -- M
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"6", -- V
        6 => x"2", 7 => x"0", --  
        8 => x"5", 9 => x"B", -- [
       10 => x"2",11 => x"3", -- #
       12 => x"5",13 => x"D", -- ]
       14 => x"2",15 => x"C", -- ,
       16 => x"4",17 => x"1"  -- A
    );
	  constant MOV_AB : WRITE_DATA_t := (
        0 => x"4", 1 => x"D", -- M
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"6", -- V
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"2", -- B
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant MOV_BA : WRITE_DATA_t := (
        0 => x"4", 1 => x"D", -- M
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"6", -- V
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"2", -- B
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"1", -- A
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant ADD_AB : WRITE_DATA_t := (
        0 => x"4", 1 => x"1", -- A
        2 => x"4", 3 => x"4", -- D
        4 => x"5", 5 => x"4", -- D
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"2", -- B
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant SUB_AB : WRITE_DATA_t := (
        0 => x"5", 1 => x"3", -- S
        2 => x"5", 3 => x"5", -- U
        4 => x"4", 5 => x"2", -- B
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"2", -- B
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant AND_AB : WRITE_DATA_t := (
        0 => x"4", 1 => x"1", -- A
        2 => x"4", 3 => x"E", -- N
        4 => x"4", 5 => x"4", -- D
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"2", -- B
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant OR_AB : WRITE_DATA_t := (
        0 => x"4", 1 => x"F", -- O
        2 => x"5", 3 => x"2", -- R
        4 => x"2", 5 => x"0", -- 
        6 => x"4", 7 => x"1", -- A 
        8 => x"2", 9 => x"C", -- ,
       10 => x"4",11 => x"2", -- B
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant XOR_AB : WRITE_DATA_t := (
        0 => x"5", 1 => x"8", -- X
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"2", -- R
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"C", -- ,
       12 => x"4",13 => x"2", -- B
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant NOT_A : WRITE_DATA_t := (
        0 => x"4", 1 => x"E", -- N
        2 => x"4", 3 => x"F", -- O
        4 => x"5", 5 => x"4", -- T
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant NAND_AB : WRITE_DATA_t := (
        0 => x"4", 1 => x"E", -- N
        2 => x"4", 3 => x"1", -- A
        4 => x"4", 5 => x"E", -- N
        6 => x"4", 7 => x"4", -- D 
        8 => x"2", 9 => x"0", -- 
       10 => x"4",11 => x"1", -- A
       12 => x"2",13 => x"C", -- ,
       14 => x"4",15 => x"2", -- B
       16 => x"2",17 => x"0"  -- 
    );
	 constant JZ : WRITE_DATA_t := (
        0 => x"4", 1 => x"A", -- J
        2 => x"4", 3 => x"A", -- Z
        4 => x"2", 5 => x"0", -- 
        6 => x"5", 7 => x"B", -- [ 
        8 => x"2", 9 => x"3", -- #
       10 => x"5",11 => x"D", -- ]
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant JN : WRITE_DATA_t := (
        0 => x"4", 1 => x"A", -- J
        2 => x"4", 3 => x"E", -- N
        4 => x"2", 5 => x"0", -- 
        6 => x"5", 7 => x"B", -- [ 
        8 => x"2", 9 => x"3", -- #
       10 => x"5",11 => x"D", -- ]
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant HALT : WRITE_DATA_t := (
        0 => x"4", 1 => x"8", -- H
        2 => x"4", 3 => x"1", -- A
        4 => x"4", 5 => x"C", -- L
        6 => x"5", 7 => x"4", -- T
        8 => x"2", 9 => x"0", -- 
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant JMP : WRITE_DATA_t := (
        0 => x"4", 1 => x"A", -- J
        2 => x"4", 3 => x"D", -- M
        4 => x"5", 5 => x"0", -- P
        6 => x"2", 7 => x"0", --  
        8 => x"5", 9 => x"B", -- [
       10 => x"2",11 => x"3", -- #
       12 => x"5",13 => x"D", -- ]
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	constant INC_A : WRITE_DATA_t := (
        0 => x"4", 1 => x"9", -- I
        2 => x"4", 3 => x"E", -- N
        4 => x"5", 5 => x"3", -- C
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant INC_B : WRITE_DATA_t := (
        0 => x"4", 1 => x"9", -- I
        2 => x"4", 3 => x"E", -- N
        4 => x"5", 5 => x"3", -- C
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"2", -- B
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant DEC_A : WRITE_DATA_t := (
        0 => x"4", 1 => x"4", -- D
        2 => x"4", 3 => x"5", -- E
        4 => x"5", 5 => x"3", -- C
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"1", -- A
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );
	 constant DEC_B : WRITE_DATA_t := (
        0 => x"4", 1 => x"4", -- D
        2 => x"4", 3 => x"5", -- E
        4 => x"5", 5 => x"3", -- C
        6 => x"2", 7 => x"0", --  
        8 => x"4", 9 => x"2", -- B
       10 => x"2",11 => x"0", -- 
       12 => x"2",13 => x"0", -- 
       14 => x"2",15 => x"0", -- 
       16 => x"2",17 => x"0"  -- 
    );

    type WRITE_TIME_t is array (0 to 3) of std_logic_vector(19 downto 0);
    signal WRITE_TIME : WRITE_TIME_t := (
       0  => std_logic_vector(to_unsigned(12, 20)),
       1  => std_logic_vector(to_unsigned(50, 20)),
       2  => std_logic_vector(to_unsigned(12, 20)),
       3  => std_logic_vector(to_unsigned(2000, 20))
   );


begin

	SF_CE0 <= '1'; -- STRATA FLASH DISABLED

    process(clock)
        variable counter       : unsigned(19 downto 0) := (others => '0');
        variable counter_limit : unsigned(19 downto 0) := (others => '0');
        variable step          : unsigned(5  downto 0) := (others => '0'); -- 0 - 63
    begin
        if (clock'event and clock = '1') then
            case STATE is
                when idle =>
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '0';
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := TO_UNSIGNED(750000, 20);
                    if (counter = counter_limit) then
                        STATE <= init_a;
                        counter := (others => '0');
                        step := (others => '0');
                        --report "WAIT 15 ms!" severity note;
                    end if;
                    
                when init_a =>
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '1';
                    SF_D_REG   <= INIT_DATA(to_integer(step(4 downto 1)));
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(INIT_TIME(to_integer(step)));
                    if (counter = counter_limit) then
                        STATE <= init_b;
                        counter := (others => '0');
                        step := step + 1;
                        --report "INIT => LCD_E = '1' for 12 clock cycles!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                    end if;
                    
                when init_b =>
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '0';
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(INIT_TIME(to_integer(step)));
                    if (counter = counter_limit) then
                        counter := (others => '0');
                        step := step + 1;
                        --report "INIT => LCD_E = '0'!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                        if (step = TO_UNSIGNED(8, step'length)) then
                            STATE <= conf_a;
                            step := (others => '0');
                        else
                            STATE <= init_a;
                        end if;
                    end if;
                    
                when conf_a =>
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '1';
                    SF_D_REG   <= CONF_DATA(to_integer(step(4 downto 1)));
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(CONF_TIME(to_integer(step)));
                    if (counter = counter_limit) then
                        STATE <= conf_b;
                        counter := (others => '0');
                        step := step + 1;
                        --report "CONF => LCD_E = '1' for 12 clock cycles!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                    end if;
                
                when conf_b =>
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '0';
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(CONF_TIME(to_integer(step)));
                    if (counter = counter_limit) then
                        counter := (others => '0');
                        step := step + 1;
                        --report "CONF => LCD_E = '0'!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                        if (step = TO_UNSIGNED(16, step'length)) then
                            STATE <= write_a;
                            step := (others => '0');
                        else
                            STATE <= conf_a;
                        end if;
                    end if;
                    
                when write_a =>
                    LCD_RS_REG <= '1'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '1';
                    SF_D_REG   <= WRITE_DATA(to_integer(step(4 downto 1)));
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(WRITE_TIME(to_integer(step(1 downto 0))));
                    if (counter = counter_limit) then
                        STATE <= write_b;
                        counter := (others => '0');
                        step := step + 1;
                        --report "WRITE => LCD_E = '1' for 12 clock cycles!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                    end if;
                
                when write_b =>
                    LCD_RS_REG <= '1'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '0';
                    COUNTER := COUNTER + 1;
                    COUNTER_LIMIT := UNSIGNED(WRITE_TIME(to_integer(step(1 downto 0))));
                    if (counter = counter_limit) then
                        counter := (others => '0');
                        step := step + 1;
                        --report "WRITE => LCD_E = '0'!" severity note;
                        --report "STEP = " & natural'image(natural(to_integer(step))) severity note;
                        if (step = TO_UNSIGNED(36, step'length)) then
                            STATE <= finish;
                            step := (others => '0');
                            --report "FINISHED!" severity note;
                        else
                            STATE <= write_a;
                        end if;
                    end if;
                    
                when finish =>
                    if (START = '1') then
                        if    (OPCODE = "00001") then
                            report "MOV A,[#]" severity note;
                            WRITE_DATA <= MOV_A;
                        elsif (OPCODE = "00010") then
                            report "MOV [#],A" severity note;
									 WRITE_DATA <= MOV_endA;
                        elsif (OPCODE = "00011") then
                            report "MOV A,B" severity note;
									 WRITE_DATA <= MOV_AB;
                        elsif (OPCODE = "00100") then
                            report "MOV B,A" severity note;
									 WRITE_DATA <= MOV_BA;
                        elsif (OPCODE = "00101") then
                            report "ADD A,B" severity note;
									 WRITE_DATA <= ADD_AB;
                        elsif (OPCODE = "00110") then
                            report "SUB A,B" severity note;
									 WRITE_DATA <= SUB_AB;
                        elsif (OPCODE = "00111") then
                            report "AND A,B" severity note;
									 WRITE_DATA <= AND_AB;
                        elsif (OPCODE = "01000") then
                            report "OR  A,B" severity note;
									 WRITE_DATA <= OR_AB;
                        elsif (OPCODE = "01001") then
                            report "XOR A,B" severity note;
									 WRITE_DATA <= XOR_AB;
                        elsif (OPCODE = "01010") then
                            report "NOT A" severity note;
									 WRITE_DATA <= NOT_A;
                        elsif (OPCODE = "01011") then
                            report "NAND A,B" severity note;
									 WRITE_DATA <= NAND_AB;
                        elsif (OPCODE = "01100") then
                            report "JZ  [#]" severity note;
									 WRITE_DATA <= JZ;
                        elsif (OPCODE = "01101") then
                            report "JN  [#]" severity note;
									 WRITE_DATA <= JN;
                        elsif (OPCODE = "01110") then
                            report "HALT" severity note;
									 WRITE_DATA <= HALT;
                        elsif (OPCODE = "01111") then
                            report "JMP [#]" severity note;
									 WRITE_DATA <= JMP;
                        elsif (OPCODE = "10000") then
                            report "INC A" severity note;
									 WRITE_DATA <= INC_A;
                        elsif (OPCODE = "10001") then
                            report "INC B" severity note;
									 WRITE_DATA <= INC_B;
                        elsif (OPCODE = "10010") then
                            report "DEC A" severity note;
									 WRITE_DATA <= DEC_A;
                        elsif (OPCODE = "10011") then
                            report "DEC B" severity note;
									 WRITE_DATA <= DEC_B;
                        end if;
						
                        STATE <= conf_a; -- CLEAR SCREEN
                    end if;
                    LCD_RS_REG <= '0'; 
                    LCD_RW_REG <= '0';
                    LCD_E_REG  <= '0';
                    SF_D_REG   <= (others => '0');
                    
                when others =>
                    STATE <= idle;
            end case;
        end if;
    end process;

    SF_D   <= SF_D_REG;
    LCD_E  <= LCD_E_REG;
    LCD_RS <= LCD_RS_REG;
    LCD_RW <= LCD_RW_REG;


end Behavioral;

