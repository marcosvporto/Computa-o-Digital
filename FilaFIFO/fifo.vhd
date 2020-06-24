----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:28:30 04/21/2020 
-- Design Name: 
-- Module Name:    fifo - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo is
		generic(
			DATA_WIDTH				: natural := 8;	-- data width in bits
			ADDR_WIDTH				: natural := 3;	-- address width in bits
			ALMOST_EMPTY_WIDTH	: natural := 2;	-- 2^ALMOST_EMPTY words left to raise flag
			ALMOST_FULL_WIDTH		: natural := 2  	-- 2^ALMOST_FULL  words free to raise flag
			
			
		);
    Port ( clk 			: in  	STD_LOGIC;
           reset 			: in  	STD_LOGIC;
			  rd_en			: in		STD_LOGIC;
			  wr_en			: in		STD_LOGIC;
           data_in 		: in  	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out 		: out  	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_count 	: out  	STD_LOGIC_VECTOR (ADDR_WIDTH downto 0);
           empty 			: out  	STD_LOGIC;
           full 			: out  	STD_LOGIC;
           almost_empty : out  	STD_LOGIC;
           almost_full 	: out  	STD_LOGIC;
           err 			: out  	STD_LOGIC
	);
end fifo;

architecture Behavioral of fifo is

	-- constants 
	constant C_ALMOST_FULL			: natural := natural (2**ALMOST_EMPTY_WIDTH);
	constant C_ALMOST_EMPTY			: natural := natural (2**ADDR_WIDTH - 2**ALMOST_FULL_WIDTH);

	-- memory
	type reg_t is array (0 to 2**ADDR_WIDTH - 1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal mem_array					: reg_t;
	
	-- pointers
	signal wr_ptr_reg, rd_ptr_reg		: unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');	
	signal wr_ptr_next, rd_ptr_next	: unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');

	-- registers
	signal data_count_reg				: unsigned(ADDR_WIDTH downto 0) := (others => '0');
	signal data_count_next				: unsigned(ADDR_WIDTH downto 0) := (others => '0');
	signal data_count_inc				: std_logic := '0';
	signal data_count_dec				: std_logic := '0';

	-- flip-flops
	signal full_reg, empty_reg			: std_logic := '0';
	signal full_next, empty_next		: std_logic := '0';
	signal almost_full_reg				: std_logic := '0'; 
	signal almost_empty_reg				: std_logic := '0';
	signal almost_full_next				: std_logic := '0';
	signal almost_empty_next			: std_logic := '0';


	
begin

	--update register's
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(reset = '1') then
				data_count_reg		<=(others => '0');
				wr_ptr_reg			<=(others => '0');
				rd_ptr_reg			<=(others => '0');
				full_reg				<= '0';
				empty_reg			<= '1';
				almost_full_reg	<= '0';
				almost_empty_reg	<= '1';
			else
				data_count_reg		<= data_count_next;
				wr_ptr_reg			<= wr_ptr_next;
				rd_ptr_reg			<= rd_ptr_next;
				full_reg				<= full_next;
				empty_reg			<= empty_next;
				almost_full_reg	<= almost_full_next;
				almost_empty_reg	<= almost_empty_next;	
			end if;
		end if;
	end process;
	
	
	
	-- almost full/empty
	process(data_count_reg, almost_full_reg, almost_empty_reg)
	begin
		-- check wr_ptr_reg and rd_ptr_reg
		if (data_count_reg > to_unsigned(C_ALMOST_FULL, data_count_reg'length)) then
			almost_full_next <= '1';
		else
			almost_full_next <= '0';
		end if;
		
		if (data_count_reg < to_unsigned(C_ALMOST_EMPTY, data_count_reg'length)) then
			almost_empty_next <= '1';
		else
			almost_empty_next <= '0';
		end if;
		
	end process;
		-- control red/write pointers and empty/full flip flops
		process(wr_en, rd_en, wr_ptr_reg, rd_ptr_reg, full_reg, empty_reg)
		begin
			-- if there are no changes
			wr_ptr_next		<= wr_ptr_reg;
			rd_ptr_next		<= rd_ptr_reg;
			full_next		<= full_reg;
			empty_next		<= empty_reg;
			data_count_inc	<= '0';
			data_count_dec	<= '0';
			-- only write, check if full after wr_ptr_reg increment
			if (wr_en = '1' and rd_en = '0') then
				if (full_reg = '0') then
					wr_ptr_next 	<= wr_ptr_reg + 1;
					data_count_inc <= '1';

					if ((wr_ptr_reg+1) = rd_ptr_reg) then
						full_next <= '1';
					else
						full_next <= '0';
					end if;
					
					if (empty_reg = '1') then
						empty_next <= '0';
					end if;
				end if;
			end if;
			
			-- only read, check if empty after rd_ptr_reg increment
			if (wr_en = '0' and rd_en = '1') then
				if (empty_reg = '0') then
					rd_ptr_next 	<= rd_ptr_reg + 1;
					data_count_dec <= '1';
					
					if ((rd_ptr_reg + 1) = wr_ptr_reg) then
						empty_next <= '1';
					else
						empty_next <= '0';
					end if;
				end if;
			end if;
			
			if (wr_en = '1' and rd_en = '1') then
				wr_ptr_next <= wr_ptr_reg + 1;
				rd_ptr_next <= rd_ptr_reg + 1;
			end if;
		end process;
		
		
		-- counter
		data_count_next <= 	data_count_reg + 1 when data_count_inc = '1' else
									data_count_reg - 1 when data_count_dec = '1' else
									data_count_reg;
									
									
		--write/ read process
		process(clk)
		begin
			if (clk'event and clk = '1') then
					if (reset = '1') then
						mem_array 	<= (others => (others => '0'));
						err			<= '0';
					else
						-- check for wr_en andd full_reg
						if (wr_en = '1' and full_reg = '0') then
							mem_array(to_integer(unsigned(wr_ptr_reg))) 	<= data_in;
							err														<= '0';
						elsif (wr_en = '1' and full_reg = '1') then
							err <= '1'; --full + trying to write
						end if;
						
						
						-- check for rd_en and empty_reg
						if (rd_en = '1' and empty_reg = '0') then
							data_out <= mem_array(to_integer(unsigned(rd_ptr_reg)));
							err		<= '0';
						elsif (rd_en = '1' and empty_reg = '1') then
							err	<= '1'; -- empty + trying to read
						end if;
					end if;
			end if;
		end process;
		
		-- outputs
		data_count 	<= std_logic_vector(data_count_reg);
		full			<= full_reg;
		empty			<= empty_reg;
		almost_full	<= almost_full_reg;
		almost_empty<= almost_empty_reg;
		
	
	
end Behavioral;

