library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity shifter_8bit is
    port( din   :   in  STD_LOGIC_VECTOR(7 downto 0);
          dout  :   out STD_LOGIC_VECTOR(7 downto 0);
          shamt :   in  STD_LOGIC_VECTOR(2 downto 0);
          func  :   in  STD_LOGIC_VECTOR(1 downto 0);
          co    :   out STD_LOGIC);
end shifter_8bit;

architecture struct_arch of shifter_8bit is
    signal ns, lsl, lsr, asr : STD_LOGIC_VECTOR(7 downto 0);
    signal temp : STD_LOGIC_VECTOR(23 downto 0);
    signal sign : STD_LOGIC;
    begin
    --no shift (do nothing)
    temp(15 downto 8) <= din(7 downto 0);
    ns <= din;
    --logical shift left
    lsl(7 downto 0) <= temp((15+to_integer(unsigned(shamt))) downto (8+to_integer(unsigned(shamt))));
    --logical shift right
    lsr(7 downto 0) <= temp((15-to_integer(unsigned(shamt))) downto (8-to_integer(unsigned(shamt))));
    temp(8-to_integer(unsigned(shamt))) <= '1' when temp(8) = '1';
    --arithmitic shift right
    asr(7 downto 0) <= temp((15-to_integer(unsigned(shamt))) downto (8-to_integer(unsigned(shamt))));
    
    dout <= ns  when func = "00" else
            lsl when func = "01" else
            lsr when func = "10" else
            asr;
    end struct_arch;    