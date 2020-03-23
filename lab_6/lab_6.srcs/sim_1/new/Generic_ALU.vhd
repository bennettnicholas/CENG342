library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Generic_ALU is
generic( N_Bit: integer := 4);
 
port(
        A: IN Signed(N_Bit-1 downto 0);
        B: IN Signed(N_bit-1 downto 0);
        F: IN STD_LOGIC_VECTOR(3 downto 0); 
        Ci: IN Signed(0 downto 0);
        Co: OUT STD_LOGIC; -- carry out
        Z: OUT STD_LOGIC; -- zero result
        N: OUT STD_LOGIC; -- negative
        V: OUT STD_LOGIC; -- overflow
        R: OUT Signed(N_Bit-1 downto 0) 
     );
end Generic_ALU;

architecture cheating of Generic_ALU is
    --signal shamt: signed((2**N_Bit - 1) downto 0);
    signal Rout: signed(N_Bit downto 0) := "00000"; -- Upper bits are used to house the carry over
    signal overflow: STD_LOGIC;
    -- signal num_a, num_b: signed(N_Bit-1 downto 0);
   -- signal c: signed(0 downto 0);
begin
    --to shift, since just sending B stragiht in was not working
    --shamt <= B;
    --num_a <= A;
    --num_b <= B;
    --c <= Ci;
    
    
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
    V <= std_logic(Rout(N_Bit-1)) -- add
    when F = "0000" else 
    std_logic(Rout(N_Bit-1)) -- add with carry
    when F = "0010" else 
    std_logic(Rout(N_Bit-1)) -- subtract
    when F = "0100" else
    std_logic(Rout(N_Bit-1)) -- subtract with carry
    when F = "0110" else
    '1' -- LSL
    when ((F = "1010") AND (overflow = '0')) else
    '0'; -- otherwise nothing;
 -- selecting which function 
process(A,B,F)
    begin
    case F is
    when "0000" => Rout <= a + b; -- add 
    when "0010" => Rout <= a + b + ci; -- add with carry 
    when "0100" => Rout <= a + NOT(b) + 1; -- subtract
    when "0110" => Rout <= a + NOT(b) + 1 + Ci; -- subtract with carry
    when "1001" => Rout <= NOT(b); -- Not B
    when "1011" => Rout <= a AND b; -- A and B 
    when "1101" => Rout <= a OR b; -- A Or B 
    when "1111" => Rout <= a XOR b; -- A Xor B
    when "1000" => Rout(N_Bit - 1 downto 0) <= b; --Pass thru 
    when "1010" => Rout <= shift_left(a, to_integer(b)); -- LSL  
    when "1100" => Rout <= shift_right(a, to_integer(b)); -- LSR 
    when "1110" => Rout <= rotate_right(a, to_integer(b));-- ASR
    when others => -- otherwise nothing;
    end case;
end process;
    -- Output of the fucntion inputed
   R <= Rout(N_Bit-1 downto 0);
end cheating;