library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hex_To_Segg is
port(
    input: IN std_logic_vector(3 downto 0);
    output: OUT std_logic_vector (6 downto 0)
    );
end Hex_To_Segg;

architecture routed of Hex_To_Segg is
begin
    with input select
    output(6 downto 0) <=
    "0000001" when "0000",
    "1001111" when "0001",
    "0010010" when "0010",
    "0000110" when "0011",
    "1001100" when "0100",
    "0100100" when "0101",
    "0100000" when "0110",
    "0001111" when "0111",
    "0000000" when "1000",
    "0000100" when "1001",
    "0001000" when "1010", --a
    "1100000" when "1011", --b
    "0110001" when "1100", --c
    "1000010" when "1101", --d
    "0110000" when "1110", --e
    "0111000" when others; --f
end routed;
