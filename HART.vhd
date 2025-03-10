----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:22 01/14/2025 
-- Design Name: 
-- Module Name:    HART - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.constants.all;

entity HART is
    Port (
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        o_mem_en : out std_logic;
        o_mem_we : out std_logic_vector(3 downto 0) := "0000";
        o_mem_addr : out std_logic_vector(31 downto 0);
        o_mem_data : out std_logic_vector(31 downto 0);
        i_mem_data : in std_logic_vector(31 downto 0);
        i_mem_valid : in std_logic;
        i_ext_int : in std_logic;
        i_ext_tval : in std_logic_vector(31 downto 0);
        i_tim_int : in std_logic;
        i_tim_tval : in std_logic_vector(31 downto 0)
    );
end HART;

architecture Behavioral of HART is

    component CONTROL_UNIT
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_mem_en : in std_logic;
        i_mem_we : in std_logic;
        i_mem_valid : in std_logic;
        o_fetch : out std_logic;
        o_decode : out std_logic;
        o_reg_read : out std_logic;
        o_execute : out std_logic;
        o_store : out std_logic;
        o_mem : out std_logic;
        o_load : out std_logic;
        o_write_back : out std_logic
        );
    end component;
    
    component DECODER
	Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_valid : in std_logic;
        i_instruction : in std_logic_vector(31 downto 0);
        o_instruction : out std_logic_vector(31 downto 0);
        o_sel_a : out std_logic_vector(4 downto 0);
        o_sel_b : out std_logic_vector(4 downto 0);
        o_sel_d : out std_logic_vector(4 downto 0);
        o_funct3 : out std_logic_vector(2 downto 0);
        o_funct7 : out std_logic_vector(6 downto 0);
        o_instr_type : out std_logic_vector(2 downto 0);
        o_mem_en : out std_logic;
        o_mem_we : out std_logic;
        o_write_back : out std_logic;
        o_is_imm : out std_logic;
        o_wb_source : out std_logic_vector(2 downto 0);
        o_branch : out std_logic;
        o_jal : out std_logic;
        o_jalr : out std_logic;
        o_csr_addr : out std_logic_vector(11 downto 0);
        o_csr_opcode : out std_logic_vector(3 downto 0);
        o_ecall : out std_logic;
        o_mret : out std_logic;
        o_illegal_instr : out std_logic
        );
    end component;
    
    component REGISTER_FILE
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic;
        i_sel_a : in integer range 0 to 31;
        i_sel_b : in integer range 0 to 31;
        i_sel_d : in integer range 0 to 31;
        i_d : in std_logic_vector(31 downto 0);          
        o_da : out std_logic_vector(31 downto 0);
        o_db : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component IMM_DECODER
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_instruction : in std_logic_vector(24 downto 0);
        i_instr_type : in std_logic_vector(2 downto 0);          
        o_imm : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component ALU
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_a : in std_logic_vector(31 downto 0);
        i_b : in std_logic_vector(31 downto 0);
        i_imm : in std_logic_vector(31 downto 0);
        i_funct3 : in std_logic_vector(2 downto 0);
        i_funct7 : in std_logic_vector(6 downto 0);
        i_is_imm : in std_logic;          
        o_y : out std_logic_vector(31 downto 0);
        o_should_branch : out std_logic
        );
    end component;
    
    component MISC_ADDER
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_a : in std_logic_vector(31 downto 0);
        i_imm : in std_logic_vector(31 downto 0);
        i_pc : in std_logic_vector(31 downto 0);          
        o_a_imm : out std_logic_vector(31 downto 0);
        o_pc_imm : out std_logic_vector(31 downto 0);
        o_pc_4 : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component STORE_DECODER
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_data : in std_logic_vector(31 downto 0);
        i_addr : in std_logic_vector(1 downto 0);
        i_we : in std_logic;
        i_funct3 : in std_logic_vector(2 downto 0);          
        o_data : out std_logic_vector(31 downto 0);
        o_we : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component LOAD_DECODER
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_data : in std_logic_vector(31 downto 0);
        i_addr : in std_logic_vector(1 downto 0);
        i_funct3 : in std_logic_vector(2 downto 0);          
        o_data : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component PROGRAM_COUNTER
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_should_branch : in std_logic;
        i_branch : in std_logic;
        i_jal : in std_logic;
        i_jalr : in std_logic;
        i_int : in std_logic;
        i_exc : in std_logic;
        i_reti : in std_logic;
        i_pc_4 : in std_logic_vector(31 downto 0);
        i_pc_imm : in std_logic_vector(31 downto 0);
        i_a_imm : in std_logic_vector(31 downto 0);
        i_int_addr : in std_logic_vector (31 downto 0);
        i_reti_addr : in std_logic_vector (31 downto 0);
        o_pc : out std_logic_vector(31 downto 0);
        o_next_pc : out std_logic_vector (31 downto 0)
        );
    end component;
    
    component CSR_FILE
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_opcode : in std_logic_vector(3 downto 0);
        i_csr_addr : in std_logic_vector(11 downto 0);
        i_csr_data : in std_logic_vector(31 downto 0);
        i_csr_imm : in std_logic_vector(31 downto 0);
        i_is_imm : in std_logic;
        i_instret : in std_logic;
        i_ext_int : in std_logic;
        i_tim_int : in std_logic;
        i_int_cause : in std_logic_vector(31 downto 0);
        i_int_pc : in std_logic_vector(31 downto 0);
        i_int_tval : in std_logic_vector(31 downto 0);
        i_int : in std_logic;
        i_int_ret : in std_logic;          
        o_csr_data : out std_logic_vector(31 downto 0);
        o_int_en : out std_logic;
        o_ext_ie : out std_logic;
        o_tim_ie : out std_logic;
        o_tvec : out std_logic_vector(31 downto 0);
        o_epc : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component INTERRUPT_CONTROLLER
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_exc : in std_logic;
        i_exc_cause : in std_logic_vector(31 downto 0);
        i_exc_tval : in std_logic_vector(31 downto 0);
        i_ext_int : in std_logic;
        i_ext_tval : in std_logic_vector(31 downto 0);
        i_tim_int : in std_logic;
        i_tim_tval : in std_logic_vector(31 downto 0);
        i_gie : in std_logic;
        i_ext_ie : in std_logic;
        i_tim_ie : in std_logic;
        i_tvec : in std_logic_vector(31 downto 0);
        i_pc : in std_logic_vector(31 downto 0);
        i_next_pc : in std_logic_vector(31 downto 0);          
        o_int : out std_logic;
        o_addr : out std_logic_vector(31 downto 0);
        o_cause : out std_logic_vector(31 downto 0);
        o_tval : out std_logic_vector(31 downto 0);
        o_exc : out std_logic;
        o_pc : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component EXCEPTION_UNIT
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_fetch_misaligned : in std_logic;
        i_fetch_fault : in std_logic;
        i_illegal_instr : in std_logic;
        i_load_misaligned : in std_logic;
        i_load_fault : in std_logic;
        i_store_misaligned : in std_logic;
        i_store_fault : in std_logic;
        i_ecall : in std_logic;
        i_instr : in std_logic_vector(31 downto 0);
        i_instr_addr : in std_logic_vector(31 downto 0);
        i_data_addr : in std_logic_vector(31 downto 0);          
        o_exc : out std_logic;
        o_cause : out std_logic_vector(31 downto 0);
        o_tval : out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal s_fetch_stage : std_logic := '0';
    signal s_decode_stage : std_logic := '0';
    signal s_reg_read_stage : std_logic := '0';
    signal s_execute_stage : std_logic := '0';
    signal s_store_stage : std_logic := '0';
    signal s_mem_stage : std_logic := '0';
    signal s_load_stage : std_logic := '0';
    signal s_write_back_stage : std_logic := '0';
    
    signal s_instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal s_sel_a : std_logic_vector(4 downto 0) := (others => '0');
    signal s_sel_b : std_logic_vector(4 downto 0) := (others => '0');
    signal s_sel_d : std_logic_vector(4 downto 0) := (others => '0');
    signal s_funct3 : std_logic_vector(2 downto 0) := (others => '0');
    signal s_funct7 : std_logic_vector(6 downto 0) := (others => '0');
    signal s_instr_type : std_logic_vector(2 downto 0) := (others => '0');
    signal s_mem_en : std_logic := '0';
    signal s_mem_we : std_logic := '0';
    signal s_write_back : std_logic := '0';
    signal s_is_imm : std_logic := '0';
    signal s_wb_source : std_logic_vector(2 downto 0) := (others => '0');
    signal s_branch : std_logic := '0';
    signal s_jal : std_logic := '0';
    signal s_jalr : std_logic := '0';
    signal s_ecall : std_logic := '0';
    signal s_illegal_instr : std_logic := '0';
    
    signal s_reg_file_en : std_logic := '0';
    signal s_wb_en : std_logic := '0';
    signal s_data_a : std_logic_vector(31 downto 0) := (others => '0');
    signal s_data_b : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_imm : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_alu_result : std_logic_vector(31 downto 0) := (others => '0');
    signal s_should_branch : std_logic := '0';

    signal s_a_imm : std_logic_vector(31 downto 0) := (others => '0');
    signal s_pc_imm : std_logic_vector(31 downto 0) := (others => '0');
    signal s_pc_4 : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_mem_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_mem_we_byte : std_logic_vector(3 downto 0) := (others => '0');
    
    signal s_wb_mem_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_pc, s_next_pc : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_wb_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_csr_addr : std_logic_vector(11 downto 0) := (others => '0');
    signal s_csr_opcode : std_logic_vector(3 downto 0) := (others => '0');
    signal s_csr_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_tvec : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_epc : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_int_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_int_pc : std_logic_vector(31 downto 0) := (others => '0');
    signal s_int_cause : std_logic_vector(31 downto 0) := (others => '0');
    signal s_int_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal s_gie, s_ext_ie, s_tim_ie : std_logic := '0';
    signal s_int, s_exc, s_mret : std_logic := '0';
    
    signal s_exc_trig : std_logic := '0';
    signal s_exc_cause : std_logic_vector(31 downto 0) := (others => '0');
    signal s_exc_tval : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_ext_trig, s_tim_trig : std_logic := '0';
    signal s_ext_tval, s_tim_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal s_ext_ack, s_tim_ack : std_logic := '0';

