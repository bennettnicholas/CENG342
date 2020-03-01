library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_bit_adder is
    generic( n: integer := 4);
    PORT( cin: IN std_logic;
          a, b : IN STD_LOGIC_VECTOR(n-1 downto 0);
          sum: OUT STD_LOGIC_VECTOR(n-1 downto 0);
          cout: OUT STD_LOGIC
          );
end N_bit_adder;

architecture ripple_adder of N_bit_adder is
--    component OneBitFullAdder
--        PORT(ci,a,b :IN STD_LOGIC; o,co : OUT STD_LOGIC);
--    end component; 
    SIGNAL  t:  STD_LOGIC_VECTOR(n downto 0);
    begin
    t(0) <= cin; 
    cout <= t(n);
    adds: for i in 0 to n-1 generate
        adds_i: entity work.OneBitFullAdder(sop_arch) 
                PORT MAP(ci=>t(i), a=>a(i), b=>b(i),o=>sum(i), co=>t(i+1));
    end generate adds; 
end ripple_adder;

architecture add_sub of N_bit_adder is
--    component OneBitFullAdder
--        PORT(ci,a,b :IN STD_LOGIC; o,co : OUT STD_LOGIC);
--    end component;
    SIGNAL  t:  STD_LOGIC_VECTOR(n downto 0);
    begin
    t(0) <= cin;
    cout <= t(n);
    adds: for i in 0 to n-1 generate
        adds_i: entity work.OneBitFullAdder(sop_arch)
                PORT MAP(ci=>t(i), a=>a(i), b=>(b(i) XOR t(0)),o=>sum(i), co=>t(i+1));
    end generate adds;
end add_sub;