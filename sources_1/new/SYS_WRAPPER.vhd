----------------------------------------------------------------------------------
-- Module Name: SYS_WRAPPER
-- Engineers: Kyle Wuerch & Chin Chao
-- Comments: This module is the top level module that directly interfaces
--           with the Basys3 Board
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYS_WRAPPER is
    Port ( CLK      : in  STD_LOGIC;
           RST      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           SWITCHES : in  STD_LOGIC_VECTOR (15 downto 0);
           LEDS     : out STD_LOGIC_VECTOR (15 downto 0);
           SSEG     : out STD_LOGIC_VECTOR (7 downto 0);
           DISP     : out STD_LOGIC_VECTOR (3 downto 0));
end SYS_WRAPPER;

architecture Behavioral of SYS_WRAPPER is

signal s_clk_div     : STD_LOGIC := '0';

signal s_sseg_cr     : STD_LOGIC_VECTOR(7 downto 0)  := X"00";
signal s_sseg_count1 : STD_LOGIC_VECTOR(13 downto 0) := "00" & X"000";
signal s_sseg_count2 : STD_LOGIC_VECTOR(7 downto 0)  := X"00";
signal mult_clk : std_logic;

signal s_interrupt   : STD_LOGIC := '0';


component clk_wiz_0
    port(clk_in1    : in std_logic;
         clk_out1   : out std_logic;
         reset      : in std_logic;
         locked     : out std_logic);
end component;
-- Declare RAT_wrapper ------------------------------------------------------
component RAT_pipeline_wrapper
    Port ( LEDS      : out   STD_LOGIC_VECTOR (15 downto 0);
           SSEG_VAL1 : out   STD_LOGIC_VECTOR (13 downto 0);
           SSEG_VAL2 : out   STD_LOGIC_VECTOR (7 downto 0);
           SSEG_CR   : out   STD_LOGIC_VECTOR (7 downto 0);
           SWITCHES  : in    STD_LOGIC_VECTOR (15 downto 0);
           INT       : in    STD_LOGIC;
           RST       : in    STD_LOGIC;
           CLK       : in    STD_LOGIC);
end component;
------------------------------------------------------------------------------

-- Declare MAIN_CLK_DIV ------------------------------------------------------
component MAIN_CLK_DIV is
    Port ( CLK  : in  STD_LOGIC;
           SCLK : out STD_LOGIC);
end component MAIN_CLK_DIV;
------------------------------------------------------------------------------

-- Declare db_1shot_FSM ------------------------------------------------------
component db_1shot_FSM
      Port ( A    : in STD_LOGIC;
             CLK  : in STD_LOGIC;
             A_DB : out STD_LOGIC);
end component;
------------------------------------------------------------------------------


begin

-- Instantiate RAT_WRAPPER --------------------------------------------------
rat: RAT_pipeline_wrapper
    Port Map(
        LEDS      => LEDS,
        SSEG_VAL1 => s_sseg_count1,
        SSEG_VAL2 => s_sseg_count2,
        SSEG_CR   => s_sseg_cr,
        SWITCHES  => SWITCHES,
        INT       => s_interrupt,
        RST       => RST,
        CLK       => mult_clk);
------------------------------------------------------------------------------

-- Instantiate MAIN_CLK_DIV --------------------------------------------------
div: MAIN_CLK_DIV
    port map (
        CLK  => CLK,
        SCLK => s_clk_div);
------------------------------------------------------------------------------
mult: clk_wiz_0
    port map (
    clk_in1  => CLK,
    clk_out1 => mult_clk,
    reset    => RST
    
    );
-- Instantiate db_1shot_FSM --------------------------------------------------              
   my_debouncer: db_1shot_FSM
   port map ( A    => INT,
              CLK  => s_clk_div,
              A_DB => s_interrupt);
------------------------------------------------------------------------------

end Behavioral;
