library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory_testbench is
-- port(
-- ddr2_addr          : out   std_logic_vector(12 downto 0);
-- ddr2_ba            : out   std_logic_vector(2 downto 0);
-- ddr2_ras_n         : out   std_logic;
-- ddr2_cas_n         : out   std_logic;
-- ddr2_we_n          : out   std_logic;
-- ddr2_ck_p          : out   std_logic_vector(0 downto 0);
-- ddr2_ck_n          : out   std_logic_vector(0 downto 0);
-- ddr2_cke           : out   std_logic_vector(0 downto 0);
-- ddr2_cs_n          : out   std_logic_vector(0 downto 0);
-- ddr2_dm            : out   std_logic_vector(1 downto 0);
-- ddr2_odt           : out   std_logic_vector(0 downto 0);
-- ddr2_dq            : inout std_logic_vector(15 downto 0);
-- ddr2_dqs_p         : inout std_logic_vector(1 downto 0);
-- ddr2_dqs_n         : inout std_logic_vector(1 downto 0)
--    );
end Memory_testbench;

architecture Behavioral of Memory_testbench is


  component ddr2_model is
    port(
      -- reset_n : in    std_logic;
      ck       : in    std_logic; -- _vector(2 downto 0);
      ck_n     : in    std_logic; -- _vector(2 downto 0);
      cke      : in    std_logic; --_vector(1 downto 0);
      cs_n     : in    std_logic; --_vector(1 downto 0);
      ras_n    : in    std_logic;
      cas_n    : in    std_logic;
      we_n     : in    std_logic;
      dm_rdqs  : inout std_logic_vector(1 downto 0); 
      ba       : in    std_logic_vector(2 downto 0);
      addr     : in    std_logic_vector(12 downto 0);
      dq       : inout std_logic_vector(15 downto 0);
      dqs      : inout std_logic_vector(1 downto 0);
      dqs_n    : inout std_logic_vector(1 downto 0);
      rdqs_n   : out   std_logic_vector(1 downto 0);
      odt      : in    std_logic
      );
  end component ddr2_model;

 component Memory_NO_DDR is
    Port ( address : in STD_LOGIC_VECTOR (31 downto 0);
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out: out STD_LOGIC_VECTOR (31 downto 0);
           rts     : out STD_LOGIC;  -- active low signal to CPU (ready to start)
           rte     : out STD_LOGIC;  -- active low signal to CPU (ready to end)
           cen     : in STD_LOGIC;   -- active low enable signal from CPU
           oen     : in STD_LOGIC;   -- active low read signal from CPU 
           wen     : in STD_LOGIC;   -- active low write signal from CPU 
           byteop  : in STD_LOGIC;   -- active low write upper byte
           halfop  : in STD_LOGIC;   -- active low write lower byte
           reset   : in STD_LOGIC;   -- system reset
           clk_200 : in STD_LOGIC;   -- ddr2 memory clock
           clk_100 : in STD_LOGIC;   -- system clock
           CPU_clk : in STD_LOGIC;   -- system clock
           
           -- These signals have to be passed up to the top level entity
           -- for actual interfacing with the hardware RAM device
           ddr2_ck_p    : out   std_logic; -- _vector(2 downto 0);
           ddr2_ck_n    : out   std_logic; -- _vector(2 downto 0);
           ddr2_cke     : out   std_logic; --_vector(1 downto 0);
           ddr2_cs_n    : out   std_logic; --_vector(1 downto 0);
           ddr2_ras_n   : out   std_logic;
           ddr2_cas_n   : out   std_logic;
           ddr2_we_n    : out   std_logic;
           ddr2_dm      : out   std_logic_vector(1 downto 0); 
           ddr2_ba      : out   std_logic_vector(2 downto 0);
           ddr2_addr    : out   std_logic_vector(12 downto 0);
           ddr2_dq      : inout std_logic_vector(15 downto 0);
           ddr2_dqs     : inout std_logic_vector(1 downto 0);
           ddr2_dqs_n   : inout std_logic_vector(1 downto 0);
           ddr2_odt     : out   std_logic;

           -- Basic I/O pins
           sseg    : out std_logic_vector(7 downto 0);  -- 7-segment drivers    
           sseg_an : out std_logic_vector(7 downto 0);  -- 7-segment anodes
           leds    : out std_logic_vector(15 downto 0); -- discrete LED's
           rgb_leds: out std_logic_vector(5 downto 0);  -- RGB LED's
           switches: in  std_logic_vector(15 downto 0); -- switches
           buttons : in  std_logic_vector(4 downto 0);  -- buttons

           -- UART signals
           UART_BR_clk  : in  std_logic; -- clock used to set baud rate
           TXD     : out std_logic;  -- USB-RS232 transmit
           RXD     : in  std_logic   -- USB-RS232 receive
     -- RTS     : out  std_logic;  -- USB-RS232 ready to send
     -- CTS     : in std_logic   -- USB-RS232 clear to send
     -- add more devices as needed
           );
  end component;

  
  signal address  : std_logic_vector(31 downto 0);
  signal data_in  : std_logic_vector(31 downto 0);
  signal data_out : std_logic_vector(31 downto 0);
  signal rts,rte,cen,oen,wen,byte,half,reset,
    clk_100,clk_200,clk_75,clk_50,clk_25 : std_logic;
  signal sseg     : std_logic_vector(7 downto 0);  -- 7-segment drivers    
  signal sseg_an  : std_logic_vector(7 downto 0);  -- 7-segment anodes
  signal leds     : std_logic_vector(15 downto 0); -- discrete LED's
  signal rgb_leds : std_logic_vector(5 downto 0);  -- RGB LED's
  signal switches : std_logic_vector(15 downto 0); -- switches
  signal buttons  : std_logic_vector(4 downto 0);  -- buttons
  signal TXD      : std_logic;
  signal RXD      : std_logic;

  signal ddr2_ck_p     : std_logic;
  signal ddr2_ck_n     : std_logic;
  signal ddr2_cke      : std_logic;
  signal ddr2_cs_n     : std_logic;
  signal ddr2_ras_n    : std_logic;
  signal ddr2_cas_n    : std_logic;
  signal ddr2_we_n     : std_logic;
  signal ddr2_dm       : std_logic_vector(1 downto 0); 
  signal ddr2_ba       : std_logic_vector(2 downto 0);
  signal ddr2_addr     : std_logic_vector(12 downto 0);
  signal ddr2_dq       : std_logic_vector(15 downto 0);
  signal ddr2_dqs      : std_logic_vector(1 downto 0);
  signal ddr2_dqs_n    : std_logic_vector(1 downto 0);
  signal ddr2_rdqs_n   : std_logic_vector(1 downto 0);
  signal ddr2_odt      : std_logic;

