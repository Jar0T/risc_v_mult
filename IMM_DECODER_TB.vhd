--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:40:13 01/12/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/IMM_DECODER_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IMM_DECODER
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
library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

library work;
use work.constants.all;
 
entity IMM_DECODER_TB is
end IMM_DECODER_TB;
 
architecture behavior of IMM_DECODER_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component IMM_DECODER
    Port(
        i_clk : in std_logic;
        i_en : in std_logic;
        i_instruction : in  std_logic_vector(24 downto 0);
        i_instr_type : in  std_logic_vector(2 downto 0);
        o_imm : out  std_logic_vector(31 downto 0)
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal i_instr_type : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
    signal o_imm : std_logic_vector(31 downto 0);
    -- No clocks detected in port list. Replace <clock> below with 
    -- appropriate port name 
 
    constant i_clk_period : time := 10 ns;
 
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: IMM_DECODER Port map (
        i_clk => i_clk,
        i_en => i_en,
        i_instruction => i_instruction(31 downto 7),
        i_instr_type => i_instr_type,
        o_imm => o_imm
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
        i_en <= '1';
        -- insert stimulus here
        -- add x0, x3, x7
        i_instruction <= X"00718033";
        i_instr_type <= TYPE_R;
        wait for i_clk_period;
        -- addi x5, x2, 20
        i_instruction <= X"01410293";
        i_instr_type <= TYPE_I;
        wait for i_clk_period;
        -- addi x5, x2, -30
        i_instruction <= X"fe210293";
        i_instr_type <= TYPE_I;
        i_en <= '0';
        wait for i_clk_period;
        i_en <= '1';
        wait for i_clk_period;
        -- sb x15, 10(x5)
        i_instruction <= X"00f28523";
        i_instr_type <= TYPE_S;
        wait for i_clk_period;
        -- sb x15, -20(x5)
        i_instruction <= X"fef28623";
        i_instr_type <= TYPE_S;
        wait for i_clk_period;
        -- bne x0, x1, 12
        i_instruction <= X"00100463";
        i_instr_type <= TYPE_B;
        wait for i_clk_period;
        -- bne x0, x1, -8
        i_instruction <= X"00101463";
        i_instr_type <= TYPE_B;
        wait for i_clk_period;
        -- lui x7, 50
        i_instruction <= X"000323b7";
        i_instr_type <= TYPE_U;
        wait for i_clk_period;
        -- lui x7, 0xFFFFF
        i_instruction <= X"fffff3b7";
        i_instr_type <= TYPE_U;
        wait for i_clk_period;
        -- auipc x12, 42
        i_instruction <= X"0002a617";
        i_instr_type <= TYPE_U;
        wait for i_clk_period;
        -- auipc x12, 0xAAAAA
        i_instruction <= X"aaaaa617";
        i_instr_type <= TYPE_U;
        wait for i_clk_period;
        -- jal x0, 8
        i_instruction <= X"fd5ff06f";
        i_instr_type <= TYPE_J;
        wait for i_clk_period;
        -- jal x0, -8
        i_instruction <= X"fc1ff06f";
        i_instr_type <= TYPE_J;
        wait for i_clk_period;

        wait;
    end process;

end;
