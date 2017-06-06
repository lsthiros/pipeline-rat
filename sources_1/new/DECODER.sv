/* Decoder SV */

module DECODER(
  input wire RESET,
  input wire [4:0] OPCODE_HI_5,
  input wire [1:0] OPCODE_LO_2,
  control_bus dc_stage_out          // this is an output interface
);

wire [6:0] opcode = 0;
assign opcode = OPCODE_HI_5 & OPCODE_LO_2;




always_comb begin

if (RESET == 1) begin
dc_stage_out.PC_LD            <= 0 ;
dc_stage_out.PC_INC           <= 0 ;
dc_stage_out.PC_MUX_SEL       <= 0 ;
dc_stage_out.SP_LD            <= 0 ;
dc_stage_out.SP_INCR          <= 0 ;
dc_stage_out.SP_DECR          <= 0 ;
dc_stage_out.RF_WR            <= 0 ;
dc_stage_out.RF_WR_SEL        <= 0 ;
dc_stage_out.ALU_OPY_SEL      <= 0 ;
dc_stage_out.ALU_SEL          <= 0 ;
dc_stage_out.SCR_WE           <= 0 ;
dc_stage_out.SCR_DATA_SEL      <= 0 ;
dc_stage_out.SCR_ADDR_SEL      <= 0 ;
dc_stage_out.FLG_C_SET        <= 0 ;
dc_stage_out.FLG_C_CLR        <= 0 ;
dc_stage_out.FLG_C_LD         <= 0 ;
dc_stage_out.FLG_Z_LD         <= 0 ;
dc_stage_out.FLG_LD_SEL       <= 0 ;
dc_stage_out.FLG_SHAD_LD      <= 0 ;
dc_stage_out.I_SET            <= 0 ;
dc_stage_out.I_CLR            <= 0 ;
dc_stage_out.IO_STRB          <= 0 ;
dc_stage_out.BRANCH_TYPE      <= 0 ;
dc_stage_out.REG_X_READ       <= 0 ;
dc_stage_out.REG_Y_READ       <= 0 ;
end else begin

end