begin

  ddr2_device : ddr2_model
    port map (
      ck       => ddr2_ck_p,
      ck_n     => ddr2_ck_n,
      cke      => ddr2_cke,   
      cs_n     => ddr2_cs_n,  
      ras_n    => ddr2_ras_n, 
      cas_n    => ddr2_cas_n,
      we_n     => ddr2_we_n,
      dm_rdqs  => ddr2_dm,
      ba       => ddr2_ba,
      addr     => ddr2_addr,
      dq       => ddr2_dq,
      dqs      => ddr2_dqs,
      dqs_n    => ddr2_dqs_n,
      -- rdqs_n   => ddr2_rdqs_n,
      odt      => ddr2_odt     
      );


  Memory_device: Memory_NO_DDR
    port map(address=> address, 
             data_in=> data_in, 
             data_out=>data_out,
             rts=>     rts,   
             rte=>     rte,   
             cen=>     cen,     
             oen=>     oen,     
             wen=>     wen,     
             byteop=>    byte,   
             halfop=>    half,
             reset=>   reset,
             clk_200=>  clk_200,
             clk_100=>  clk_100,
             CPU_clk=>   clk_50,
             uart_br_clk => clk_50,
             sseg=>sseg,sseg_an=>sseg_an,leds=>leds,rgb_leds=>rgb_leds,
             switches=>switches,buttons=>buttons,

             -- UARTclk=>clk_50,
             RXD=>RXD,TXD=>TXD,  --CTS=>CTS,RTS=>RTS,

             ddr2_ck_p     => ddr2_ck_p,
             ddr2_ck_n     => ddr2_ck_n,
             ddr2_cke      => ddr2_cke,   
             ddr2_cs_n     => ddr2_cs_n,  
             ddr2_ras_n    => ddr2_ras_n, 
             ddr2_cas_n    => ddr2_cas_n,
             ddr2_we_n     => ddr2_we_n,
             ddr2_dm       => ddr2_dm,
             ddr2_ba       => ddr2_ba,
             ddr2_addr     => ddr2_addr,
             ddr2_dq       => ddr2_dq,
             ddr2_dqs      => ddr2_dqs,
             ddr2_dqs_n    => ddr2_dqs_n,
             -- ddr2_rdqs_n   => ddr2_rdqs_n,
             ddr2_odt      => ddr2_odt     

             );

  clk_25_proc: process
  begin
    clk_25<= '1';
    loop
      wait for 10 ns;
      clk_25 <= not clk_25;
    end loop;
  end process clk_25_proc;

  clk_50_proc: process
  begin
    clk_50<= '1';
    loop
      wait for 10 ns;
      clk_50 <= not clk_50;
    end loop;
  end process clk_50_proc;

  clk_75_proc: process
  begin
    clk_75<= '1';
    loop
      wait for 7.5 ns;
      clk_75 <= not clk_75;
    end loop;
  end process clk_75_proc;

  clk_100MHz: process
  begin
    clk_100 <= '1';     
    loop
      wait for 5 ns;
      clk_100 <= not clk_100;
    end loop;
  end process clk_100MHz;

  
  clk_200_proc: process
  begin
    clk_200<= '1';
    loop
      wait for 2.5 ns;
      clk_200 <= not clk_200;
    end loop;
  end process clk_200_proc;
  
  

  test: process
    variable i: natural;
    constant DDR2_RAM_ADDR : natural := 268435456;
    constant BLOCK_RAM_ADDR : natural := 402653184;

    procedure ram_test(offset  : in natural
     -- signal address : out std_logic_vector(31 downto 0);
     -- signal data_in : out std_logic_vector(31 downto 0);
     -- signal cen  : out std_logic;
     -- signal oen  : out std_logic;
     -- signal wen  : out std_logic;
     -- signal byte : out std_logic;
     -- signal half : out std_logic;
     -- signal rte  : in std_logic;
     -- signal rts  : in std_logic
                       ) is
    begin
      cen <= '1';
      wen <= '1';
      oen <= '1';
      byte <= '1';
      half <= '1';
      wait for 10 ns;    
      -- BYTE R/W TESTS
      for i in 0 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned(i+offset,32)); -- x"08000100";
        data_in <= std_logic_vector(to_unsigned(i+1,32)); -- x"01020304";
        cen <= '0';
        wen <= '0';
        byte <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        wen <= '1';
        byte <= '1';
        wait for 10 ns;    
      end loop;
      for i in 0 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned(i+offset,32)); -- x"00000100";
        cen <= '0';
        oen <= '0';
        byte <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        oen <= '1';
        byte <= '1';
        wait for 10 ns;    
      end loop;
