
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity Computer is
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
    ddr2_odt     : out   std_logic
    );  
end Computer;

architecture Behavioral of Computer is
  
  component clk_wiz_0 is
    port(
      clk_50      : out std_logic;
      clk_200     : out std_logic;
      clk_100     : out std_logic;
      clk_25      : out std_logic;
      clk_75      : out std_logic;
      resetn      : in std_logic;
      locked      : out std_logic;
      clk_in1     : in std_logic
      );
  end component;

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

  -- for Memory_system:Memory
  --   use configuration work.Memory_with_ddr;
  
  -- Signals from CPU to Memory
  signal address : std_logic_vector(31 downto 0);
  signal data_in : std_logic_vector(31 downto 0);
  signal data_out: std_logic_vector(31 downto 0);
  signal cen     : std_logic;
  signal oen     : std_logic;
  signal wen     : std_logic;
  signal rts     : std_logic;
  signal rte     : std_logic;
  signal byte    : std_logic;
  signal half    : std_logic;

  -- Other signals
  signal clk_50   : std_logic:='0';
  signal clk_200  : std_logic:='0';
  signal clk_100  : std_logic:='0';
  signal clk_25   : std_logic:='0';
  signal clk_75   : std_logic:='0';
  signal locked   : std_logic:='0';
  signal irst,irstff  : std_logic:='0';
  
begin

  clkgen: clk_wiz_0
    port map(
      clk_in1 =>clock,
      clk_50  => clk_50,
      clk_200 => clk_200,
      clk_100 => clk_100,
      clk_25  => clk_25,
      clk_75  => clk_75,
      locked => locked,
      resetn => reset
      );

  
  -- this process brings the system out of reset cleanly

  process(clk_25,reset,locked)
  begin
    if reset = '0' or locked = '0' then
      irstff <= '0';
      irst <= '0';
    elsif rising_edge(clk_25) then
      irstff <= '1';
      irst <= irstff;
    end if;
  end process;

  
  CPU: entity work.CPU(arch)
    port map(clock=>clk_50,
             reset=>irst,
             Mcen=>cen,    
             Mwen=>wen,    
             Moen=>oen,    
             Mbyte=>byte,  
             Mhalf=>half,  
             Mrts=>rts,
             Mrte=>rte,
             MAddr=>address,  
             MDatao=>data_in,
             MDatai=>data_out);
  
  
  Memory_system: Memory_NO_DDR
    port map(address=> address, 
             data_in=> data_in, 
             data_out=>data_out,
             rts=>     rts,
             rte=>     rte,
             cen=>     cen,     
             oen=>     oen,     
             wen=>     wen,     
             byteop=>  byte,   
             halfop=>  half,
             reset=>   irst,
             clk_200=> clk_200,
             clk_100=> clk_100,
             CPU_clk=> clk_50,
             sseg=>sseg,sseg_an=>sseg_an,leds=>leds,rgb_leds=>rgb_leds,
             switches=>switches,buttons=>buttons,
             UART_BR_clk=> clk_50,
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
             ddr2_odt      => ddr2_odt     
             );
  
  
end Behavioral;



-- configuration Computer_with_ddr of Computer is
--   for Behavioral
--     for Memory_system:Memory
--       use configuration work.Memory_with_ddr;
--     end for;
--   end for;
-- end configuration Computer_with_ddr;

-- configuration Computer_no_ddr of Computer is
--   for Behavioral
--     for Memory_system:Memory
--       use configuration work.Memory_no_ddr;
--     end for;
--   end for;
-- end configuration Computer_no_ddr;