begin
    
    Inst_CONTROL_UNIT: CONTROL_UNIT Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_mem_en => s_mem_en,
        i_mem_we => s_mem_we,
        i_mem_valid => i_mem_valid,
        o_fetch => s_fetch_stage,
        o_decode => s_decode_stage,
        o_reg_read => s_reg_read_stage,
        o_execute => s_execute_stage,
        o_store => s_store_stage,
        o_mem => s_mem_stage,
        o_load => s_load_stage,
        o_write_back => s_write_back_stage
	);
    
    Inst_DECODER: DECODER Port map(
        i_clk => i_clk,
        i_en => s_decode_stage,
        i_valid => i_mem_valid,
        i_instruction => i_mem_data,
        o_instruction => s_instruction,
        o_sel_a => s_sel_a,
        o_sel_b => s_sel_b,
        o_sel_d => s_sel_d,
        o_funct3 => s_funct3,
        o_funct7 => s_funct7,
        o_instr_type => s_instr_type,
        o_mem_en => s_mem_en,
        o_mem_we => s_mem_we,
        o_write_back => s_write_back,
        o_is_imm => s_is_imm,
        o_wb_source => s_wb_source,
        o_branch => s_branch,
        o_jal => s_jal,
        o_jalr => s_jalr,
        o_csr_addr => s_csr_addr,
        o_csr_opcode => s_csr_opcode,
        o_ecall => s_ecall,
        o_mret => s_mret,
        o_illegal_instr => s_illegal_instr
    );
    
    Inst_REGISTER_FILE: REGISTER_FILE Port map(
        i_clk => i_clk,
        i_en => s_reg_file_en,
        i_we => s_wb_en,
        i_sel_a => to_integer(unsigned(s_sel_a)),
        i_sel_b => to_integer(unsigned(s_sel_b)),
        i_sel_d => to_integer(unsigned(s_sel_d)),
        o_da => s_data_a,
        o_db => s_data_b,
        i_d => s_wb_data
    );
    
    Inst_IMM_DECODER: IMM_DECODER Port map(
        i_clk => i_clk,
        i_en => s_reg_read_stage,
        i_instruction => s_instruction(31 downto 7),
        i_instr_type => s_instr_type,
        o_imm => s_imm
    );
    
    Inst_ALU: ALU Port map(
        i_clk => i_clk,
        i_en => s_execute_stage,
        i_a => s_data_a,
        i_b => s_data_b,
        i_imm => s_imm,
        i_funct3 => s_funct3,
        i_funct7 => s_funct7,
        i_is_imm => s_is_imm,
        o_y => s_alu_result,
        o_should_branch => s_should_branch
    );
    
    Inst_MISC_ADDER: MISC_ADDER Port map(
        i_clk => i_clk,
        i_en => s_execute_stage,
        i_a => s_data_a,
        i_imm => s_imm,
        i_pc => s_pc,
        o_a_imm => s_a_imm,
        o_pc_imm => s_pc_imm,
        o_pc_4 => s_pc_4
    );
    
    Inst_STORE_DECODER: STORE_DECODER Port map(
        i_clk => i_clk,
        i_en => s_store_stage,
        i_data => s_data_b,
        i_addr => s_a_imm(1 downto 0),
        i_we => s_mem_we,
        i_funct3 => s_funct3,
        o_data => s_mem_data,
        o_we => s_mem_we_byte
    );
    
    Inst_LOAD_DECODER: LOAD_DECODER Port map(
        i_clk => i_clk,
        i_en => s_load_stage,
        i_data => i_mem_data,
        i_addr => s_a_imm(1 downto 0),
        i_funct3 => s_funct3,
        o_data => s_wb_mem_data
    );
    
    Inst_PROGRAM_COUNTER: PROGRAM_COUNTER Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => s_write_back_stage,
        i_should_branch => s_should_branch,
        i_branch => s_branch,
        i_jal => s_jal,
        i_jalr => s_jalr,
        i_int => s_int,
        i_exc => s_exc,
        i_reti => s_mret,
        i_pc_4 => s_pc_4,
        i_pc_imm => s_pc_imm,
        i_a_imm => s_a_imm,
        i_int_addr => s_int_addr,
        i_reti_addr => s_csr_epc,
        o_pc => s_pc,
        o_next_pc => s_next_pc
    );
    
    Inst_CSR_FILE: CSR_FILE Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => s_execute_stage,
        i_opcode => s_csr_opcode,
        i_csr_addr => s_csr_addr,
        i_csr_data => s_data_a,
        i_csr_imm => s_imm,
        o_csr_data => s_csr_data,
        i_is_imm => s_is_imm,
        i_instret => s_write_back_stage,
        i_ext_int => i_ext_int,
        i_tim_int => i_tim_int,
        o_int_en => s_gie,
        o_ext_ie => s_ext_ie,
        o_tim_ie => s_tim_ie,
        i_int_cause => s_int_cause,
        i_int_pc => s_int_pc,
        i_int_tval => s_int_tval,
        i_int => s_int,
        i_int_ret => s_mret,
        o_tvec => s_csr_tvec,
        o_epc => s_csr_epc
    );
    
    Inst_INTERRUPT_CONTROLLER: INTERRUPT_CONTROLLER Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => s_write_back_stage,
        i_exc => s_exc_trig,
        i_exc_cause => s_exc_cause,
        i_exc_tval => s_exc_tval,
        i_ext_int => i_ext_int,
        i_ext_tval => i_ext_tval,
        i_tim_int => i_tim_int,
        i_tim_tval => i_tim_tval,
        i_gie => s_gie,
        i_ext_ie => s_ext_ie,
        i_tim_ie => s_tim_ie,
        i_tvec => s_csr_tvec,
        i_pc => s_pc,
        i_next_pc => s_next_pc,
        o_int => s_int,
        o_addr => s_int_addr,
        o_cause => s_int_cause,
        o_tval => s_int_tval,
        o_exc => s_exc,
        o_pc => s_int_pc
    );
    
    Inst_EXCEPTION_UNIT: EXCEPTION_UNIT Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_fetch_misaligned => '0',
        i_fetch_fault => '0',
        i_illegal_instr => s_illegal_instr,
        i_load_misaligned => '0',
        i_load_fault => '0',
        i_store_misaligned => '0',
        i_store_fault => '0',
        i_ecall => s_ecall,
        i_instr => s_instruction,
        i_instr_addr => s_pc,
        i_data_addr => s_a_imm,
        o_exc => s_exc_trig,
        o_cause => s_exc_cause,
        o_tval => s_exc_tval
    );
    
    s_reg_file_en <= s_reg_read_stage or s_write_back_stage;
    s_wb_en <= s_write_back_stage and s_write_back;
    
    with s_wb_source select
        s_wb_data <= s_wb_mem_data when WB_MEM,
                     s_alu_result when WB_ALU,
                     s_pc_imm when WB_PCIMM,
                     s_imm when WB_IMM,
                     s_pc_4 when WB_PC4,
                     s_csr_data when WB_CSR,
                     X"00000000" when others;
    
    o_mem_en <= s_fetch_stage or (s_mem_stage and s_mem_en);
    o_mem_we <= s_mem_we_byte when s_mem_stage = '1' else "0000";
    o_mem_addr <= s_pc when s_fetch_stage = '1' or s_decode_stage = '1' else s_a_imm;
    o_mem_data <= s_mem_data;

end Behavioral;

