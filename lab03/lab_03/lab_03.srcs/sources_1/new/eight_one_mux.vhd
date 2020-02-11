library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Eight_Bit_Mux is
generic(n: integer := 0);
port(
    i0, i1, i2, i3, i4, i5, i6, i7: IN std_logic_vector((n-1) downto 0);
    sel: IN std_logic_vector(2 downto 0);
    o: OUT std_logic_vector ((n-1) downto 0)
    );
end Eight_Bit_Mux;

architecture struct of Eight_Bit_Mux is
begin
p_mux : process(i0, i1, i2, i3, i4, i5, i6, i7, sel)
begin
  case sel is
    when "000" => o <= i0 ;
    when "001" => o <= i1 ;
    when "010" => o <= i2 ;
    when "011" => o <= i3 ;
    when "100" => o <= i4 ;
    when "101" => o <= i5 ;
    when "110" => o <= i6 ;
    when others => o <= i7 ;
  end case;
end process p_mux;
end struct;
