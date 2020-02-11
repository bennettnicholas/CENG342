library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Two_One_Mux_Bench is
end Two_One_Mux_Bench;

architecture bench of Two_One_Mux_Bench is
     constant num : integer := 2;
     ---Input and Output Signals 
     signal a, b: STD_LOGIC_VECTOR ((num-1) downto 0);
     signal selbit: std_logic;
     signal output: STD_LOGIC_VECTOR((num-1) downto 0);    
begin
        --- INstantiate UUT
        utt: entity work.Two_Bit_Mux(struct)
        generic map(n=>num)
        PORT MAP(i0=>b, i1=>a, sel=>selbit, o=>output);
        -- test vecotr
looped: process 
    variable numa: integer := 1;
    variable numb: integer := 2;
begin
        for i in 0 to 1 loop
            a <= std_logic_vector(to_unsigned(numa, num));
            b <= std_logic_vector(to_unsigned(numb, num));
            selbit <= '0';
            wait for 200ns;
            selbit <= '1';
            wait for 200ns;
        end loop;
end process; 
END;


