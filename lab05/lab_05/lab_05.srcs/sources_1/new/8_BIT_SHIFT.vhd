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
    signal ns, lsl, lsr, asrtemp, asr : STD_LOGIC_VECTOR(7 downto 0);
    signal temp : STD_LOGIC_VECTOR(23 downto 0) := "000000000000000000000000";
    signal Atemp : STD_LOGIC_VECTOR(23 downto 0) := "111111111111111111111111";
    signal sign : STD_LOGIC;
    begin
    --no shift (do nothing)
    temp(15 downto 8) <= din(7 downto 0);
    Atemp(15 downto 8) <= din(7 downto 0);
    ns <= din;
    --logical shift left
    lsr <= temp((15+to_integer(unsigned(shamt))) downto (8+to_integer(unsigned(shamt))));
    --logical shift right
    lsl <= temp((15-to_integer(unsigned(shamt))) downto (8-to_integer(unsigned(shamt))));
    --arithmitic shift right
    asrtemp <= Atemp((15+to_integer(unsigned(shamt))) downto (8+(to_integer(unsigned(shamt)))));
    asr <= asrtemp OR "10000000" when din(7) = '1' else
           asrtemp AND "01111111";
    
    dout <= ns  when func = "00" else
            lsl when func = "01" else
            lsr when func = "10" else
            asr;
    end struct_arch;    