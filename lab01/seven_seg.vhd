library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_seg is
port(
       x: IN STD_LOGIC;
       y: IN STD_LOGIC;
       w: IN STD_LOGIC;
       z: IN STD_LOGIC;
       led_select: OUT STD_LOGIC_VECTOR(6 downto 0)
     );
end seven_seg;

architecture sop_arch of seven_seg is
    signal p0, p1, p2, p3, p4, p5, p6: STD_LOGIC;
begin
        -- sum of product terms
        led_select(0) <= p0;
        led_select(1) <= p1;
        led_select(2) <= p2;
        led_select(3) <= p3;
        led_select(4) <= p4;
        led_select(5) <= p5;
        led_select(6) <= p6;
        -- product terms
        p0 <= NOT((NOT(y) AND NOT(z)) OR (NOT(x) AND w) OR (y AND w) OR (x AND NOT(z)) OR (x AND NOT(y) AND NOT(w)) OR (NOT(x) AND y AND z));
        p1 <= NOT((y AND NOT(z)) OR (NOT(x) AND NOT(y)) OR (NOT(x) AND w AND z) OR (NOT(x) AND NOT(w) AND NOT(z)) OR (x AND NOT(W) AND z));
        p2 <= NOT((NOT(w) AND z) OR (x AND NOT(y)) OR (NOT(x) AND y) OR (NOT(x) AND NOT(w)) OR (NOT(x) AND z));
        p3 <= NOT((NOT(y) AND w) OR (NOT(y) AND NOT(z)) OR (NOT(w) AND x) OR (w AND NOT(z)) OR (y AND NOT(w) AND z));
        p4 <= NOT((NOT(y) AND NOT(z)) OR (w AND NOT(z)) OR (x AND y) OR (x AND w));
        p5 <= NOT((NOT(w) AND NOT(z)) OR (NOT(w) AND NOT(x) AND y) OR (NOT(z) AND y) OR (x AND w AND z) OR (x AND NOT(y) AND z));
        p6 <= NOT((x AND NOT(y)) OR  (w AND NOT(z)) OR (x AND z) OR (NOT(x) AND y AND NOT(w)) OR (NOT(y) AND w));
        
end sop_arch;
