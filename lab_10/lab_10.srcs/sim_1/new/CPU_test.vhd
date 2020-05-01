library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_package.ALL;

entity CPU_test is
end CPU_test;

architecture Bench of CPU_test is
   signal clock : std_logic := '0';
   signal reset : std_logic; -- active low
   signal Mcen :  std_logic; -- active low
   signal Moen : std_logic; -- active low
   signal Mwen : std_logic; -- active low
   signal Mbyte : std_logic; -- active low
   signal Mhalf : std_logic; -- active low
   signal Mrts : std_logic; -- active low
   signal Mrte : std_logic; -- active low
   signal MAddr : std_logic_vector(31 downto 0);
   signal MDatao : std_logic_vector(31 downto 0);
   signal MDatai : std_logic_vector(31 downto 0);
   signal current_state, next_state: state_t;
   signal control: control_t_array;
   signal instruction: instruction_t;
    
begin

    CPU: entity work.CPU(arch)
        Port Map(
                  clock => clock,
                  reset => reset, 
                  Mcen => Mcen,
                  Moen => Moen,
                  Mwen => Mwen,
                  Mbyte => Mbyte,
                  Mhalf => Mhalf,
                  Mrts => Mrts,
                  Mrte => Mrte,
                  MAddr => MAddr,
                  MDatao => MDatao,
                  MDatai => MDatai
                );
                
    --start clock
    process
    begin 
        loop 
            wait for 5 ns;
            clock <= NOT(clock);
        end loop;
   end process;   
    
    -- good old reset
    process 
    begin 
        reset <= '0';
        wait for 10 ns;
        reset <= '1';
        wait for 10 ns;
    end process;
    
    --write test actual test code
end Bench;