-- HALFWORD R/W TESTS
      for i in 16 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned((i*2)+offset,32)); -- x"00000100";
        data_in <= std_logic_vector(to_unsigned(i+9,32)); -- x"01020304";
        cen <= '0';
        wen <= '0';
        half <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        wen <= '1';
        half <= '1';
        wait for 10 ns;    
      end loop;
      for i in 16 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        wait for 10 ns;    
        address <= std_logic_vector(to_unsigned((i*2)+offset,32)); -- x"00000100";
        cen <= '0';
        oen <= '0';
        half <= '0';
        if rte /= '0' then
          wait until rte = '0';
        end if;
        wait for 10 ns;    
        cen <= '1';
        oen <= '1';
        half <= '1';
      end loop;
-- WORD R/W TESTS
      for i in 16 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned((i*4)+offset,32)); -- x"00000100";
        data_in <= std_logic_vector(to_unsigned(i+16843009,32)); -- x"01020304";
        cen <= '0';
        wen <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        wen <= '1';
        wait for 10 ns;    
      end loop;
      for i in 16 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned((i*4)+offset,32)); -- x"00000100";
        cen <= '0';
        oen <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        oen <= '1';
        wait for 10 ns;    
      end loop;
      -- read everything as word data
      for i in 0 to 31 loop
        if rts /= '0' then
          wait until rts = '0';
        end if;
        address <= std_logic_vector(to_unsigned((i*4)+offset,32)); -- x"00000100";
        cen <= '0';
        oen <= '0';
        wait for 10 ns;    
        if rte /= '0' then
          wait until rte = '0';
        end if;
        cen <= '1';
        oen <= '1';
        wait for 10 ns;    
      end loop;
    end procedure ram_test;



  begin
    reset <= '0';
    cen  <= '1';
    oen  <= '1';
    wen  <= '1';
    byte<= '1';
    half<= '1';
    data_in <= "00000000000000000000000000000000";
    address <= "00000000000000000000000000000000";

    wait for 20 ns;
    reset <= '1';

    wait until rts = '0';

    -- Read word from ROM
      cen <= '1';
      wen <= '1';
      oen <= '1';
      byte <= '1';
      half <= '1';
      wait for 10 ns;    
      cen <= '0';
      oen <= '0';
      wait for 10 ns;    

      

    -- Read byte from ROM: half word aligned byte

    if rts /= '0' then
      wait until rts = '0';
    end if;
    address <= std_logic_vector(to_unsigned(1062,32)); -- x"08000100";
    cen <= '0';
    oen <= '0';
    wen <= '1';
    byte <= '0';
    wait for 10 ns;    
    if rte /= '0' then
      wait until rte = '0';
    end if;
    cen <= '1';
    oen <= '1';
    byte <= '1';
    wait for 10 ns;
    
    -- Read byte from ROM: non-aligned byte
    if rts /= '0' then
      wait until rts = '0';
    end if;
    address <= std_logic_vector(to_unsigned(1063,32)); -- x"08000100";
    cen <= '0';
    oen <= '0';
    wen <= '1';
    byte <= '0';
    wait for 10 ns;    
    if rte /= '0' then
      wait until rte = '0';
    end if;
    cen <= '1';
    oen <= '1';
    byte <= '1';
    wait for 10 ns;    

    
    -- Read byte from ROM: word aligned byte

    if rts /= '0' then
      wait until rts = '0';
    end if;
    address <= std_logic_vector(to_unsigned(1064,32)); -- x"08000100";
    cen <= '0';
    oen <= '0';
    wen <= '1';
    byte <= '0';
    wait for 10 ns;    
    if rte /= '0' then
      wait until rte = '0';
    end if;
    cen <= '1';
    oen <= '1';
    byte <= '1';
    wait for 10 ns;
    
    -- Read byte from ROM: non-aligned byte
    if rts /= '0' then
      wait until rts = '0';
    end if;
    address <= std_logic_vector(to_unsigned(1065,32)); -- x"08000100";
    cen <= '0';
    oen <= '0';
    wen <= '1';
    byte <= '0';
    wait for 10 ns;    
    if rte /= '0' then
      wait until rte = '0';
    end if;
    cen <= '1';
    oen <= '1';
    byte <= '1';
    wait for 10 ns;    

    
    -- read from ROM word aligned.
    address <= "00000000000000000000000000001000";
    cen  <= '0';
    oen  <= '0';
    wen  <= '1';
    byte <= '1';
    half <= '0';
    wait for 10 ns;  

    cen  <= '1';  -- deassert control lines
    oen  <= '1';
    wen  <= '1';
    byte <= '1';
    half <= '1';
    wait for 10 ns;

    -- read from ROM half word aligned.
    address <= "00000000000000000000000000001010";
    cen  <= '0';
    oen  <= '0';
    wen  <= '1';
    byte <= '1';
    half <= '0';
    wait for 10 ns;

    cen  <= '1';  -- deassert control lines
    oen  <= '1';
    wen  <= '1';
    byte <= '1';
    half <= '1';
    wait for 10 ns;



