
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity u_cpu is
	
    Port ( 
			CLOCK 					: in  STD_LOGIC;
			RESET						: in 	STD_LOGIC;
			
			-- MEMORY
			ADDR 						: out  STD_LOGIC_VECTOR(4 downto 0); -- in natural range 0 to 2**ADDR_WIDTH - 1;
			DATA 						: out STD_LOGIC_VECTOR(4 downto 0);
			WE 						: out STD_LOGIC;
			Q 							: in STD_LOGIC_VECTOR(4 downto 0);
			
			-- ALU FLAGS
			ZERO						: out STD_LOGIC;
			NEGATIVE					: out	STD_LOGIC;
			
			-- LCD
			OPCODE					: out STD_LOGIC_VECTOR(4 downto 0);
			START						: out STD_LOGIC;
			CLOCK_OUT				: out STD_LOGIC
	);
end u_cpu;

architecture Behavioral of u_cpu is

	COMPONENT alu
	PORT(
		A : IN std_logic_vector(4 downto 0);
		B : IN std_logic_vector(4 downto 0);
		OP : IN std_logic_vector(4 downto 0);
		enable : IN std_logic;          
		ALU_Out : OUT std_logic_vector(4 downto 0);
		Carryout : OUT std_logic;
		Zero_flag : OUT std_logic;
		negative_flag : OUT std_logic
		);
	END COMPONENT;

	type cpu_t is (hold, fetch, decode, execute);
	signal state 	: cpu_t := hold;
	
	-- Instruction Register
	-- E atualizado com a instruao coletada da memoria no estado de fetch
	signal IR 		: STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); 
	
	-- Program Counter
	-- E incrementado quando uma intrucao e executada 
	-- aponta para a proxima instrucao a ser executada
	signal PC 		: STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); 
	
	-- Memory address register
	-- E atualizado com a posicao da memoria referente ao endereco a ser acessado
	signal MAR 		: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	
	signal reg_A	: STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); 
	signal reg_B 	: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

	signal ALU_ENABLE: STD_LOGIC := '0';
	
	signal ALU_out_reg : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	
	signal ALU_zero : STD_LOGIC := '0';
	signal ALU_zero_reg : STD_LOGIC := '0';

	signal ALU_negative: STD_LOGIC := '0';
	signal ALU_negative_reg: STD_LOGIC := '0';
	
	signal cpu_clk_counter: unsigned(17 downto 0) := (others => '0') ;
	signal cpu_clk: STD_LOGIC := '0';
	
	
	
	
