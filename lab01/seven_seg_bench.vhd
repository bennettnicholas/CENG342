library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_bench is
end seven_seg_bench;

architecture lab_zero_one_test of seven_seg_bench is
    COMPONENT seven_seg
    PORT(
            signal x, y, w, z: std_logic;
            signal led_select: OUT std_logic_vector(6 downto 0)
         );
     END COMPONENT;
     ---Input and Output Signals 
     signal i0: STD_LOGIC_VECTOR (3 downto 0);
     signal led_out: STD_LOGIC_VECTOR(6 downto 0);
     
begin
        --- INstantiate UUT
        utt: seven_seg PORT MAP(
                    x => i0(3),
                    y => i0(2),
                    w => i0(1),
                    z => i0(0),
                    led_select => led_out
                    );
        -- test vecotr
stim_proc: process 
    variable i: integer;
begin
        for i in 0 to 15 loop
            i0 <= std_logic_vector(to_unsigned(I, 4));
            wait for 200ns;
        end loop;
end process; 
END;

architecture router_test of seven_seg_bench is
    signal inselct: std_logic_vector(3 downto 0);
    signal outselct: std_logic_vector(6 downto 0) :="0000000";
begin 
    uut: entity work.Hex_To_Segg(routed)
    port map(input=>inselct,output =>outselct);
looped: process
    variable j: integer;

begin
    for j in 0 to 15 loop
        inselct <= std_logic_vector(to_unsigned(j, 4));
        wait for 200ns;
    end loop; 
end process;
END;
