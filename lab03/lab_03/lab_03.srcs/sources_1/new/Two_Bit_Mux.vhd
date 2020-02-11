library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Two_Bit_Mux is
generic(n: integer := 0);
port(
    i0, i1: IN std_logic_vector((n-1) downto 0);
    sel: IN std_logic;
    o: OUT std_logic_vector ((n-1) downto 0)
    );
end Two_Bit_Mux;

architecture struct of Two_Bit_Mux is
begin
p_mux : process(i0,i1,sel)
begin
  case sel is
    when '0' => o <= i0 ;
    when others => o <= i1 ;
  end case;
end process p_mux;
end struct;
