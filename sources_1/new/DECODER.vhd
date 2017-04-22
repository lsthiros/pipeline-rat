----------------------------------------------------------------------------------
-- Module Name: Decoder
-- Engineers: Chris Gerdom
-- Comments: This module decodes the control signals from the instructions
-- branches and instructions that use pc counter are forwareded to the 
-- branch table
-- hex val	branch option
-- 0 none
-- 1 BRCC
-- 2 BRCS
-- 3 BREQ
-- 4 BRN
-- 5 BRNE
-- 6 CALL
-- 7 RET
-- 8 RETID
-- 9 RETIE
-- A
-- B 
-- C 
-- D 
-- E
-- F 



----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER is
    Port ( 
           INT           : in   STD_LOGIC;
           RESET         : in   STD_LOGIC;
           OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
           
           PC_LD         : out  STD_LOGIC;
           PC_INC        : out  STD_LOGIC;		  
           PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           
           SP_LD         : out  STD_LOGIC;
           SP_INCR       : out  STD_LOGIC;
           SP_DECR       : out  STD_LOGIC;
              
           RF_WR         : out  STD_LOGIC;
           RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
           
           ALU_OPY_SEL   : out  STD_LOGIC;
           ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
           
           SCR_WE        : out  STD_LOGIC;
           SCR_DATA_SEL  : out  STD_LOGIC;
           SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
           
           FLG_C_SET     : out  STD_LOGIC;
           FLG_C_CLR     : out  STD_LOGIC;
           FLG_C_LD      : out  STD_LOGIC;
           FLG_Z_LD      : out  STD_LOGIC;
           FLG_LD_SEL    : out  STD_LOGIC;
           FLG_SHAD_LD   : out  STD_LOGIC;
              
           I_SET         : out  STD_LOGIC;
           I_CLR         : out  STD_LOGIC;
           IO_STRB       : out  STD_LOGIC;
           BRANCH_TYPE   : out  STD_LOGIC_VECTOR (3 downto 0);
           
           REG_X_READ	 : out 	STD_LOGIC;
		   REG_Y_READ	 : out 	STD_LOGIC;
		   
           RST           : out  STD_LOGIC);
end DECODER;

architecture Behavioral of DECODER is
TYPE state_type is (ST_FETCH, ST_EXEC, ST_INIT, ST_INT);
signal PS, NS : state_type;

signal op : STD_LOGIC_VECTOR(6 downto 0);

begin

op <= OPCODE_HI_5 & OPCODE_LO_2;

comb_proc: process(op, PS, NS, INT)
    begin
PC_INC        <= '0';   PC_MUX_SEL    <= "00";   PC_LD       <= '0';
SP_LD         <= '0';   SP_INCR       <= '0';    SP_DECR     <= '0';
RF_WR         <= '0';   RF_WR_SEL     <= "00";
ALU_OPY_SEL   <= '0';   ALU_SEL       <= x"0";
SCR_WE        <= '0';   SCR_ADDR_SEL  <= "00";  SCR_DATA_SEL  <= '0';
FLG_C_SET     <= '0';   FLG_C_LD      <= '0';   FLG_C_CLR     <= '0';
FLG_Z_LD      <= '0';   FLG_LD_SEL    <= '0';   FLG_SHAD_LD   <= '0';
I_SET         <= '0';   I_CLR         <= '0';   IO_STRB       <= '0';
RST           <= '0';
BRANCH_TYPE <= x"0";
REG_X_READ <= '0';
REG_Y_READ <= '0';