begin

	Inst_alu: alu PORT MAP(
		A => STD_LOGIC_VECTOR(reg_A),
		B => STD_LOGIC_VECTOR(reg_B),
		OP => STD_LOGIC_VECTOR(IR),
		enable => ALU_ENABLE,
		ALU_Out => ALU_out_reg,
		Carryout => open ,
		Zero_flag => ALU_zero,
		negative_flag => ALU_negative 
	);

	ZERO 			<= ALU_zero_reg;
	NEGATIVE		<= ALU_negative_reg;
	CLOCK_OUT	<= cpu_clk;
	
	process(CLOCK)
	begin
		if CLOCK'event and CLOCK = '1' then
			cpu_clk_counter <= cpu_clk_counter + 1;
		end if;
	end process;
	
	cpu_clk <= cpu_clk_counter(17);
	
	process(ALU_ENABLE)
	begin
		if ALU_ENABLE'event and ALU_ENABLE = '0' then
			 ALU_zero_reg 		<= ALU_zero;
			 ALU_negative_reg <= ALU_negative;
		end if;
	end process;
	
	process(cpu_clk)
	begin
		if (cpu_clk'event and cpu_clk = '1') then
			START <= '0';
			case state is
				when hold 		=>
					-- no boot, todos os registradores sao zerados
					WE		<= '0';
					MAR 	<= (others => '0');
					IR		<= (others => '0');
					PC		<= (others => '0');
					if RESET = '0' then
						state <= fetch;
					end if;
				when fetch		=>
					START <= '1';
					OPCODE <= Q;
					WE		<= '0';
					IR <= Q;
					if (Q = "00001") then -- MOV A, [END]
						-- preciso ler a proxima posiao de memoria [END]
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						MAR 	<= std_logic_vector(unsigned(MAR) + 1);
					elsif (Q = "00010") then -- MOV [END], A
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						MAR 	<= std_logic_vector(unsigned(MAR) + 1);
					elsif (Q = "00011") then -- MOV  A, B
						-- nao faz nada 
					elsif (Q = "00100") then -- MOV  B, A
						-- nao faz nada 
					elsif (Q = "00101") then -- ADD  A, B
						-- nao faz nada 
					elsif (Q = "00110") then -- SUB  A, B
						-- nao faz nada 
					elsif (Q = "00111") then -- AND  A, B
						-- nao faz nada 
					elsif (Q = "01000") then -- OR   A, B
						-- nao faz nada 
					elsif (Q = "01001") then -- XOR  A, B
					elsif (Q = "01010") then -- NOT  A
					elsif (Q = "01011") then -- NAND A, B
					elsif (Q = "01100") then -- JZ [END]
						-- preciso ler a proxima posiao de memoria [END]
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						MAR 	<= std_logic_vector(unsigned(MAR) + 1);
					elsif (Q = "01101") then -- JN [END]
						-- preciso ler a proxima posiao de memoria [END]
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						MAR 	<= std_logic_vector(unsigned(MAR) + 1);
					elsif (Q = "01110") then -- HALT
					elsif (Q = "01111") then -- JMP [END]
						-- preciso ler a proxima posiao de memoria [END]
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						MAR 	<= std_logic_vector(unsigned(MAR) + 1);
					elsif (Q = "10000") then -- INC A
					elsif (Q = "10001") then -- INC B
					elsif (Q = "10010") then -- DEC A
					elsif (Q = "10011") then -- DEC B
					end if;
					STATE <= decode;
					
				when decode =>
					START <= '0';
					if (IR = "00001") then
						-- iremos vizualizar o que esta no endereo END
						MAR  <= Q;
						--PC 	<= std_logic_vector(unsigned(PC) + 1);
					elsif (IR = "00010") then -- MOV [END], A
						MAR  	<= Q;
						DATA	<= reg_A;
						WE		<= '1';
					elsif (IR = "00011") then -- MOV  A, B
						-- nao faz nada 
					elsif (IR = "00100") then -- MOV  B, A
						-- nao faz nada 
					elsif (IR = "00101") then -- ADD  A, B
						-- ALU 
						ALU_ENABLE <= '1';
					elsif (IR = "00110") then -- SUB  A, B
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "00111") then -- AND  A, B
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "01000") then -- OR   A, B
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "01001") then -- XOR  A, B
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "01010") then -- NOT  A
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "01011") then -- NAND A, B
						-- ALU
						ALU_ENABLE <= '1';
					elsif (IR = "01100") then -- JZ [END] 
						-- ALU
						
					elsif (IR = "01101") then -- JN [END]
						-- ALU
						
					elsif (IR = "01110") then -- HALT
						
					elsif (IR = "01111") then -- JMP [END]
						
					elsif (IR = "10000") then -- INC A
						ALU_ENABLE <= '1';
					elsif (IR = "10001") then -- INC B
						ALU_ENABLE <= '1';
					elsif (IR = "10010") then -- DEC A
						ALU_ENABLE <= '1';
					elsif (IR = "10011") then -- DEC B
						ALU_ENABLE <= '1';
					end if;
					STATE <= execute;
					
				when execute	=>
				
					
					if (IR  = "00001") then -- MOV A, [END]
						-- iremos vizualizar o que esta no endereco END
						reg_A <= Q;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						state <= fetch; 
					elsif (IR  = "00010") then -- MOV [END], A
						WE		<= '0';
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						state <= fetch;
					elsif (IR  = "00011") then -- MOV  A, B
						reg_A	<= reg_B;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						state <= fetch;
					elsif (IR  = "00100") then -- MOV  B, A
						reg_B	<= reg_A;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						state <= fetch;
					elsif (IR  = "00101") then -- ADD  A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "00110") then -- SUB  A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "00111") then -- AND  A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01000") then -- OR   A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01001") then -- XOR  A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01010") then -- NOT  A
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01011") then -- NAND A, B
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01100") then -- JZ [END] 
						if(ALU_zero_reg = '1') then
							MAR	<= Q;
							PC 	<= Q;
						else
							MAR	<= std_logic_vector(unsigned(PC) + 1); -- alterar
							PC 	<= std_logic_vector(unsigned(PC) + 1);
						end if;
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01101") then -- JN [END]
						if(ALU_negative_reg = '1') then
							MAR	<= Q;
							PC 	<= Q;
						else
							MAR	<= std_logic_vector(unsigned(PC) + 1); -- alterar
							PC 	<= std_logic_vector(unsigned(PC) + 1);
						end if;
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "01110") then -- HALT
						if (reset = '1') then
							state <= hold;
						end if;
					elsif (IR  = "01111") then -- JMP [END]
						MAR	<= Q;
						PC 	<= Q;
						state <= fetch;
					elsif (IR  = "10000") then -- INC A
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "10001") then -- INC B
						reg_B	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "10010") then -- DEC A
						reg_A	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					elsif (IR  = "10011") then -- DEC B
						reg_B	<= ALU_out_reg;
						MAR	<= std_logic_vector(unsigned(PC) + 1);
						PC 	<= std_logic_vector(unsigned(PC) + 1);
						ALU_ENABLE <= '0';
						state <= fetch;
					else	
						state <= hold;
					end if;
					
				when others 	=>
					state <= hold;
			end case;
		end if;
	end process;
	
	ADDR <= STD_LOGIC_VECTOR(MAR);

end Behavioral;

