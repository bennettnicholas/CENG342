library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Testbench is
generic(N_Bit: integer := 8);
end ALU_Testbench;

architecture cheat_test of ALU_Testbench is
    signal A, B: UnSigned(N_Bit-1 downto 0);
    signal F: STD_LOGIC_VECTOR(3 downto 0);  
    signal Ci: STD_logic_vector(0 downto 0);
    signal Co, Z, N, V: STD_LOGIC;
    signal R: std_logic_vector(N_Bit-1 downto 0);
    --signal Test: UnSigned(N_Bit downto 0);
begin
    uut: entity work.Generic_ALU(cheating)
    generic map(N_Bit => N_Bit)
    port map(A => A, B => B, F => F, Ci => Ci, Co => Co, Z => Z, N => N, V => V, R => R);
looped : process
    -- use the names of the integers for 4bit
    variable sel_1: integer := 0; --use for 8bit
    variable sel_0: integer := 1; --< use for 8bit
    variable sel_6: integer := 126; --< use 126 for 8bit
    variable sel_7: integer := 127; --< use 127 for 8bit
    variable sel_15: integer := 255; --< use 255 for 8bit
    variable sel_14: integer := 127; --< use 127 for 8bit
begin
    -- add
    ci <= "0";
    F <= "0010";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    ci <= "1";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- sub
    ci <= "0";
    F <= "0110";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    ci <= "1";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- not 
    ci <= "0";
    F <= "1001";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- and
    F <= "1011";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- or
    F <= "1101";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- xor
    F <= "1101";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- pass
    F <= "1000";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- LSL
    F <= "1010";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    -- LSR
    F <= "1100";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_14,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
     -- ASR
    F <= "1110";
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);  
    wait for 100 ns;
    a <= to_unsigned(sel_6,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_7,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_1,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
    a <= to_unsigned(sel_15,N_Bit);
    b <= to_unsigned(sel_0,N_Bit);
    wait for 100 ns;
end process;
end cheat_test;