case op is
	when "0000100" => -- ADD RR
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"0";
		ALU_OPY_SEL <= '0';
		FLG_LD_SEL  <= '0';
		FLG_C_LD    <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';

	when "1010000" | "1010001" | "1010010" | "1010011" => -- ADD RI
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"0";
		ALU_OPY_SEL <= '1';
		FLG_LD_SEL  <= '0';
		FLG_C_LD    <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';		
	when "0000101" => -- ADDC RR
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"1";
		ALU_OPY_SEL <= '0';
		FLG_LD_SEL  <= '0';
		FLG_C_LD    <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';		
	when "1010100" | "1010101" | "1010110" | "1010111" => -- ADDC RI
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"1";
		ALU_OPY_SEL <= '1';
		FLG_LD_SEL  <= '0';
		FLG_C_LD    <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';		
	when "0000000" => -- AND RR
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"5";
		ALU_OPY_SEL <= '0';
		FLG_LD_SEL  <= '0';
		FLG_C_CLR   <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';		
	when "1000000" | "1000001" | "1000010" | "1000011" => -- AND RI
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"5";
		ALU_OPY_SEL <= '1';
		FLG_LD_SEL  <= '0';
		FLG_C_CLR   <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';		
	when "0100100" => -- ASR
		RF_WR       <= '1';
		RF_WR_SEL   <= "00";
		ALU_SEL     <= x"E";
		FLG_LD_SEL  <= '0';
		FLG_C_LD    <= '1';
		FLG_Z_LD    <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0010101" => -- BRCC
		BRANCH_TYPE <= x"1";
	when "0010100" => -- BRCS
		BRANCH_TYPE <= x"2";
	when "0010010" => -- BREQ
		BRANCH_TYPE <= x"3";
	when "0010000" => -- BRN
		BRANCH_TYPE <= x"4";
	when "0010011" => -- BRNE
		BRANCH_TYPE <= x"5";
	when "0010001" => -- CALL
		BRANCH_TYPE <= x"6";
		SP_LD        <= '0';
		SP_INCR      <= '0';
		SP_DECR      <= '1';
		SCR_WE       <= '1';
		SCR_ADDR_SEL <= "11";
		SCR_DATA_SEL <= '1';
	when "0110000" => -- CLC
		FLG_C_CLR    <= '1';
	when "0110101" => -- CLI
		I_CLR        <= '1';
	when "0001000" => -- CMP RR
		RF_WR        <= '0';
		ALU_SEL      <= "0100";
		ALU_OPY_SEL  <= '0';
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1100000" | "1100001" | "1100010" | "1100011" => -- CMP RI
		RF_WR        <= '0';
		ALU_SEL      <= "0100";
		ALU_OPY_SEL  <= '1';
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0000010" => -- EXOR RR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0111";
		ALU_OPY_SEL  <= '0';
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1001000" | "1001001" | "1001010" | "1001011" => -- EXOR RI
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0111";
		ALU_OPY_SEL  <= '1';  
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
		
	when "1100100" | "1100101" | "1100110" | "1100111" => -- IN
		RF_WR        <= '1';
		RF_WR_SEL    <= "11";
		REG_X_READ <= '0';
		REG_Y_READ <= '0';
	when "0001010" => -- LD RR
		SCR_WE       <= '0';
		SCR_ADDR_SEL <= "00";
		RF_WR        <= '1';
		RF_WR_SEL    <= "01";
		REG_X_READ <= '1';
		REG_Y_READ <= '1';		
	when "1110000" | "1110001" | "1110010" | "1110011" => -- LD RI    
		SCR_WE       <= '0';
		SCR_ADDR_SEL <= "01";
		RF_WR        <= '1';
		RF_WR_SEL    <= "01";
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
		
	when "0100000" => -- LSL
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "1001";
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0100001" => -- LSR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "1010";
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0001001" => -- MOV RR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_OPY_SEL  <= '0';
		ALU_SEL      <= "1110";
		REG_X_READ <= '0';
		REG_Y_READ <= '1';
	when "1101100" | "1101101" | "1101110" | "1101111" => -- MOV RI
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_OPY_SEL  <= '1';
		ALU_SEL      <= "1110";
		REG_X_READ <= '0';
		REG_Y_READ <= '0';
	when "0000001" => -- OR RR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0110";
		ALU_OPY_SEL  <= '0';  
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1000100" | "1000101" | "1000110" | "1000111" => -- OR RI
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0110";
		ALU_OPY_SEL  <= '1';  
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "1101000" | "1101001" | "1101010" | "1101011" => -- OUT
		RF_WR        <= '0';
		IO_STRB      <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0100110" => -- POP
		SP_INCR      <= '1';
		SCR_WE       <= '0';
		SCR_ADDR_SEL <= "10";
		RF_WR        <= '1';
		RF_WR_SEL    <= "01";
		
	when "0100101" => -- PUSH
		SP_DECR      <= '1';
		SCR_WE       <= '1';
		SCR_ADDR_SEL <= "11";
		SCR_DATA_SEL <= '0';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0110010" => -- RET
		BRANCH_TYPE <= x"7";
		SP_INCR      <= '1';
		SCR_WE       <= '0';
		SCR_ADDR_SEL <= "10";
	when "0110110" => -- RETID
		BRANCH_TYPE <= x"8";
		SCR_ADDR_SEL <= "10";
		SP_INCR      <= '1';
		FLG_Z_LD     <= '1';
		FLG_C_LD     <= '1';
		FLG_LD_SEL   <= '1';
		I_CLR        <= '1';
	when "0110111" => -- RETIE
		BRANCH_TYPE <= x"9";
		SCR_ADDR_SEL <= "10";
		SP_INCR      <= '1';
		FLG_Z_LD     <= '1';
		FLG_C_LD     <= '1';
		FLG_LD_SEL   <= '1';
		I_SET        <= '1';
	when "0100010" => -- ROL
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "1011";
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0100011" => -- ROR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "1100";
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0110001" => -- SEC
		FLG_C_SET    <= '1';
	when "0110100" => -- SEI
		I_SET        <= '1';
	when "0001011" => -- ST RR
		SCR_DATA_SEL <= '0';
		SCR_WE       <= '1';
		SCR_ADDR_SEL <= "00";
		REG_X_READ <= '0';
		REG_Y_READ <= '1';
	when "1110100" | "1110101" | "1110110" | "1110111" => -- ST RI
		SCR_DATA_SEL <= '0';
		SCR_WE       <= '1';
		SCR_ADDR_SEL <= "01"; 
		REG_X_READ <= '0';
		REG_Y_READ <= '0';
	when "0000110" => -- SUB RR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0010";
		ALU_OPY_SEL  <= '0';  
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1011000" | "1011001" | "1011010" | "1011011" => -- SUB RI
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0010";
		ALU_OPY_SEL  <= '1';  
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0000111" => -- SUBC RR
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0011";
		ALU_OPY_SEL  <= '0';  
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1011100" | "1011101" | "1011110" | "1011111" => -- SUBC RI
		RF_WR        <= '1';
		RF_WR_SEL    <= "00";
		ALU_SEL      <= "0011";
		ALU_OPY_SEL  <= '1';  
		FLG_LD_SEL   <= '0';
		FLG_C_LD     <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0000011" => -- TEST RR
		RF_WR        <= '0';
		ALU_SEL      <= "1000";
		ALU_OPY_SEL  <= '0';  
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '1';
	when "1001100" | "1001101" | "1001110" | "1001111" => -- TEST RI
		RF_WR        <= '0';
		ALU_SEL      <= "1000";
		ALU_OPY_SEL  <= '1';  
		FLG_LD_SEL   <= '0';
		FLG_C_CLR    <= '1';
		FLG_Z_LD     <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when "0101000" => -- WSP
		SP_LD        <= '1';
		REG_X_READ <= '1';
		REG_Y_READ <= '0';
	when others =>
		PC_INC        <= '0';   PC_MUX_SEL    <= "00";   PC_LD       <= '0';
		SP_LD         <= '0';   SP_INCR       <= '0';    SP_DECR     <= '0';
		RF_WR         <= '0';   RF_WR_SEL     <= "00";
		ALU_OPY_SEL   <= '0';   ALU_SEL       <= x"0";
		SCR_WE        <= '0';   SCR_ADDR_SEL  <= "00";  SCR_DATA_SEL  <= '0';
		FLG_C_SET     <= '0';   FLG_C_LD      <= '0';   FLG_C_CLR     <= '0';
		FLG_Z_LD      <= '0';   FLG_LD_SEL    <= '0';   FLG_SHAD_LD   <= '0';
		I_SET         <= '0';   I_CLR         <= '0';   IO_STRB       <= '0';
		RST           <= '0';   BRANCH_TYPE   <= x"0";
        end case;
    end process comb_proc;
end Behavioral;
