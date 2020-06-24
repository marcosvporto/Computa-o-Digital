
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
USE ieee.numeric_std.ALL;
 
ENTITY ps2_keyb_tb IS
END ps2_keyb_tb;
 
ARCHITECTURE behavior OF ps2_keyb_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ps2_keyb
    PORT(
         clk : IN  std_logic;
         ps2_clk : IN  std_logic;
         ps2_data : IN  std_logic;
         sseg : OUT  std_logic_vector(6 downto 0);
         an : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ps2_clk : std_logic := '1';
   signal ps2_data : std_logic := '1';

 	--Outputs
   signal sseg : std_logic_vector(6 downto 0);
   signal an : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant full_period9600 : time := 104166700 ps;
   constant half_period9600 : time :=  52083350 ps;
	
	signal word : std_logic_vector(7 downto 0) := (others => '0');
   signal txing : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ps2_keyb PORT MAP (
          clk => clk,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          sseg => sseg,
          an => an
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
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		
		wait for full_period9600;
        
        -- letra A
        word <= x"1C";
        txing <= '1';
        wait for clk_period;
        txing <= '0';
        
        -- tempo para atualizar os dois dígitos do 7-seg
        wait for 40 ms;

        -- letra K
        word <= x"42";
        txing <= '1';
        wait for clk_period;
        txing <= '0';

      -- insert stimulus here 

      wait;
   end process;
	
	tx_proc : process
        variable message : std_logic_vector(10 downto 0); -- [stop bit, parity, b7 .. b0, start bit]
    begin
        if (txing = '1') then
            message := "10" & word & '0';
            for i in 0 to 10 loop
                ps2_data <= message(0);
                message := '1' & message(10 downto 1);
                wait for half_period9600;
                ps2_clk <= '0';
                wait for half_period9600;
                ps2_clk <= '1';
            end loop;
        end if;
        wait for clk_period;
    end process;

END;
