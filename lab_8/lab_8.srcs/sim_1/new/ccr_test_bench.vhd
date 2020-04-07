library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ccr_test_bench is
end ccr_test_bench;

architecture Behavioral of ccr_test_bench is
signal clk: std_logic := '0';
signal reset : std_logic := '1';
signal d : std_logic_vector(3 downto 0) := (others => '0');
signal q : std_logic_vector(3 downto 0) := (others => '0');

constant clk_period : time := 20ns;

BEGIN
    
    uut: entity work.ccr(lab) 
        PORT MAP(
        clk => clk,
        reset => reset,
        d => d,
        q => q
        );
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process
    begin
    reset <= '1' after 20ns;
    d <= "0001";
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    d <= "1000";
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    d <= "0110";
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    d <= "1001";
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait;
    end process;
END;
    