----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2020 04:10:17 PM
-- Design Name: 
-- Module Name: N_bit_adder_test - test_bench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity N_bit_adder_test is
generic( n: integer := 4);
end N_bit_adder_test;

architecture test_bench of N_bit_adder_test is  
    component N_bit_adder
       generic( n: integer := 4); 
       PORT( cin: IN STD_LOGIC;
             a, b : IN STD_LOGIC_VECTOR(n-1 downto 0);
             sum: OUT STD_LOGIC_VECTOR(n-1 downto 0);
             cout: OUT STD_LOGIC
           );
     end component;
     signal A,B,SUM: STD_LOGIC_VECTOR(n-1 downto 0);
     signal cin, COUT: STD_LOGIC;
     
begin
UUT: entity work.N_bit_adder(ripple_adder)
    generic map(n => n)
    PORT MAP(cin => cin, A => A, B => B, sum => sum, cout => cout); 
stim_procc: process
variable k : integer;
variable j: integer;
begin
for k in 0 to 15 loop
    A <= std_logic_vector(to_unsigned(k, 4));
    for j in 0 to 15 loop 
        B <= std_logic_vector(to_unsigned(j, 4));
        cin <= '0';
        wait for 100 ns; 
    end loop;
end loop;
end process;       
end test_bench;
