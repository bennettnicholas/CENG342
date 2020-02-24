library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenericFullAdderBench is
generic (n : positive := 2);
end GenericFullAdderBench;

architecture generic_arch_test of GenericFullAdderBench is
    COMPONENT OneBitFullAdder
    PORT(
            signal a, b, ci : IN STD_LOGIC;
            signal co, o: OUT std_logic);
     END COMPONENT;
     ---Input and Output Signals 
     signal Oc, Ic : STD_LOGIC;
     signal Ia : STD_LOGIC_VECTOR(n-1 downto 0);
     signal Ib : STD_LOGIC_VECTOR(n-1 downto 0);   
     signal Oo : STD_LOGIC_VECTOR(n-1 downto 0);
begin
    n_bit_adder : for n_bit in 0 to n - 1 generate
        signal oldinputcarry : STD_LOGIC := '1';
        signal newinputcarry : STD_LOGIC;
        begin
        single_bit_adder : component OneBitFullAdder
            port map(a => Ia(n_bit),
                     b => Ib(n_bit),
                     ci => oldinputcarry,
                     co => newinputcarry,
                     o => Oo(n_bit));
            oldinputcarry <= newinputcarry;
        end generate n_bit_adder;
        -- test vecotr
stim_proc: process 
    variable i: integer;
    variable j: integer;
    variable k: integer;
begin
        for i in 0 to 3 loop
            Ia <= std_logic_vector(to_unsigned(i, 2));
            for j in 0 to 3 loop
                Ib <= std_logic_vector(to_unsigned(j, 2));
                for k in 0 to 1 loop
                    Ic <= '0';
                    wait for 200ns;
                    Ic <= '1';
                    wait for 200ns;
                end loop;
            end loop;
        end loop;
end process; 
END;
