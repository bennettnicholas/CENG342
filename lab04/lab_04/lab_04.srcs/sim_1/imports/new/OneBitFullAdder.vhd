library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity OneBitFullAdder is
    port(  ci   : IN STD_LOGIC;
           a    : IN STD_LOGIC;
           b    : IN STD_LOGIC;
           o    : OUT STD_LOGIC;
           co   : OUT STD_LOGIC);
end OneBitFullAdder;

architecture sop_arch of OneBitFullAdder is
    begin
    co <= ((a and b) or (b and ci) or (a and ci));
    o <= ((not (a) and not(b) and ci) or (not(a) and b and not(ci))
            or (a and b and ci) or (a and not(b) and not(ci)));
end sop_arch;
    
    