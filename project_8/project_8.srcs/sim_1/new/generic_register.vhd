library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

-- D-register modified from pyeatt's slides
entity generic_register is
    generic ( Bits: integer := 8);
    port    (
               Enable: in std_logic;
               clk, reset: in std_logic;
               din: in std_logic_vector(Bits - 1 downto 0);
               dout: out std_logic_vector(Bits - 1 downto 0)
            );
                    
end generic_register;

architecture Behavioral of generic_register is
    
begin
        process(Enable,clk,reset)
        begin 
            if clk'event and clk='0' then 
                if reset = '0' then  
                    dout <= (others => '0');
                 elsif Enable = '0' then 
                    dout <= din;
                  end if;
             end if;
       end process;   
                
end Behavioral;