--    ram_test(BLOCK_RAM_ADDR,address,data_in,cen,oen,wen,byte,half,rte,rts);
    ram_test(BLOCK_RAM_ADDR);

    
    wait;



    
    -- read from hex_dev 0x08000000
    -- write to hex_dev
    -- read from hex_dev
    -- write to led_dev 0x08000080
    -- read from led_dev
    -- write to rgb_led_dev 0x08000100
    -- read from rgb_led_dev
    -- read from switch_dev 0x08000180
    -- read from button_dev 0x08000200
    -- write to UART_dev tx register   0x08000280
    -- read_from UART_dev status register


    -- -- write byte to RAM even address
    -- address <= "00010000000001000000000000001000";
    -- data_in <= "1010010110111101";
    -- cen  <= '0';
    -- oen  <= '1';
    -- wen  <= '0';
    -- ubyte<= '1';
    -- lbyte<= '0';
    -- wait until ready = '0';
    -- wait for 2.4 ns;  

    -- cen  <= '1';  -- deassert control lines
    -- oen  <= '1';
    -- wen  <= '1';
    -- ubyte<= '1';
    -- lbyte<= '1';
    -- wait for 10 ns;

    -- -- read halfword from RAM even address
    -- address <= "00010000000001000000000000001000";
    -- data_in <= "0000000000000000";
    -- cen  <= '0';
    -- oen  <= '0';
    -- wen  <= '1';
    -- ubyte<= '1';
    -- lbyte<= '1';
    -- wait until ready = '0';
    -- wait for 2.4 ns;  

    -- cen  <= '1';  -- deassert control lines
    -- oen  <= '1';
    -- wen  <= '1';
    -- ubyte<= '1';
    -- lbyte<= '1';
    -- wait for 10 ns;
    -- write byte to RAM  odd address
    -- read byte from RAM odd address
    -- write halfword to RAM word aligned
    -- read halfword from RAM from RAM word aligned
    -- write halfword to RAM halfword aligned
    -- read halfword from RAM from RAM halfword aligned
    -- write word to RAM
    -- read word from RAM

    wait;
  end process test; 

end Behavioral;
