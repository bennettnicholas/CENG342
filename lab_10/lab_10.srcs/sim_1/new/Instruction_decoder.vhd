library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.instructions.ALL;

entity instruction_decoder is
port(
        I : in std_logic_vector(15 downto 0); -- instruction to decode
        T : out instruction_t; -- instruction type
        Flags: in std_logic_vector(3 downto 0);
        imm: out std_logic_vector(31 downto 0); -- immediate data field
        Asel: out std_logic_vector(2 downto 0); -- select for register A
        Bsel: out std_logic_vector(2 downto 0); -- select for register B
        Dsel: out std_logic_vector(2 downto 0); -- select for register D
        ALUfunc: out std_logic_vector(3 downto 0); -- function for ALU
        control: out control_t_array -- Mux and register enable signals
    );
 end instruction_decoder;

architecture arch of instruction_decoder is
    constant zero_vec: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal line_T: instruction_t;  
    signal take_branch: std_logic; -- input from BTU  
begin

    -- BTU 
    BTU: entity work.BTU(sanity_check)
    port map (N => Flags(0), 
              Z => Flags(1), 
              C => Flags(2), 
              V => Flags(3),
              Encoding => I(10 downto 7),
              brout => take_branch
              );
            
    -- Asel
    Asel <= I(2 downto 0) when line_T = CMPR else 
            I(2 downto 0) when line_T = CMPI else
            I(2 downto 0) when line_T = RR else
            I(5 downto 3) when line_T = RRR else
            I(2 downto 0) when line_T = RI else
            I(5 downto 3) when line_T = RRI else
            I(5 downto 3) when line_T = LOAD else
            I(5 downto 3) when line_T = STORE else
            I(2 downto 0) when line_T = BR else
            "111" when line_T = PCRL else --this was a mistake as it makes it harder from reading the table
            "111" when line_T = BPCR else
            "111" when line_T = HCF else
            "111"; -- just in case they add something  
            
    -- Bsel
    Bsel <= I(5 downto 3) when line_T = CMPR else 
            "111" when line_T = CMPI else --this was a mistake as it makes it harder from reading the table
            I(5 downto 3) when line_T = RR else
            I(8 downto 6) when line_T = RRR else
            "111" when line_T = RI else
            "111" when line_T = RRI else
            "111" when line_T = PCRL else
            "111" when line_T = LOAD else
            I(2 downto 0) when line_T = STORE else
            "111" when line_T = BR else
            "111" when line_T = BPCR else
            "111" when line_T = HCF else
            "111"; -- just in case they add something 
  
    -- Dsel 
        Dsel <= "111" when line_T = CMPR else 
            "111" when line_T = CMPI else
            I(2 downto 0) when line_T = RR else
            I(2 downto 0) when line_T = RRR else
            I(2 downto 0) when line_T = RI else
            I(2 downto 0) when line_T = RRI else
            I(2 downto 0) when line_T = PCRL else
            I(2 downto 0) when line_T = LOAD else
            "111" when line_T = STORE else
            "111" when line_T = BR else
            "111" when line_T = BPCR else
            "111" when line_T = HCF else
            "111"; -- just in case they add something
            
    -- IMM
    IMM <= (others=>'1') when line_T = CMPR else 
            zero_vec(24 downto 0) & I(12 downto 11) & I(7 downto 3) when line_T = CMPI else
            (others=>'1') when line_T = RR else
            (others=>'1') when line_T = RRR else
            zero_vec(23 downto 0) & I(10 downto 3) when line_T = RI else
            zero_vec(26 downto 0) & I(10 downto 6) when line_T = RRI else
            zero_vec(22 downto 0) & I(13 downto 6) & '0' when line_T = PCRL else
            zero_vec(25 downto 0) & I(13 downto 8) when line_T = LOAD AND I(7 downto 6) = "00" else
            zero_vec(24 downto 0) & I(13 downto 8) & '0' when line_T = LOAD AND I(7 downto 6) = "01" else
            zero_vec(23 downto 0) & I(13 downto 8) & "00" when line_T = LOAD AND I(7 downto 6) = "10" else
            zero_vec(25 downto 0) & I(13 downto 8) when line_T = STORE AND I(7 downto 6) = "00" else
            zero_vec(24 downto 0) & I(13 downto 8) & '0' when line_T = STORE AND I(7 downto 6) = "01" else
            zero_vec(23 downto 0) & I(13 downto 8) & "00" when line_T = STORE AND I(7 downto 6) = "10" else
            (others=>'0')  when line_T = BR else
            zero_vec(23 downto 0) & I(6 downto 0) & '0' when line_T = BPCR else
            (others=>'1') when line_T = HCF else
            (others=>'1');
            
    -- ALUfunc
    ALUfunc <= "0100" when line_T = CMPR else 
            "0100" when line_T = CMPI else --this was a mistake as it makes it harder from reading the table
            '1' & I(12 downto 11) & NOT(I(12) OR I(11)) when line_T = RR AND I(7 downto 6) = "00" else
            (I(9) & I(12 downto 11) & I(9)) when line_T = RRR else
            '1' & I(12 downto 11) & (I(12) OR I(11)) when line_T = RI else
            (I(12) OR I(11)) & I(12 downto 11) & '0' when line_T = RRI else
            "0000" when line_T = PCRL else
            "0000" when line_T = LOAD else
            "0000" when line_T = STORE else
            "0000" when line_T = BR else
            "0000" when line_T = BPCR else
            "1111" when line_T = HCF else
            "1111"; -- just in case they add something 
   --Irle
   control(Irle) <= '0'; -- ask pyeatt what to do with this 
            
    -- DIsel
    control(DIsel) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '1' when line_T = STORE else
            '0' when line_T = BR else
            '0' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- Dlen
    control(Dlen) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '1' when line_T = STORE else
            NOT(take_branch) OR I(11) when line_T = BR else
            NOT(take_branch) OR I(11) when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- PCAsel
    control(PCAsel) <= '0' when line_T = CMPR else 
            '0' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD AND I(5 downto 3) = "111" else
            '0' when line_T = STORE else
            '0' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- PCle
    control(PCle) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '1' when line_T = STORE else
            NOT(take_branch) when line_T = BR else
            NOT(take_branch)when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- PCie
    control(PCie) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '1' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- PCDsel
    control(PCDsel) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '0' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- IMMBsel
    control(IMMBsel) <= '0' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '1' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- CCRle
    control(CCRle) <= '0' when line_T = CMPR else 
            '0' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '1' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- MARle
    control(MARle) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '0' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- MCRle
    control(MCRle) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '0' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
    
    -- Mbyte
    control(membyte) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            I(7) OR I(6) when line_T = LOAD else
            I(7) OR I(6) when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- Mhalfword
    control(memhalf) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            I(7) OR I(6) when line_T = LOAD else
            I(7) OR NOT(I(6)) when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- Mcen
    control(memcen) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '0' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
    
    -- Moen
    control(memoen) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '1' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- Mwen
    control(memwen) <= '1' when line_T = CMPR else 
            '1' when line_T = CMPI else
            '1' when line_T = RR else
            '1' when line_T = RRR else
            '1' when line_T = RI else
            '1' when line_T = RRI else
            '1' when line_T = PCRL else 
            '1' when line_T = LOAD else
            '0' when line_T = STORE else
            '1' when line_T = BR else
            '1' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
            
    -- clken
    control(clken) <= '0' when line_T = CMPR else 
            '0' when line_T = CMPI else
            '0' when line_T = RR else
            '0' when line_T = RRR else
            '0' when line_T = RI else
            '0' when line_T = RRI else
            '0' when line_T = PCRL else 
            '0' when line_T = LOAD else
            '0' when line_T = STORE else
            '0' when line_T = BR else
            '0' when line_T = BPCR else
            '1' when line_T = HCF else
            '1'; -- just in case they add something
        
    -- T 
    T <= line_T;
    line_T <= CMPR when I(15 downto 6) = "1000011000" else 
        CMPI when I(15 downto 13) = "100" and I(10 downto 8) = "111" else
        RR when I(15 downto 13) = "100" and I(10 downto 9) = "10" and I(7 downto 6) = "00" else
        RRR when I(15 downto 13) = "100" and I(10) = '0' else
        RI when I(15 downto 13) = "110" else
        RRI when I(15 downto 13) = "101" else
        PCRL when I(15 downto 14) = "00" and I(5 downto 3) = "111" else 
        LOAD when I(15 downto 14) = "00" and I(5 downto 3) /= "111" else
        STORE when I(15 downto 14) = "01" else
        BR when I(15 downto 12) = "1110" and I(6 downto 3) = "0000" else
        BPCR when I(15 downto 12) = "1111" else
        HCF when I(15 downto 12) = "1110" and I(6 downto 3) = "1111" else
        ILLEGAL; -- just in case they add something

end arch;