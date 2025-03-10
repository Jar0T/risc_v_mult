----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:24:21 01/12/2025 
-- Design Name: 
-- Module Name:    DECODER - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.constants.all;

entity DECODER is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_valid : in std_logic;
        i_instruction : in std_logic_vector (31 downto 0);
        o_instruction : out std_logic_vector (31 downto 0);
        o_sel_a : out std_logic_vector (4 downto 0) := "00000";
        o_sel_b : out std_logic_vector (4 downto 0) := "00000";
        o_sel_d : out std_logic_vector (4 downto 0) := "00000";
        o_funct3 : out std_logic_vector (2 downto 0) := "000";
        o_funct7 : out std_logic_vector (6 downto 0) := "0000000";
        o_instr_type : out std_logic_vector (2 downto 0) := "000";
        o_mem_en : out std_logic := '0';
        o_mem_we : out std_logic := '0';
        o_write_back : out std_logic := '0';
        o_is_imm : out std_logic := '0';
        o_wb_source : out std_logic_vector (2 downto 0) := "000";
        o_branch : out std_logic := '0';
        o_jal : out std_logic := '0';
        o_jalr : out std_logic := '0';
        o_csr_addr : out std_logic_vector(11 downto 0) := X"000";
        o_csr_opcode : out std_logic_vector(3 downto 0) := "0000";
        o_ecall : out std_logic := '0';
        o_mret : out std_logic := '0';
        o_illegal_instr : out std_logic := '0'
    );
end DECODER;

architecture Behavioral of DECODER is

begin

    process(i_clk, i_en, i_valid)
    begin
        if rising_edge(i_clk) and i_en = '1' and i_valid = '1' then
            o_instruction <= i_instruction;
            o_mem_en <= '0';
            o_mem_we <= '0';
            o_instr_type <= TYPE_R;
            o_is_imm <= '0';
            o_write_back <= '0';
            o_wb_source <= "000";
            o_branch <= '0';
            o_jal <= '0';
            o_jalr <= '0';
            o_csr_opcode <= "0000";
            o_csr_addr <= X"000";
            o_ecall <= '0';
            o_mret <= '0';
            o_illegal_instr <= '0';
            
            case i_instruction(6 downto 2) is
                when OPCODE_OPIMM =>
                    o_instr_type <= TYPE_I;
                    o_is_imm <= '1';
                    o_write_back <= '1';
                    o_wb_source <= WB_ALU;
                
                when OPCODE_OP =>
                    o_instr_type <= TYPE_R;
                    o_write_back <= '1';
                    o_wb_source <= WB_ALU;
                
                when OPCODE_LUI =>
                    o_instr_type <= TYPE_U;
                    o_write_back <= '1';
                    o_wb_source <= WB_IMM;
                
                when OPCODE_AUIPC =>
                    o_instr_type <= TYPE_U;
                    o_write_back <= '1';
                    o_wb_source <= WB_PCIMM;
                
                when OPCODE_JAL =>
                    o_instr_type <= TYPE_J;
                    o_write_back <= '1';
                    o_wb_source <= WB_PC4;
                    o_jal <= '1';
                
                when OPCODE_JALR =>
                    o_instr_type <= TYPE_I;
                    o_write_back <= '1';
                    o_wb_source <= WB_PC4;
                    o_jalr <= '1';
                    
                when OPCODE_BRANCH =>
                    o_instr_type <= TYPE_B;
                    o_branch <= '1';
                
                when OPCODE_LOAD =>
                    o_instr_type <= TYPE_I;
                    o_mem_en <= '1';
                    o_write_back <= '1';
                    o_wb_source <= WB_MEM;
                
                when OPCODE_STORE =>
                    o_instr_type <= TYPE_S;
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                
                when OPCODE_MISCMEM =>
                    o_instr_type <= TYPE_R;
                
                when OPCODE_SYSTEM =>
                    o_instr_type <= TYPE_O;
                    o_csr_addr <= i_instruction(31 downto 20);
                    case i_instruction(14 downto 12) is
                        when "000" =>
                            o_csr_opcode <= "0000";
                            if i_instruction(31 downto 20) = X"000" then
                                o_ecall <= '1';
                            elsif i_instruction(31 downto 20) = X"302" then
                                o_mret <= '1';
                            end if;
                        when "001" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(11 downto 7) = "00000" then
                                o_csr_opcode <= "0100";
                            else
                                o_csr_opcode <= "1100";
                            end if;
                        when "010" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(19 downto 15) = "00000" then
                                o_csr_opcode <= "1000";
                            else
                                o_csr_opcode <= "1010";
                            end if;
                        when "011" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(19 downto 15) = "00000" then
                                o_csr_opcode <= "1000";
                            else
                                o_csr_opcode <= "1001";
                            end if;
                        when "101" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(11 downto 7) = "00000" then
                                o_csr_opcode <= "0100";
                            else
                                o_csr_opcode <= "1100";
                            end if;
                        when "110" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(19 downto 15) = "00000" then
                                o_csr_opcode <= "1000";
                            else
                                o_csr_opcode <= "1010";
                            end if;
                        when "111" =>
                            o_write_back <= '1';
                            o_wb_source <= WB_CSR;
                            if i_instruction(19 downto 15) = "00000" then
                                o_csr_opcode <= "1000";
                            else
                                o_csr_opcode <= "1001";
                            end if;
                        when others =>
                    end case;
                    o_is_imm <= i_instruction(14);
                
                when others =>
                    o_illegal_instr <= '1';
            end case;
            
            if i_instruction(1 downto 0) /= "11" then
                o_illegal_instr <= '1';
            end if;
            
            o_funct3 <= i_instruction(14 downto 12);
            o_funct7 <= i_instruction(31 downto 25);
    
            o_sel_a <= i_instruction(19 downto 15);
            o_sel_b <= i_instruction(24 downto 20);
            o_sel_d <= i_instruction(11 downto 7);
        end if;
    end process;

end Behavioral;

