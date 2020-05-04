
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity Computer_testbench is
end Computer_testbench;

architecture Behavioral of Computer_testbench is

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

component Computer is
  port(
    clock  : in  std_logic;
    reset  : in  std_logic; -- active low but signal from board is ?
    sseg    : out std_logic_vector(7 downto 0);  -- 7-segment drivers    
    sseg_an : out std_logic_vector(7 downto 0);  -- 7-segment anodes
    leds    : out std_logic_vector(15 downto 0); -- discrete LED's
    rgb_leds: out std_logic_vector(5 downto 0);  -- RGB LED's
    switches: in  std_logic_vector(15 downto 0); -- switches
    buttons : in  std_logic_vector(4 downto 0);  -- buttons
    TXD     : out std_logic;
    RXD     : in  std_logic;
    -- CTS     : in std_logic:='0';
    -- RTS     : out  std_logic:='0'

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
    -- ddr2_rdqs_n  : in    std_logic_vector(1 downto 0);
    ddr2_odt     : out   std_logic
    );  
end component Computer;

-- for Computer_System: Computer use entity work.Computer(Behavioral);

  -- for Computer_System:Computer
  --     use configuration work.Computer_no_ddr;


  signal clock   : std_logic:='1';
  signal reset   : std_logic:='1'; -- active low but signal from board is ?
  signal sseg    : std_logic_vector(7 downto 0);  -- 7-segment drivers    
  signal sseg_an : std_logic_vector(7 downto 0);  -- 7-segment anodes
  signal leds    : std_logic_vector(15 downto 0); -- discrete LED's
  signal rgb_leds: std_logic_vector(5 downto 0);  -- RGB LED's
  signal switches: std_logic_vector(15 downto 0); -- switches
  signal buttons : std_logic_vector(4 downto 0);  -- buttons
  signal BRclk,RXD,TXD:std_logic:='1';


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


  


  Computer_System: Computer
    port map(
      clock   =>  clock,   
      reset   =>  reset,   
      sseg    =>  sseg,    
      sseg_an =>  sseg_an, 
      leds    =>  leds,    
      rgb_leds=>  rgb_leds,
      switches=>  switches,
      buttons =>  buttons,
      RXD=>RXD,
      TXD=>TXD,

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

  process
  begin
    loop
      clock<= not clock;
      wait for 5 ns;
    end loop;
  end process;

  process
  begin
    switches<= "0000000000000000";
    buttons<= "11111";
    reset<='0';
    RXD <= '1';
    wait for 40 ns;
    reset<='1';
    
    
    wait for 55 us;
    
    -- Send hex 0x31
    RXD <= '0'; -- start bit
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '1'; -- stop bit

    wait for 20 us;
    
    RXD <= '0';  -- start bit
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '1'; -- 0
    wait for 8.64 us;
    RXD <= '0'; -- 1
    wait for 8.64 us;
    RXD <= '1'; -- stop bit
    
    wait;
  end process;
  

  
end Behavioral;



-- configuration ddr of Computer_testbench is
--   for Behavioral
--     for Computer_System:Computer
--       use configuration ddr;
--     end for;
--   end for;
-- end ddr;

-- configuration no_ddr of Computer_testbench is
--   for no_ddr
--     for Computer_System: Computer
--     use configuration no_ddr;
--     end for;
--   end for;
-- end no_ddr;
