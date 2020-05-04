library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Generic_ALU is
generic( N_Bit: integer := 4);
 
port(
        A: IN UnSigned(N_Bit-1 downto 0);
        B: IN UnSigned(N_bit-1 downto 0);
        F: IN STD_LOGIC_VECTOR(3 downto 0); 
        Ci: IN std_logic_vector(0 downto 0);
        Co: OUT STD_LOGIC; -- carry out
        Z: OUT STD_LOGIC; -- zero result
        N: OUT STD_LOGIC; -- negative
        V: OUT STD_LOGIC; -- overflow
        R: OUT std_logic_vector(N_Bit-1 downto 0)
       -- Test: OUT UnSigned(N_Bit downto 0) 
     );
end Generic_ALU;

architecture cheating of Generic_ALU is
    -- must add 0's to this if you change the value
    signal Rout: UnSigned(N_Bit downto 0) := (others => '0'); -- Upper bits are used to house the carry over
    signal overflow: STD_LOGIC;
    signal Ax: UnSigned(N_Bit downto 0);
    signal Bx: UnSigned(N_Bit downto 0);
begin
  -- Ax <= ( a(N_Bit-1) & a );
  -- Bx <= ( b(N_Bit-1) & b );
   Ax <= ( '0' & a );
   Bx <= ( '0' & b ); 
    -- carry flags
    Co <= std_logic(Rout(N_Bit));
    
    -- negative
    N <= std_logic(Rout(N_Bit - 1));
    
    -- zero
    Z <= '1' when Rout(N_Bit - 1 downto 0) = "0" else '0';
     
    -- overflow
    V <= Rout(N_Bit-1) XOR Rout(N_Bit); 
    
 -- selecting which function 
process(Ax,Bx,F,Ci)
    begin
    case F is
    when "0000" => Rout <= Ax + Bx; -- add 
    when "0010" => Rout <= Ax + Bx + unsigned(ci); -- add with carry 
    when "0100" => Rout <= Ax + NOT(Bx) + 1; -- subtract
    when "0110" => Rout <= Ax + NOT(Bx) + 1 + unsigned(Ci); -- subtract with carry
    when "1001" => Rout <= NOT(Bx); -- Not B
    when "1011" => Rout <= Ax AND Bx; -- A and B 
    when "1101" => Rout <= Ax OR Bx; -- A Or B 
    when "1111" => Rout <= Ax XOR Bx; -- A Xor B
    when "1000" => Rout <= Bx; --Pass thru 
    when "1010" => Rout <= shift_left(Ax, to_integer(Bx)); -- LSL  
    when "1100" => Rout <= shift_right(Ax, to_integer(Bx)); -- LSR 
    when "1110" => Rout <= shift_right(Ax, to_integer(signed(Bx)));-- ASR
    when others => Rout <= (others => '0'); -- otherwise nothing;
    end case;
end process;
    -- Output of the fucntion inputed
   R <= std_logic_vector(Rout(N_Bit-1 downto 0));
   --Test <= Rout;
end cheating;