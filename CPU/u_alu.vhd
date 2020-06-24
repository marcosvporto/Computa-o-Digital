----------------------------------------------------------------------------------
-- Engineer: Breno Tartaroni & Marcos
-- Module Name:    alu - Behavioral 
-- Project Name: Trabalho Final - CompDig
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity alu is
	port(
		A,B 				: in  STD_LOGIC_VECTOR(4 downto 0); -- 2 entradas de 5bits
		OP					: in  STD_LOGIC_VECTOR(4 downto 0); -- Entrada para selecionar a operacao
		enable			: in std_logic; --habilita/desabilita as saidas da ALU
		ALU_Out  		: out  STD_LOGIC_VECTOR(4 downto 0); -- Saida resultado da operacao
		Carryout 		: out std_logic; -- indicador Carry
		Zero_flag		: out std_logic; --indicador 0
		negative_flag 	: out std_logic -- indicador negativo
	);
end alu;

architecture Behavioral of alu is

	signal ALU_Result 			: std_logic_vector (4 downto 0) 	:= (others => '0'); --Registrador resultado temporario
	signal tmp						: std_logic_vector (5 downto 0)	:= (others => '0');
	signal negative_flag_reg	: std_logic := '0'; --Registrador pro negative_flag

begin

	process(A,B,OP)
	begin
		case OP is
			when "00101" => --ADD A,B
				ALU_Result <= std_logic_vector(unsigned(A) + unsigned(B)) ;
				tmp <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
				Carryout <= tmp(5); -- Carryout flag
				negative_flag_reg <= '0';
				
			when "00110"=> --SUB A,B
				if B > A then --numero negativo
					negative_flag_reg <= '1'; 
				else 
					negative_flag_reg <= '0';
				end if;
				ALU_Result <= std_logic_vector(unsigned(A) - unsigned(B)) ;
				tmp <= std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
				Carryout <= tmp(5); -- Carryout flag
				
			when "00111"=> --AND A,B
				ALU_Result <= A and B;
				negative_flag_reg <= '0';
				
			when "01000"=> --OR A,B
				ALU_Result <= A or B;
				negative_flag_reg <= '0';
				
			when "01001"=> --XOR A,B
				ALU_Result <= A xor B;
				negative_flag_reg <= '0';
				
			when "01010"=> --NOT A
				ALU_Result <= not A;
				negative_flag_reg <= '0';
				
			when "01011"=> --NAND A,B
				ALU_Result <= A nand B;
				negative_flag_reg <= '0';
				
			when "10000"=> --INC A
				ALU_Result <= std_logic_vector(unsigned(A) + 1);
				negative_flag_reg <= '0';
				if (A="11111") then
					Carryout <= '1';
				end if;
								
			when "10001"=> --INC B
				ALU_Result <= std_logic_vector(unsigned(B) + 1);
				negative_flag_reg <= '0';
				if (A="11111") then
					Carryout <= '1';
				end if;
			
			when "10010"=> --DEC A
				if A="00000" then
					negative_flag_reg <= '1'; 
				else 
					negative_flag_reg <= '0';
				end if;
				ALU_Result <= std_logic_vector(unsigned(A) - 1);
				
			when "10011"=> --DEC B
				if B="00000" then
					negative_flag_reg <= '1'; 
				else 
					negative_flag_reg <= '0';
				end if;
				ALU_Result <= std_logic_vector(unsigned(B) - 1);
				
			when others =>
				NULL;
		end case;
	end process;
	
	process(A,B,ALU_Result,OP,enable)--So tem as saidas caso seja habilitado na CPU
	begin
		if(enable = '1') then
			ALU_Out <= ALU_Result; --Saida da ALU
			negative_flag <= negative_flag_reg; --saida da flag negativo
			if(ALU_Result = "00000")then --Teste e saida da flag zero
				zero_flag<='1';
			else
				zero_flag<='0';
			end if;
		end if;
	end process;	
end Behavioral;