library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

--slightly modifed code from register slides

entity ccr is
 port(
            d: in std_logic_vector(3 downto 0);
            q: out std_logic_vector (3 downto 0) := "0000";
            ci: out std_logic;
            --------- reset = CCRle
            clk, reset: in std_logic
        );

end ccr;

architecture lab of ccr is
    signal temp: std_logic_vector(3 downto 0);
begin
    process(clk, reset)
    begin
        if(reset='0') then
            ci <= '0';
            q <= "0010";
        elsif(clk'event and clk='1') then
            ci <= d(2);
            q <= d;
        end if;
    end process;    
end lab;