dc_stage_out.PC_LD            <= 0 ;
dc_stage_out.PC_INC           <= 0 ;
dc_stage_out.PC_MUX_SEL       <= 0 ;
dc_stage_out.SP_LD            <= 0 ;
dc_stage_out.SP_INCR          <= 0 ;
dc_stage_out.SP_DECR          <= 0 ;
dc_stage_out.RF_WR            <= 0 ;
dc_stage_out.RF_WR_SEL        <= 0 ;
dc_stage_out.ALU_OPY_SEL      <= 0 ;
dc_stage_out.ALU_SEL          <= 0 ;
dc_stage_out.SCR_WE           <= 0 ;
dc_stage_out.SCR_DATA_SEL      <= 0 ;
dc_stage_out.SCR_ADDR_SEL      <= 0 ;
dc_stage_out.FLG_C_SET        <= 0 ;
dc_stage_out.FLG_C_CLR        <= 0 ;
dc_stage_out.FLG_C_LD         <= 0 ;
dc_stage_out.FLG_Z_LD         <= 0 ;
dc_stage_out.FLG_LD_SEL       <= 0 ;
dc_stage_out.FLG_SHAD_LD      <= 0 ;
dc_stage_out.I_SET            <= 0 ;
dc_stage_out.I_CLR            <= 0 ;
dc_stage_out.IO_STRB          <= 0 ;
dc_stage_out.BRANCH_TYPE      <= 0 ;
dc_stage_out.REG_X_READ       <= 0 ;
dc_stage_out.REG_Y_READ       <= 0 ;

  case(opcode)
    "0000100":begin //add rr
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= 2'b00;
      dc_stage_out.ALU_SEL     <= 4'h0;
      dc_stage_out.ALU_OPY_SEL <= 0;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_LD    <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1010000" | "1010001" | "1010010" | "1010011" : begin // add RI
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= 2'b00;
      dc_stage_out.ALU_SEL     <= 4'h0;
      dc_stage_out.ALU_OPY_SEL <= 1;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_LD    <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0000101":begin // addc RR
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= 2'b00;
      dc_stage_out.ALU_SEL     <= 4'h1;
      dc_stage_out.ALU_OPY_SEL <= 0;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_LD    <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
    "1010100" | "1010101" | "1010110" | "1010111":begin // addc ri
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= 2'b00;
      dc_stage_out.ALU_SEL     <= 4'h1;
      dc_stage_out.ALU_OPY_SEL <= 1;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_LD    <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0000000":begin // and RR
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= "00";
      dc_stage_out.ALU_SEL     <= 4'h5;
      dc_stage_out.ALU_OPY_SEL <= 0;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_CLR   <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1000000" | "1000001" | "1000010" | "1000011": begin // and ri
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= "00";
      dc_stage_out.ALU_SEL     <= 4'h5;
      dc_stage_out.ALU_OPY_SEL <= 1;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_CLR   <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0100100": begin //=> -- ASR
      dc_stage_out.RF_WR       <= 1;
      dc_stage_out.RF_WR_SEL   <= "00";
      dc_stage_out.ALU_SEL     <= 4'hE;
      dc_stage_out.FLG_LD_SEL  <= 0;
      dc_stage_out.FLG_C_LD    <= 1;
      dc_stage_out.FLG_Z_LD    <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0010101" : begin // BRCC
      dc_stage_out.BRANCH_TYPE <= 4'h1;
    end
    "0010100" : begin// -- BRCS
      dc_stage_out.BRANCH_TYPE <= 4'h2;
    end
    "0010010"  : begin // -- BREQ
      dc_stage_out.BRANCH_TYPE <= 4'h3;
    end
    "0010000" : begin //-- BRN
      dc_stage_out.BRANCH_TYPE <= 4'h4;
    end
    "0010011" : begin//=> -- BRNE
      dc_stage_out.BRANCH_TYPE <= 4'h5;
    end
    "0010001" : begin // => -- CALL
      dc_stage_out.BRANCH_TYPE <= 4'h6;
      dc_stage_out.SP_LD        <= 0;
      dc_stage_out.SP_INCR      <= 0;
      dc_stage_out.SP_DECR      <= 1;
      dc_stage_out.SCR_WE       <= 1;
      dc_stage_out.SCR_ADDR_SEL <= "11";
      dc_stage_out.SCR_DATA_SEL <= 1;
    end
    "0110000" : dc_stage_out.FLG_C_CLR    <= 1; // clc
    "0110101" : dc_stage_out.I_CLR        <= 1;//=> -- CLI

    "0001000" : begin//=> -- CMP RR
      dc_stage_out.RF_WR        <= 0;
      dc_stage_out.ALU_SEL      <= "0100";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1100000" | "1100001" | "1100010" | "1100011" : begin // => -- CMP RI
      dc_stage_out.RF_WR        <= 0;
      dc_stage_out.ALU_SEL      <= "0100";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0000010" : begin //=> -- EXOR RR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0111";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
   "1001000" | "1001001" | "1001010" | "1001011" : begin// => -- EXOR RI
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0111";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "1100100" | "1100101" | "1100110" | "1100111" : begin //=> -- IN
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "11";
      dc_stage_out.REG_X_READ <= 0;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0001010" : begin //=> -- LD RR
      dc_stage_out.SCR_WE       <= 0;
      dc_stage_out.SCR_ADDR_SEL <= "00";
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "01";
      dc_stage_out.REG_X_READ <= 0;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1110000" | "1110001" | "1110010" | "1110011" : begin //=> -- LD RI
      dc_stage_out.SCR_WE       <= 0;
      dc_stage_out.SCR_ADDR_SEL <= "01";
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "01";
      dc_stage_out.REG_X_READ <= 0;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0100000" : begin //=> -- LSL
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "1001";
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
   end
    "0100001" : begin //=> -- LSR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "1010";
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
     end
    "0001001" : begin //=> -- MOV RR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.ALU_SEL      <= "1110";
      dc_stage_out.REG_X_READ <= 0;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1101100" | "1101101" | "1101110" | "1101111" : begin // => -- MOV RI
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.ALU_SEL      <= "1110";
      dc_stage_out.REG_X_READ <= 0;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0000001" : begin //=> -- OR RR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0110";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end

    "1000100" | "1000101" | "1000110" | "1000111" : begin //=> -- OR RI
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0110";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "1101000" | "1101001" | "1101010" | "1101011" : begin // => -- OUT
      dc_stage_out.RF_WR        <= 0;
      dc_stage_out.IO_STRB      <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0100110" : begin //=> -- POP
      dc_stage_out.SP_INCR      <= 1;
      dc_stage_out.SCR_WE       <= 0;
      dc_stage_out.SCR_ADDR_SEL <= "10";
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "01";
    end

    "0100101" : begin //=> -- PUSH
      dc_stage_out.SP_DECR      <= 1;
      dc_stage_out.SCR_WE       <= 1;
      dc_stage_out.SCR_ADDR_SEL <= "11";
      dc_stage_out.SCR_DATA_SEL <= 0;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0110010" : begin //=> -- RET
      dc_stage_out.BRANCH_TYPE <= 4'h7;
      dc_stage_out.SP_INCR      <= 1;
      dc_stage_out.SCR_WE       <= 0;
      dc_stage_out.SCR_ADDR_SEL <= "10";
      dc_stage_out.PC_MUX_SEL   <= "01";
    end

    "0110110" : begin //=> -- RETID
      dc_stage_out.BRANCH_TYPE <= 4'h8;
      dc_stage_out.SCR_ADDR_SEL <= "10";
      dc_stage_out.SP_INCR      <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_LD_SEL   <= 1;
      dc_stage_out.I_CLR        <= 1;
      dc_stage_out.PC_MUX_SEL   <= "01";
    end

    "0110111" : begin //=> -- RETIE
      dc_stage_out.BRANCH_TYPE <= 4'h9;
      dc_stage_out.SCR_ADDR_SEL <= "10";
      dc_stage_out.SP_INCR      <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_LD_SEL   <= 1;
      dc_stage_out.I_SET        <= 1;
      dc_stage_out.PC_MUX_SEL   <= "01";
    end

    "0100010" : begin //=> -- ROL
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "1011";
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    "0100011" : begin //=> -- ROR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "1100";
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0110001" : begin //=> -- SEC
      dc_stage_out.FLG_C_SET    <= 1;
    end
    "0110100" : begin //=> -- SEI
      dc_stage_out.I_SET        <= 1;
    end
    "0001011" : begin //=> -- ST RR
      dc_stage_out.SCR_DATA_SEL <= 0;
      dc_stage_out.SCR_WE       <= 1;
      dc_stage_out.SCR_ADDR_SEL <= "00";
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
    "1110100" | "1110101" | "1110110" | "1110111" : begin //=> -- ST RI
      dc_stage_out.SCR_DATA_SEL <= 0;
      dc_stage_out.SCR_WE       <= 1;
      dc_stage_out.SCR_ADDR_SEL <= "01";
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0000110" : begin //=> -- SUB RR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0010";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
    "1011000"| "1011001" | "1011010" | "1011011" : begin //=> -- SUB RI
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0010";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0000111" : begin //=> -- SUBC RR
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0011";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
    "1011100" | "1011101" | "1011110" | "1011111" : begin //=> -- SUBC RI
      dc_stage_out.RF_WR        <= 1;
      dc_stage_out.RF_WR_SEL    <= "00";
      dc_stage_out.ALU_SEL      <= "0011";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_LD     <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0000011" : begin //=> -- TEST RR
      dc_stage_out.RF_WR        <= 0;
      dc_stage_out.ALU_SEL      <= "1000";
      dc_stage_out.ALU_OPY_SEL  <= 0;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 1;
    end
    "1001100" | "1001101" | "1001110" | "1001111" : begin // => -- TEST RI
      dc_stage_out.RF_WR        <= 0;
      dc_stage_out.ALU_SEL      <= "1000";
      dc_stage_out.ALU_OPY_SEL  <= 1;
      dc_stage_out.FLG_LD_SEL   <= 0;
      dc_stage_out.FLG_C_CLR    <= 1;
      dc_stage_out.FLG_Z_LD     <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end
    "0101000" : begin //=> -- WSP
      dc_stage_out.SP_LD        <= 1;
      dc_stage_out.REG_X_READ <= 1;
      dc_stage_out.REG_Y_READ <= 0;
    end

    default : begin
      dc_stage_out.PC_LD            <= 0 ;
      dc_stage_out.PC_INC           <= 0 ;
      dc_stage_out.PC_MUX_SEL       <= 0 ;
      dc_stage_out.SP_LD            <= 0 ;
      dc_stage_out.SP_INCR          <= 0 ;
      dc_stage_out.SP_DECR          <= 0 ;
      dc_stage_out.RF_WR            <= 0 ;
      dc_stage_out.RF_WR_SEL        <= 0 ;
      dc_stage_out.ALU_OPY_SEL      <= 0 ;
      dc_stage_out.ALU_SEL          <= 0 ;
      dc_stage_out.SCR_WE           <= 0 ;
      dc_stage_out.SCR_DATA_SEL      <= 0 ;
      dc_stage_out.SCR_ADDR_SEL      <= 0 ;
      dc_stage_out.FLG_C_SET        <= 0 ;
      dc_stage_out.FLG_C_CLR        <= 0 ;
      dc_stage_out.FLG_C_LD         <= 0 ;
      dc_stage_out.FLG_Z_LD         <= 0 ;
      dc_stage_out.FLG_LD_SEL       <= 0 ;
      dc_stage_out.FLG_SHAD_LD      <= 0 ;
      dc_stage_out.I_SET            <= 0 ;
      dc_stage_out.I_CLR            <= 0 ;
      dc_stage_out.IO_STRB          <= 0 ;
      dc_stage_out.BRANCH_TYPE      <= 0 ;
      dc_stage_out.REG_X_READ       <= 0 ;
      dc_stage_out.REG_Y_READ       <= 0 ;

    end // end defualt
  endcase // case end
end





  endmodule
