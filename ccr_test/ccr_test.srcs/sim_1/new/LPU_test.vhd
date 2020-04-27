-- Christain's Testbench code, used for helping debugg the IDE, slightly modified for our LPU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LPU_test is
end LPU_test;

architecture bench of LPU_test is
    constant Bits: integer := 32;
    constant Nsel: integer := 3;
   signal Asel: std_logic_vector(Nsel-1 downto 0);
   signal Bsel: std_logic_vector(Nsel-1 downto 0);
   signal Dsel: std_logic_vector(Nsel-1 downto 0);
   signal DIsel: std_logic := '1';
   signal Dlen: std_logic := '1';
   signal Data_in: std_logic_vector(Bits-1 downto 0);
   signal Data_out: std_logic_vector(Bits-1 downto 0);
   signal PCAsel: std_logic := '1';
   signal PCie: std_logic := '0';
   signal PCle: std_logic := '1'; 
   signal PCDsel: std_logic := '1';
   signal IMMBsel: std_logic := '1';
   signal IMM: std_logic_vector(Bits-1 downto 0);
   signal ALUfunc: std_logic_vector(3 downto 0);
   signal MCtrl: std_logic_vector(3 downto 0);
   signal CCRle: std_logic := '1';
   signal Flags: std_logic_vector(3 downto 0);
   signal MARle: std_logic := '0'; 
   signal MCRle: std_logic := '0';
   signal Control:  std_logic_vector(3 downto 0);
   signal Adress:  std_logic_vector(Bits-1 downto 0);
   signal reset: std_logic;
   signal clk: std_logic;
   
   type State is ( setup, suc_write, suc_read_a, suc_read_b, 
                    add, adc, sub, sbc, alu_not, alu_and, 
                    alu_or, alu_xor, b_pass, alu_lsl, alu_lsr,
                    alu_asr, load_pc, store, fail_write, read);
   
   signal tests: State := setup;
   signal data: integer := 0;
   signal immeadiate: integer := 4;
    
begin

    LPU: entity work.LPU(arch)
        generic map( Bits => Bits, Nsel => Nsel)
        port map( Asel => Asel, Bsel => Bsel, Dsel => Dsel,
                    DIsel => DIsel, Dlen => Dlen, 
                    Data_in => Data_in, Data_out => Data_out,
                    PCAsel => PCAsel, PCle => PCle, PCie => PCie, 
                    PCDsel => PCDsel, IMMBsel => IMMBsel,
                    IMM => IMM, ALUfunc => ALUfunc, 
                    MCtrl => MCtrl, CCRle => CCRle, Flags => Flags,
                    MARle => MARle, MCRle => MCRle, Control => Control,
                    Adress => Adress, reset => reset, clk => clk);
    
    Clock: process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= not clk;
        loop
            wait for 10 ns;
            clk <= not clk;
        end loop;
    end process Clock;
    
test: process
    begin
        -- clear the MAR
        tests <= setup;
        Reset <= '1';
        Dlen <= '1';
        PCle <= '1';
        PCie <= '1';
        PCDsel <= '1';
        PCAsel <= '1';
        IMMBsel <= '1';
        CCRle <= '1';
        MARle <= '1';
        MCRle <= '1';
        wait for 10 ns;
        Reset <= '0';
        wait for 15 ns;
        Reset <= '1';
        
        loop
            
            -- load values into registers 0 through 3
            tests <= suc_write;
            DIsel <= '1';
            Dlen <= '0';
            data <= data + 1;
            for i in 0 to 3 loop
                Dsel <= std_logic_vector(to_unsigned(i, 3));
                Data_in <= std_logic_vector(to_unsigned(data, Bits));
                wait for 20 ns;
                data <= data + 1;
            end loop;
            
            -- route registers 0 through 3 to B bus
            tests <= suc_read_b;
            MARle <= '0'; -- enable B bus to be outputted to 'Data_out'
            for i in 0 to 3 loop
                Bsel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            
            -- test ALU
            CCRle <= '0'; -- enable the CCR
            PCDsel <= '0'; -- route ALU output to D bus
            PCAsel <= '0'; -- route A bus to ALU
            IMMBsel <= '1'; -- route 'IMM" to ALU
            IMM <= std_logic_vector(to_unsigned(immeadiate, Bits)); -- 4 is a constant for calculations
            tests <= add;
            ALUfunc <= "0000";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= adc;
            ALUfunc <= "0010";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= sub;
            ALUfunc <= "0100";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= sbc;
            ALUfunc <= "0110";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_not;
            ALUfunc <= "1001";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_and;
            ALUfunc <= "1011";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_or;
            ALUfunc <= "1101";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_xor;
            ALUfunc <= "1111";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= b_pass;
            ALUfunc <= "1000";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_lsl;
            ALUfunc <= "1010";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_lsr;
            ALUfunc <= "1100";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;
            tests <= alu_asr;
            ALUfunc <= "1110";
            for i in 0 to 3 loop
                Asel <= std_logic_vector(to_unsigned(i, 3));
                wait for 20 ns;
            end loop;

            -- add zero from A bus to IMM, store resut in PC and output to address
            tests <= load_pc;
            IMMBsel <= '1'; -- route IMM to ALU
            PCAsel <= '0'; -- route A bus into ALU
            PCle <= '0'; -- enable PC load
            PCie <= '1'; -- diable PC increment
            PCDsel <= '1'; -- route PC to D bus
            ALUfunc <= "0000"; -- set ALU to ADD
            IMM <= std_logic_vector(to_unsigned(1, Bits)); -- set IMM to 1
            Asel <= std_logic_vector(to_unsigned(0, 3)); -- set A bus to 0
            wait for 40 ns;
            
            -- load in 2 to register 0 and 3 to register 1
            -- route register 0 to A bus and register 1 to B bus
            -- add the two together
            -- store the result in register 3
            -- route register 3 through the B bus to 'Data_out'
            tests <= store;
            DIsel <= '1'; -- route 'Data_in' into register file
            Dsel <= std_logic_vector(to_unsigned(0, 3)); -- route 'Data_in' to register 0
            Data_in <= std_logic_vector(to_unsigned(2, Bits));
            wait for 20 ns;
            Dsel <= std_logic_vector(to_unsigned(1, 3)); -- route 'Data_in' to register 1
            Data_in <= std_logic_vector(to_unsigned(3, Bits));
            wait for 20 ns;
            Asel <= std_logic_vector(to_unsigned(0, 3)); -- route register 0 to A bus
            Bsel <= std_logic_vector(to_unsigned(1, 3)); -- route register 1 to B bus
            PCAsel <= '0'; -- route A bus to ALU
            IMMBsel <= '0'; -- route B  bus to ALU
            ALUfunc <= "0000"; -- set ALU to ADD
            PCDsel <= '0'; -- route ALU output to D bus
            DIsel <= '0'; -- route D bus to register file
            Dsel <= std_logic_vector(to_unsigned(3, 3)); -- route D bus to register 3
            wait for 20 ns;
            Bsel <= std_logic_vector(to_unsigned(3, 3)); -- route register 3 to B bus
            wait for 20 ns;            
            
            
        end loop;
    end process test;   

end bench;
