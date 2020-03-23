library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Testbench is
generic(N_Bit: integer := 4);
end ALU_Testbench;

architecture cheat_test of ALU_Testbench is
    signal A, B: Signed(N_Bit-1 downto 0);
    signal F: STD_LOGIC_VECTOR(3 downto 0);  
    signal Ci: Signed(0 downto 0);
    signal Co, Z, N, V: STD_LOGIC;
    signal R: Signed(N_Bit-1 downto 0);
begin
    uut: entity work.Generic_ALU(cheating)
    port map(A => A, B => B, F => F, Ci => Ci, Co => Co, Z => Z, N => N, V => V, R => R);
looped : process
    variable num_a: integer := 1;
    variable num_b: integer := 1;
begin
    ci <= "0";
    F <= "0000";
    A <= to_signed(num_a, 4);
    --for i in 0 to 7 loop
        B <= to_signed(num_b, 4);
        wait for 100 ns;
   -- end loop;
end process;
end cheat_test;
