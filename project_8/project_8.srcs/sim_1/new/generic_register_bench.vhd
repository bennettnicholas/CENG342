library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity generic_register_bench is
    generic(Bits : integer := 8);
end generic_register_bench;

architecture Behavioral of generic_register_bench is
    signal din: std_logic_vector(Bits - 1 downto 0) := (others => '0');
    signal dout: std_logic_vector(Bits - 1 downto 0) := (others => '0');
    signal Enable : std_logic := '1';
    signal clk, reset : std_logic := '0';
begin
    UUT: entity work.generic_register(Behavioral)
        generic map(Bits => Bits)
        port map ( Enable => Enable, clk => clk, 
        reset => reset, din => din, dout => dout);
        
   --begin testing
  clk_pro: process 
   begin
    wait for 50ns;
    reset <= '1';
    wait for 50ns;
    clk <= not clk;
    wait for 50ns;
    clk <= not clk;
    wait for 50ns;
    end process;
    
    process
    variable i: integer;
    begin
        wait for 50ns;
            for I in 0 to 8 loop
                Enable <= '0';
                din <= std_logic_vector(to_unsigned(I,bits));
                wait for 50ns;
            end loop;
    end process;
end Behavioral;
