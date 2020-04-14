library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity decoder_test is
end decoder_test;

architecture bench of decoder_test is

constant Bits: integer := 3;
signal Enable: std_logic;
signal sel: std_logic_vector(Bits-1 downto 0);
signal output: std_logic_vector(2**Bits-1 downto 0);
signal data: unsigned(Bits downto 0) := (others => '0');
    
begin
    uut: entity work.decoder(Behavioral)
    generic map( Bits => Bits)
    port map (Enable => Enable, sel => sel, output =>output);
    
    process 
    begin 
        loop
            wait for 10 ns;
            data <= data + 1;
        end loop;
    end process;
    
    sel <= std_logic_vector(data(Bits downto 1));
    Enable <= data(0);

end bench;
