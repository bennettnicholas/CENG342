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
                    x => i0(0),
                    y => i0(1),
                    w => i0(2),
                    z => i0(3),
                    led_select => led_out
                    );
        -- test vecotr
stim_proc: process 
begin
        for i in 0 to 15 loop
            i0 <= std_logic_vector(to_unsigned(I, 4));
            wait for 200ns;
        end loop;
end process; 
END;
