library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_package.ALL;

entity CPU_test is
end CPU_test;

architecture Bench of CPU_test is
   signal clock : std_logic := '0';
   signal reset : std_logic := '0'; -- active low
   signal Mcen :  std_logic; -- active low
   signal Moen : std_logic; -- active low
   signal Mwen : std_logic; -- active low
   signal Mbyte : std_logic; -- active low
   signal Mhalf : std_logic; -- active low
   signal Mrts : std_logic := '1'; -- active low
   signal Mrte : std_logic := '1'; -- active low
   signal MAddr : std_logic_vector(31 downto 0);
   signal MDatao : std_logic_vector(31 downto 0);
   signal MDatai : std_logic_vector(31 downto 0);
   
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
        wait;
    end process;
    
    --write test actual test code
    process
    
    begin 
    --move 0x44 to R0 
    MDatai <= "00000000000000000000000001000100";
    Mrts <= '0';
    wait for 20 ns;
    Mrts <= '0';
    wait for 10 ns;
    Mrts <= '0';
    -- move 0x55 to R1
    MDatai <= "00000000000000001100001010101001"; 
    wait for 20 ns;
   
    -- switch states
    Mrts <= '1';
    wait for 20 ns;
    
     -- R0 OR 55 = 55
    MDatai <= "00000000000000001101001010101000";
    wait for 20 ns;
    end process;
    
    --good enough yeet into big CPU 
end Bench;
