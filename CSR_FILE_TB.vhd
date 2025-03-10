--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:17:35 02/18/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/CSR_FILE_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CSR_FILE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity CSR_FILE_TB is
end CSR_FILE_TB;
 
architecture behavior of CSR_FILE_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component CSR_FILE
    Port(
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_en : in  std_logic;
        i_opcode : in  std_logic_vector(3 downto 0);
        i_csr_addr : in  std_logic_vector(11 downto 0);
        i_csr_data : in  std_logic_vector(31 downto 0);
        i_csr_imm : in  std_logic_vector(31 downto 0);
        o_csr_data : out  std_logic_vector(31 downto 0);
        i_is_imm : in  std_logic;
        i_instret : in  std_logic;
        i_ext_int : in  std_logic;
        i_tim_int : in  std_logic;
        o_int_en : out  std_logic;
        o_ext_ie : out  std_logic;
        o_tim_ie : out  std_logic;
        i_int_cause : in  std_logic_vector(31 downto 0);
        i_int_pc : in  std_logic_vector(31 downto 0);
        i_int_tval : in  std_logic_vector(31 downto 0);
        i_int : in  std_logic;
        i_int_ret : in  std_logic;
        o_tvec : out  std_logic_vector(31 downto 0);
        o_epc : out  std_logic_vector(31 downto 0)
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_opcode : std_logic_vector(3 downto 0) := (others => '0');
    signal i_csr_addr : std_logic_vector(11 downto 0) := (others => '0');
    signal i_csr_data : std_logic_vector(31 downto 0) := (others => '0');
    signal i_csr_imm : std_logic_vector(31 downto 0) := (others => '0');
    signal i_is_imm : std_logic := '0';
    signal i_instret : std_logic := '0';
    signal i_ext_int : std_logic := '0';
    signal i_tim_int : std_logic := '0';
    signal i_int_cause : std_logic_vector(31 downto 0) := (others => '0');
    signal i_int_pc : std_logic_vector(31 downto 0) := (others => '0');
    signal i_int_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal i_int : std_logic := '0';
    signal i_int_ret : std_logic := '0';

    --Outputs
    signal o_csr_data : std_logic_vector(31 downto 0);
    signal o_int_en : std_logic;
    signal o_ext_ie : std_logic;
    signal o_tim_ie : std_logic;
    signal o_tvec : std_logic_vector(31 downto 0);
    signal o_epc : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
    uut: CSR_FILE Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_en,
        i_opcode => i_opcode,
        i_csr_addr => i_csr_addr,
        i_csr_data => i_csr_data,
        i_csr_imm => i_csr_imm,
        o_csr_data => o_csr_data,
        i_is_imm => i_is_imm,
        i_instret => i_instret,
        i_ext_int => i_ext_int,
        i_tim_int => i_tim_int,
        o_int_en => o_int_en,
        o_ext_ie => o_ext_ie,
        o_tim_ie => o_tim_ie,
        i_int_cause => i_int_cause,
        i_int_pc => i_int_pc,
        i_int_tval => i_int_tval,
        i_int => i_int,
        i_int_ret => i_int_ret,
        o_tvec => o_tvec,
        o_epc => o_epc
        );

    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= '0';
        wait for i_clk_period/2;
        i_clk <= '1';
        wait for i_clk_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        i_instret <= '1';
        wait for i_clk_period;
        i_instret <= '0';
        wait for i_clk_period * 10;
        i_ext_int <= '1';
        wait for i_clk_period;
        i_tim_int <= '1';
        wait for i_clk_period;
        i_en <= '1';
        i_opcode <= "1010";
        i_csr_data <= X"00000008";
        i_csr_addr <= X"300";
        wait for i_clk_period;
        i_en <= '0';
        i_opcode <= "0000";
        wait for i_clk_period * 5;
        i_int <= '1';
        i_int_cause <= X"8000000B";
        i_int_pc <= X"0000FFCC";
        i_int_tval <= X"AA55AA55";
        wait for i_clk_period;
        i_int <= '0';
        wait for i_clk_period * 4;
        i_int_ret <= '1';
        wait for i_clk_period;
        i_int_ret <= '0';
        wait for i_clk_period;

        wait;
    end process;

end;
