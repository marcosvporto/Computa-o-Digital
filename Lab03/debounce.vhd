----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:39:44 04/06/2020 
-- Design Name: 
-- Module Name:    debounce - Behavioral 
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

entity debounce is
		generic(
					clk_freq    : natural := 50_000_000;  -- clock frequency in hz
					stable_time : natural := 1           -- time the signal must remain stable in ms
		);
		Port ( 	clk, reset 	: in  STD_LOGIC;
					sw 			: in  STD_LOGIC;
					db 			: out  STD_LOGIC;
					tick 			: out  STD_LOGIC
		);
end debounce;

architecture Behavioral of debounce is

	constant counter_width : natural := natural(ceil(log2(real(clk_freq * stable_time / 1000))));
    constant counter_limit : natural := natural((clk_freq * stable_time / 1000) - 1);

    signal counter         : unsigned(counter_width-1 downto 0) := (0 => '1', others => '0');
    constant counter_l     : unsigned(counter_width-1 downto 0) := to_unsigned(counter_limit, counter_width);

    signal dff             : std_logic_vector(1 downto 0) := (others => '1');
    signal counter_set     : std_logic := '0';
    signal result          : std_logic := '1';
    signal tick_reg        : std_logic_vector(1 downto 0) := (others => '0');

    -- tick
    type state_machine is (zero, one);
    signal state           : state_machine := one;

begin

	-- counter set/reset
    counter_set <= dff(0) xor dff(1);

    process(clk, reset)
    begin
        if reset = '1' then
            dff      <= (others => '1');
            counter  <= (others => '0');
            result   <= '0';
            tick_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            dff(0)      <= sw;
            dff(1)      <= dff(0);
            tick_reg(1) <= tick_reg(0);
            if (counter_set = '1') then
                counter     <= (0 => '1', others => '0'); -- 1 pois um clock foi perdido pelo FFD do counter_set
            elsif (counter < counter_l) then
                counter     <= counter + 1; -- unsigned + integer <-- definido em IEEE.NUMERIC_STD.ALL
            else
                result      <= dff(1); -- stable output
                tick_reg(0) <= dff(1);
            end if;
        end if;
    end process;
    
    db   <= result;
    tick <= tick_reg(0) and not(tick_reg(1));


end Behavioral;

