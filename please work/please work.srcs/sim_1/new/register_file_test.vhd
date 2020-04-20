library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_test is
end register_file_test;

architecture test_bench of register_file_test is
constant Bits: integer := 4; 
constant Nsel: integer := 2; 
signal Asel: std_logic_vector(Nsel-1 downto 0);
signal Bsel: std_logic_vector(Nsel-1 downto 0);
signal Dsel: std_logic_vector(Nsel-1 downto 0);
signal DIsel: std_logic := '1';
--signal Dlen: std_logic;
signal Din: std_logic_vector (Bits-1 downto 0);
-- Dout: out std_logic_vector (Bits-1 downto 0); whoops on the otherside 
signal A: std_logic_vector (Bits-1 downto 0);
signal B: std_logic_vector (Bits-1 downto 0);
signal clk, reset: std_logic := '1';
signal test_in: integer := 0;

type check is (SETUP, SUC_WRITE, FAIL_WRITE, READ, NO_CHANGE);
signal state: check := SETUP;

begin 
    uut: entity work.register_file(Behavioral)
        generic map( Bits => Bits, Nsel => Nsel)
        port map(
                    Asel => Asel, Bsel => Bsel, Dsel => Dsel, 
                    DIsel => DIsel, Din => Din, A => A, B => B,
                    clk => clk, reset => reset
                 );
process 
     begin
     -- clear  
     wait for 10 ns;
     reset <= '0';
     wait for 10 ns; 
     reset <= '1';
     wait;
 end process;
  
  process
    begin
      -- clock
     wait for 5 ns; 
     clk <= not(clk);
        loop
        wait for 10 ns;
        clk <= not(clk);
        end loop;
end process;

process 
variable i: integer := 0;
begin
    wait for 25 ns;
    --  write
    loop 
    state <= SUC_WRITE;
    DIsel <= '0';
    for i in 0 to 2**Nsel-1 loop 
        Dsel <= std_logic_vector(to_unsigned(i,Nsel));
        Din <= std_logic_vector(to_unsigned(test_in,Bits));
        test_in <= test_in + 1;
        wait for 20 ns;
   end loop;
  
    -- read 
    state <= READ;
    DIsel <= '1';
    for i in 0 to 2**Nsel-1 loop
        Asel <= std_logic_vector(to_unsigned(i,2));
        Bsel <= std_logic_vector(to_unsigned(i+1,2));
        wait for 20 ns;
    end loop;
  
    -- disable write but try writing
    state <= FAIL_WRITE;
    DIsel <= '1';
    for i in 0 to 2**Nsel-1 loop 
        Dsel <= std_logic_vector(to_unsigned(i,Nsel));
        Din <= std_logic_vector(to_unsigned(test_in,Bits));
        test_in <= test_in + 1;
        wait for 20 ns;
   end loop;
 
   -- check to make sure nothing changed
   state <= NO_CHANGE;
   DIsel <= '1';
    for i in 0 to 2**Nsel-1 loop
        Asel <= std_logic_vector(to_unsigned(i,2));
        Bsel <= std_logic_vector(to_unsigned(i+1,2));
        wait for 20 ns;
    end loop;
  
    end loop;
end process;        
end test_bench;

--architecture test_bench of register_file_test is
--constant Bits: integer := 4; 
--constant Nsel: integer := 2; 
--signal Asel: std_logic_vector(Nsel-1 downto 0);
--signal Bsel: std_logic_vector(Nsel-1 downto 0);
--signal Dsel: std_logic_vector(Nsel-1 downto 0);
--signal DIsel: std_logic := '1';
----signal Dlen: std_logic;
--signal Din: std_logic_vector (Bits-1 downto 0);
---- Dout: out std_logic_vector (Bits-1 downto 0); whoops on the otherside 
--signal A: std_logic_vector (Bits-1 downto 0);
--signal B: std_logic_vector (Bits-1 downto 0);
--signal clk, reset: std_logic := '1';
--signal test_in: integer := 0;

--begin 
--    uut: entity work.register_file(Behavioral)
--        generic map( Bits => Bits, Nsel => Nsel)
--        port map(
--                    Asel => Asel, Bsel => Bsel, Dsel => Dsel, 
--                    DIsel => DIsel, Din => Din, A => A, B => B,
--                    clk => clk, reset => reset
--                 );
--process 
--    variable i: integer := 0;
--     begin
  
--     -- clear  
--     wait for 10 ns;
--     reset <= '0';
--     wait for 10 ns; 
--     reset <= '1';
--     wait for 10 ns;
  
--    -- clock 
--    clk <= not(clk);
--    wait for 10 ns;
--    clk <= not(clk);
--    wait for 10 ns;
--    clk <= not(clk);
--    wait for 10 ns;
  
--    --  write
--    loop 
--    DIsel <= '0';
--    for i in 0 to 3 loop 
--        Dsel <= std_logic_vector(to_unsigned(i,Nsel));
--        Din <= std_logic_vector(to_unsigned(test_in,Bits));
--        test_in <= test_in + 1;
--        wait for 15 ns;
--   end loop;
  
--    -- read 
--    DIsel <= '1';
--    for i in 0 to 3 loop
--        Asel <= std_logic_vector(to_unsigned(i,2));
--        Bsel <= std_logic_vector(to_unsigned(i+1,2));
--        wait for 15 ns;
--    end loop;
  
--    -- disable write but try writing
--    DIsel <= '1';
--    for i in 0 to 3 loop 
--        Dsel <= std_logic_vector(to_unsigned(i,Nsel));
--        Din <= std_logic_vector(to_unsigned(test_in,Bits));
--        test_in <= test_in + 1;
--        wait for 15 ns;
--   end loop;
 
--   -- check to make sure nothing changed
--   DIsel <= '1';
--    for i in 0 to 3 loop
--        Asel <= std_logic_vector(to_unsigned(i,2));
--        Bsel <= std_logic_vector(to_unsigned(i+1,2));
--        wait for 15 ns;
--    end loop;
  
--    end loop;
--end process;        
--end test_bench;