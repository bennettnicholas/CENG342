library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OneBitFullAdderBench is
end OneBitFullAdderBench;

architecture sop_arch_test of OneBitFullAdderBench is
    COMPONENT OneBitFullAdder
    PORT(
            signal a, b, ci : IN STD_LOGIC;
            signal co, o: OUT std_logic);
     END COMPONENT;
     ---Input and Output Signals 
     signal Oc, Oo: STD_LOGIC;
     signal Input : STD_LOGIC_VECTOR(2 downto 0);     
begin
        --- INstantiate UUT
        utt: OneBitFullAdder PORT MAP(
                                      a => Input(0),
                                      b => Input(1),
                                      ci => Input(2),
                                      co => Oc,
                                      o => Oo);
        -- test vecotr
stim_proc: process 
    variable i: integer;
begin
        for i in 0 to 7 loop
            Input <= std_logic_vector(to_unsigned(i, 3));
            wait for 200ns;
        end loop;
end process; 
END;
