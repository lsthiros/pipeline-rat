

----------------------------------------------------------------------------------
-- Engineer: Kyle Wuerch & Chin Chao
--
-- Module Name: SCRATCH_RAM_SIM
-- Comments: This module is designed to test the functionality of
-- the SCRATCH_RAM
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CPU_SIM IS
END CPU_SIM;

ARCHITECTURE behavior OF CPU_SIM IS 
    -- Component Declaration for the Unit Under Test (UUT)
    
    component pipeline_cpu is
        Port ( in_port    : in  STD_LOGIC_VECTOR (7 downto 0);
               rst        : in  STD_LOGIC;
               clk        : in  STD_LOGIC;
               input_interrupt     : in  STD_LOGIC;
               out_port   : out  STD_LOGIC_VECTOR (7 downto 0);
               port_id    : out  STD_LOGIC_VECTOR (7 downto 0);
               io_strb    : out  STD_LOGIC);
    end component;

   --Inputs
   signal CLK_tb         : STD_LOGIC;
   signal RST_tb         : STD_LOGIC;
   signal IN_PORT_tb     : STD_LOGIC_VECTOR(7 downto 0) := x"07";
   signal INT_IN_tb       : STD_LOGIC;

   
   --Outputs
   signal PORT_ID_tb     : STD_LOGIC_VECTOR(7 downto 0);
   signal OUT_PORT_tb    : STD_LOGIC_VECTOR(7 downto 0);
   signal IO_STRB_tb     : STD_LOGIC;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
        
uut: pipeline_cpu
    Port Map(
        in_port  => IN_PORT_tb,
        rst      => RST_tb,
        clk      => CLK_tb,
        input_interrupt   => INT_IN_tb,
        out_port => OUT_PORT_tb,
        port_id  => PORT_ID_tb,
        io_strb  => IO_STRB_tb
    );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK_tb <= '0';
		wait for CLK_period/2;
		CLK_tb <= '1';
		wait for CLK_period/2;
   end process;	
   
   -- verify memory
   VERIFY_process :process
   begin
      RST_tb <= '1';
  --    INT_IN_tb <= '0';
      wait for 10 ns;
      RST_tb <= '0';
      wait for 200 ns;    
  --    INT_IN_tb <= '1';
      wait for 30 ns;
  --    INT_IN_tb <= '0';
      wait for 100000 ns;           
   end process VERIFY_process;
END;
