library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Generic_ALU is
generic( N_Bit: integer := 4);
 
port(
        A: IN UnSigned(N_Bit-1 downto 0);
        B: IN UnSigned(N_bit-1 downto 0);
        F: IN STD_LOGIC_VECTOR(3 downto 0); 
        Ci: IN UnSigned(0 downto 0);
        Co: OUT STD_LOGIC; -- carry out
        Z: OUT STD_LOGIC; -- zero result
        N: OUT STD_LOGIC; -- negative
        V: OUT STD_LOGIC; -- overflow
        R: OUT UnSigned(N_Bit-1 downto 0)
       -- Test: OUT UnSigned(N_Bit downto 0) 
     );
end Generic_ALU;

architecture cheating of Generic_ALU is
    -- must add 0's to this if you change the value
    signal Rout: UnSigned(N_Bit downto 0) := "00000"; -- Upper bits are used to house the carry over
    signal overflow: STD_LOGIC;
    signal Ax: UnSigned(N_Bit downto 0);
    signal Bx: UnSigned(N_Bit downto 0);
begin
   --Ax <= ( a(N_Bit-1) & a );
   --Bx <= ( b(N_Bit-1) & b );
   Ax <= ( '0' & a );
   Bx <= ( '0' & b ); 
    -- carry flags
    Co <= std_logic(Rout(N_Bit)) -- add
    when F = "0000" else 
    std_logic(Rout(N_Bit)) -- add with carry
    when F = "0010" else 
    std_logic(Rout(N_Bit)) -- subtract
    when F = "0100" else
    std_logic(Rout(N_Bit)) -- subtract with carry
    when F = "0110" else
    std_logic(Rout(N_Bit)) -- LSL 
    when F = "1010" else 
    std_logic(Rout(N_Bit)) -- LSR
    when F = "1100" else 
    std_logic(Rout(N_Bit))-- ASR
    when F = "1110" else
    '0'; -- otherwise nothing;
    
    -- negative
    N <= std_logic(Rout(N_Bit - 1));
    
    -- zero
    Z <= '1' when Rout(N_Bit - 1 downto 0) = "0" else '0';
     
    -- overflow
    overflow <= Rout(N_Bit-1) AND A(N_Bit -1); 
    V <= std_logic(Rout(N_Bit)) -- add
    when F = "0000" else 
    std_logic(Rout(N_Bit)) -- add with carry
    when F = "0010" else 
    std_logic(Rout(N_Bit)) -- subtract
    when F = "0100" else
    std_logic(Rout(N_Bit)) -- subtract with carry
    when F = "0110" else
    '1' -- LSL
    when ((F = "1010") AND (overflow = '0')) else
    '0'; -- otherwise nothing;
    
 -- selecting which function 
process(Ax,Bx,F,Ci)
    begin
    case F is
    when "0000" => Rout <= Ax + Bx; -- add 
    when "0010" => Rout <= Ax + Bx + ci; -- add with carry 
    when "0100" => Rout <= Ax + NOT(Bx) + 1; -- subtract
    when "0110" => Rout <= Ax + NOT(Bx) + 1 + Ci; -- subtract with carry
    when "1001" => Rout <= NOT(Bx); -- Not B
    when "1011" => Rout <= Ax AND Bx; -- A and B 
    when "1101" => Rout <= Ax OR Bx; -- A Or B 
    when "1111" => Rout <= Ax XOR Bx; -- A Xor B
    when "1000" => Rout <= Bx; --Pass thru 
    when "1010" => Rout <= shift_left(Ax, to_integer(Bx)); -- LSL  
    when "1100" => Rout <= shift_right(Ax, to_integer(Bx)); -- LSR 
    when "1110" => Rout <= rotate_right(Ax, to_integer(Bx));-- ASR
    when others => Rout <= (others => '0'); -- otherwise nothing;
    end case;
end process;
    -- Output of the fucntion inputed
   R <= Rout(N_Bit-1 downto 0);
   --Test <= Rout;
end cheating;