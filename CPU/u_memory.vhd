
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity u_memory is
	Generic(
				WORD_SIZE            : natural := 5;    -- X bits        (word size)
				RAM_ADDRESS_LENGTH   : natural := 2**5; -- 2**N          (# words)
				RAM_ADDRESS_WIDTH    : natural := 5     -- N             (address length)
	);

	Port ( 	CLOCK 					: in  STD_LOGIC;
				ADDR 						: in  STD_LOGIC_VECTOR(RAM_ADDRESS_WIDTH-1 downto 0); -- in natural range 0 to 2**ADDR_WIDTH - 1;
				DATA 						: in  STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0);
				WE 						: in  STD_LOGIC;
				Q 							: out STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0);
				LAST_ADDRESS 			: out STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0)
	);
end u_memory;

architecture Behavioral of u_memory is

	type MEM_t is array(0 to RAM_ADDRESS_LENGTH-1) of STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0);
    signal ram_block         : MEM_t := (
			  
			0		=> "00001", -- MOV A, [30] 
			1		=> "11110", -- [30]				<---> a = 5 
			2		=> "00100", -- MOV B, A			<---> b = 5
			3		=> "00001", -- MOV A, [29]   	<---> inicio do loop
			4		=> "11101", -- [29]				<---> a = 6
			5		=> "10010", -- DEC A				<---> a = 5
			6		=> "01100", -- JZ [17]
			7		=> "10001", -- [17]
			8		=> "00010", -- MOV [29], A		
			9		=> "11101", -- [29]
			10		=> "00001", -- MOV A, [30]
			11		=> "11110", -- [30]
			12		=> "00101", -- ADD A, B
			13		=> "00010", -- MOV [30], A
			14		=> "11110", -- [30]
			15		=> "01111", -- JMP [3]
			16		=> "00011", -- [3]
			17		=> "00001", -- MOV A, 30
			18		=> "11110", -- [30]
			19		=> "00010", -- MOV [28] ,A
			20		=> "11100", -- [28]
			21		=> "01110", -- HALT
			
			28    => "00000", -- contem o resultado
			29		=> "00011", -- contm x  = 3
			30		=> "00100", -- contm y  = 4
         31   	=> "11111",
        others => (others => '0')
    );
    
    signal q_reg             : STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0) := (others => '0');

begin
	PROCESS(CLOCK)
    BEGIN
        IF (clock'event AND clock = '1') THEN -- Port A
            IF (we = '1') THEN
                ram_block(to_integer(unsigned(addr))) <= data;
                -- Read-during-write on the same port returns NEW data
                q_reg <= data;
            ELSE
                -- Read-during-write on the mixed port returns OLD data
                q_reg <= ram_block(to_integer(unsigned(addr)));
            END IF;
        END IF;
    END PROCESS;

    q            <= q_reg;
    last_address <= ram_block(to_integer(to_unsigned(31, 5)));

end Behavioral;

