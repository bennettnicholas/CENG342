library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CCR_test is
end CCR_test;

architecture bench of CCR_test is
constant Bits: integer := 4;
    signal input: std_logic_vector(Bits - 1 downto 0) := (others => '0'); 
    signal output: std_logic_vector(Bits - 1 downto 0); 
    signal Enable: std_logic; 
    signal clk: std_logic; 
    signal reset: std_logic; 
    signal data: natural := 0;
begin
    CCR: entity work.CCR(arch)
    port map(
            input => input,
            output => output,
            Enable => Enable,
            clk => clk,
            reset => reset);
    
    -- run clock
    test_clk: process 
    begin 
        clk <= '1';
        wait for 5 ns;
        clk <= not(clk);
        loop 
            wait for 10 ns;
            clk <= not(clk);
        end loop;
    end process;
    
    -- everything else 
    test: process 
    begin
    -- clear
    reset <= '1';
    Enable <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 15 ns;
    reset <= '1';
    
    loop 
        -- write 
        Enable <= '0';
        input <= std_logic_vector(to_unsigned(data,Bits));
        data <= data + 1;
        wait for 20 ns;
        
        -- try to write data to the register file 
        Enable <= '1';
        input <= std_logic_vector(to_unsigned(data,Bits));
        data <= data + 1;
        wait for 20 ns;
   end loop;
   end process test;
end bench;