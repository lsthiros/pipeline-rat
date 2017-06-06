-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 14.4.2017 22:23:56 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_DECODER is
end tb_DECODER;

architecture tb of tb_DECODER is

    component DECODER
        port (INT          : in std_logic;
              RESET        : in std_logic;
              OPCODE_HI_5  : in std_logic_vector (4 downto 0);
              OPCODE_LO_2  : in std_logic_vector (1 downto 0);
              PC_LD        : out std_logic;
              PC_INC       : out std_logic;
              PC_MUX_SEL   : out std_logic_vector (1 downto 0);
              SP_LD        : out std_logic;
              SP_INCR      : out std_logic;
              SP_DECR      : out std_logic;
              RF_WR        : out std_logic;
              RF_WR_SEL    : out std_logic_vector (1 downto 0);
              ALU_OPY_SEL  : out std_logic;
              ALU_SEL      : out std_logic_vector (3 downto 0);
              SCR_WE       : out std_logic;
              SCR_DATA_SEL : out std_logic;
              SCR_ADDR_SEL : out std_logic_vector (1 downto 0);
              FLG_C_SET    : out std_logic;
              FLG_C_CLR    : out std_logic;
              FLG_C_LD     : out std_logic;
              FLG_Z_LD     : out std_logic;
              FLG_LD_SEL   : out std_logic;
              FLG_SHAD_LD  : out std_logic;
              I_SET        : out std_logic;
              I_CLR        : out std_logic;
              IO_STRB      : out std_logic;
              BRANCH_TYPE  : out std_logic_vector (3 downto 0);
              RST          : out std_logic);
    end component;

    signal INT          : std_logic;
    signal RESET        : std_logic;
    signal OPCODE_HI_5  : std_logic_vector (4 downto 0);
    signal OPCODE_LO_2  : std_logic_vector (1 downto 0);
    signal PC_LD        : std_logic;
    signal PC_INC       : std_logic;
    signal PC_MUX_SEL   : std_logic_vector (1 downto 0);
    signal SP_LD        : std_logic;
    signal SP_INCR      : std_logic;
    signal SP_DECR      : std_logic;
    signal RF_WR        : std_logic;
    signal RF_WR_SEL    : std_logic_vector (1 downto 0);
    signal ALU_OPY_SEL  : std_logic;
    signal ALU_SEL      : std_logic_vector (3 downto 0);
    signal SCR_WE       : std_logic;
    signal SCR_DATA_SEL : std_logic;
    signal SCR_ADDR_SEL : std_logic_vector (1 downto 0);
    signal FLG_C_SET    : std_logic;
    signal FLG_C_CLR    : std_logic;
    signal FLG_C_LD     : std_logic;
    signal FLG_Z_LD     : std_logic;
    signal FLG_LD_SEL   : std_logic;
    signal FLG_SHAD_LD  : std_logic;
    signal I_SET        : std_logic;
    signal I_CLR        : std_logic;
    signal IO_STRB      : std_logic;
    signal BRANCH_TYPE  : std_logic_vector (3 downto 0);
    signal RST          : std_logic;

begin

    dut : DECODER
    port map (INT          => INT,
              RESET        => RESET,
              OPCODE_HI_5  => OPCODE_HI_5,
              OPCODE_LO_2  => OPCODE_LO_2,
              PC_LD        => PC_LD,
              PC_INC       => PC_INC,
              PC_MUX_SEL   => PC_MUX_SEL,
              SP_LD        => SP_LD,
              SP_INCR      => SP_INCR,
              SP_DECR      => SP_DECR,
              RF_WR        => RF_WR,
              RF_WR_SEL    => RF_WR_SEL,
              ALU_OPY_SEL  => ALU_OPY_SEL,
              ALU_SEL      => ALU_SEL,
              SCR_WE       => SCR_WE,
              SCR_DATA_SEL => SCR_DATA_SEL,
              SCR_ADDR_SEL => SCR_ADDR_SEL,
              FLG_C_SET    => FLG_C_SET,
              FLG_C_CLR    => FLG_C_CLR,
              FLG_C_LD     => FLG_C_LD,
              FLG_Z_LD     => FLG_Z_LD,
              FLG_LD_SEL   => FLG_LD_SEL,
              FLG_SHAD_LD  => FLG_SHAD_LD,
              I_SET        => I_SET,
              I_CLR        => I_CLR,
              IO_STRB      => IO_STRB,
              BRANCH_TYPE  => BRANCH_TYPE,
              RST          => RST);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        INT <= '0';
        OPCODE_HI_5 <= (others => '0');
        OPCODE_LO_2 <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal

        wait for 100 ns; -- none
         OPCODE_HI_5 <="00000";
         OPCODE_LO_2 <= (others => '0');
        wait for 100 ns; -- BRCC
        OPCODE_HI_5 <="00101";
        OPCODE_LO_2 <= "01";
        wait for 100 ns; -- retid
        OPCODE_HI_5 <="01101";
        OPCODE_LO_2 <= "11";
        wait for 100 ns; -- ret
        OPCODE_HI_5 <="01100";
        OPCODE_LO_2 <= "10";
        wait for 100 ns;

        -- EDIT Add stimuli here

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_DECODER of tb_DECODER is
    for tb
    end for;
end cfg_tb_DECODER;