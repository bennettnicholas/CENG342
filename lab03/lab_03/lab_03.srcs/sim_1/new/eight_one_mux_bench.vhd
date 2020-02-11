library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Eight_One_Mux_Bench is
end Eight_One_Mux_Bench;

architecture bench of Eight_One_Mux_Bench is
     constant num : integer := 3;
     ---Input and Output Signals 
     signal a, b, c, d, e, f, g, h: STD_LOGIC_VECTOR ((num-1) downto 0);
     signal selbit: std_logic_vector(2 downto 0);
     signal output: STD_LOGIC_VECTOR((num-1) downto 0);    
begin
        --- INstantiate UUT
        utt: entity work.Eight_Bit_Mux(struct)
        generic map(n=>num)
        PORT MAP(i0=>h, i1=>g, i2=>f, i3=>e, i4=>d, i5=>c, i6=>b, i7=>a,
                 sel=>selbit, o=>output);
        -- test vecotr
looped: process 
    variable numa: integer := 3;
    variable numb: integer := 5;
    variable numc: integer := 7;
    variable numd: integer := 0;
    variable nume: integer := 2;
    variable numf: integer := 4;
    variable numg: integer := 6;
    variable numh: integer := 1;
    variable i: integer;
begin
            a <= std_logic_vector(to_unsigned(numa, num));
            b <= std_logic_vector(to_unsigned(numb, num));
            c <= std_logic_vector(to_unsigned(numc, num));
            d <= std_logic_vector(to_unsigned(numd, num));
            e <= std_logic_vector(to_unsigned(nume, num));
            f <= std_logic_vector(to_unsigned(numf, num));
            g <= std_logic_vector(to_unsigned(numg, num));
            h <= std_logic_vector(to_unsigned(numh, num));
        for i in 0 to 7 loop
            selbit <= std_logic_vector(to_unsigned(i, 3));
            wait for 200ns;
        end loop;
end process; 
END;