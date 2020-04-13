library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BTU_test is
end BTU_test;

architecture Behavioral of BTU_test is
    signal N, Z, C, V: STD_LOGIC;
    signal Encoding: STD_LOGIC_VECTOR (3 downto 0);
    signal brout: STD_LOGIC;
        
begin
    UUT: entity work.BTU(sanity_check)
    port map ( N => N, Z => Z, C => C, V => V, 
               Encoding => Encoding, brout =>brout
             );  

    test: process 
        variable i: integer;
        begin
        for i in 0 to 255 loop   
            Encoding <= std_logic_vector(to_unsigned(i,8)(7 downto 4));
            N <= std_logic(to_unsigned(i,8)(3));
            Z <= std_logic(to_unsigned(i,8)(2));
            C <= std_logic(to_unsigned(i,8)(1));
            V <= std_logic(to_unsigned(i,8)(0));
            wait for 50 ns;
      end loop;
      end process;
end Behavioral;
