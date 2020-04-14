library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PC_test is
end PC_test;

architecture test_bench of PC_test is
    constant Bits: integer := 3;
    constant Increment: integer := 2;
    signal input: std_logic_vector(Bits-1 downto 0);
    signal output: std_logic_vector(Bits-1 downto 0);
    signal Load, IncE, clk, reset: std_logic;
    signal data: integer := 0;
    
    -- Thanks Christian for this great testing idea
    type TEST_STATE is (
        SETUP,
        SUCC_INC,
        FAIL_INC,
        SUCC_LOAD,
        FAIL_LOAD
        );
    signal state: TEST_STATE := SETUP;
begin
    PC: entity work.PC(arch)
    generic map( Bits => Bits, Increment => Increment)
    port map( input => input, output => output, Load => Load,
            IncE => IncE, clk => clk, reset => reset
            );
    
    Clock: process
        begin  
        clk <= '1';
        wait for 10 ns;
        clk <= not(clk);
        loop 
            wait for 10 ns;
            clk <= not(clk);
       end loop;
     end process Clock;
     
     Everything: process 
        variable i: integer := 0;
            begin 
            state <= SETUP;
            reset <= '1';
            Load <= '1';
            IncE <= '1';
            wait for 10 ns;
            reset <= '0';
            wait for 10 ns;
            reset <= '1';
            
            loop 
            state <= SUCC_INC;
            IncE <= '0';
            for i in 0 to 2**Bits-1 loop 
                wait for 10 ns;
            end loop;
            
            state <= FAIL_INC;
            IncE <= '1';
            for i in 0 to 2**Bits-1 loop
                wait for 10 ns;
            end loop;
            
            state <= SUCC_LOAD;
            Load <= '0';
            for i in 0 to 2**Bits-1 loop 
                input <= std_logic_vector(to_unsigned(data, Bits));
                wait for 10 ns;
                data <= data + 1;
            end loop;
            
            state <= FAIL_INC;
            Load <= '1';
            for i in 0 to 2**Bits-1 loop 
                input <= std_logic_vector(to_unsigned(data, Bits));
                wait for 10 ns;
                data <= data + 1;
            end loop;
      end loop;
   end process Everything;                 
end test_bench;
