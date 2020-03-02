Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity eight_test is
end eight_test;

architecture test_arch of eight_test is
    signal Tdin   :  STD_LOGIC_VECTOR(7 downto 0);
    signal Tdout  :  STD_LOGIC_VECTOR(7 downto 0);
    signal Tfunc  :  STD_LOGIC_VECTOR(1 downto 0);
    signal Tshamt :  STD_LOGIC_VECTOR(2 downto 0);
    signal Tco    :  STD_LOGIC;
begin
        --- INstantiate UUT
        utt: entity work.shifter_8bit(struct_arch)
        PORT MAP(din => Tdin, dout => Tdout, func => Tfunc,
                 shamt => Tshamt, co => Tco);
        -- test vecotr
looped: process 
    variable numa: integer := -5;
    variable i: integer;
begin
        --PASS THROUGH
        Tfunc <= "00";
        Tdin <= std_logic_vector(to_signed(numa, 8));
        for i in 0 to 7 loop
            Tshamt <= std_logic_vector(to_unsigned(i, 3));
            wait for 100ns;
        end loop;
        --LSL
        Tfunc <= "01";
        Tdin <= std_logic_vector(to_signed(numa, 8));
        for i in 0 to 7 loop
            Tshamt <= std_logic_vector(to_unsigned(i, 3));
            wait for 100ns;
        end loop;
        --LSR
        Tfunc <= "10";
        Tdin <= std_logic_vector(to_signed(numa, 8));
        for i in 0 to 7 loop
            Tshamt <= std_logic_vector(to_unsigned(i, 3));
            wait for 100ns;
        end loop;
        --ASR
        Tfunc <= "11";
        Tdin <= std_logic_vector(to_signed(numa, 8));
        for i in 0 to 7 loop
            Tshamt <= std_logic_vector(to_unsigned(i, 3));
            wait for 100ns;
        end loop;
end process; 
END;