library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wrapper is
    Generic ( 
              Bits: integer := 2;
              Nsel: integer:= 2
            );
            
    Port (
           Asel, Bsel, Dsel: in std_logic_vector(Nsel-1 downto 0);
           Dlen: in std_logic;
           data_in: in std_logic_vector(Bits-1 downto 0);
           data_out: out std_logic_vector(Bits-1 downto 0);
           PCDsel: in std_logic;
           IMMBsel: in std_logic;
           ALUfunc: in std_logic_vector(3 downto 0);
           Flags: out std_logic_vector(3 downto 0);
           Control: out std_logic_vector(3 downto 0);
           Adress: out std_logic_vector(1 downto 0);
           reset, clk: in std_logic
          );
end wrapper;

architecture arch of wrapper is
constant high: std_logic := '1';
constant low: std_logic := '0';
constant IM: std_logic_vector(1 downto 0) := "01";
constant Mtl: std_logic_vector(3 downto 0) := "0100";
begin
    LPU_wrapped: entity work.LPU(arch)
            Generic map( Bits => Bits, Nsel => Nsel)
            Port map( Asel => Asel, 
                      Bsel => Bsel, 
                      Dsel => Dsel, 
                      DIsel => high,
                      Dlen => Dlen, 
                      data_in => data_in, 
                      data_out => data_out,
                      PCAsel => low, 
                      PCle => high, 
                      PCie => low, 
                      PCDsel => PCDsel, 
                      IMMBsel => IMMBsel,
                      IMM => IM,
                      ALUfunc => ALUfunc, 
                      CCRle => low, 
                      Flags => Flags, 
                      MARle => low, 
                      Control => Control, 
                      Adress => Adress,
                      MCtrl => Mtl, 
                      MCRle => low, 
                      reset => reset, 
                      clk => clk);

end arch;
