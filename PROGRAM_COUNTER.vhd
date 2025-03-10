----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:25 01/13/2025 
-- Design Name: 
-- Module Name:    PROGRAM_COUNTER - Behavioral 
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

entity PROGRAM_COUNTER is
    Port (
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
        i_pc_4 : in std_logic_vector (31 downto 0);
        i_pc_imm : in std_logic_vector (31 downto 0);
        i_a_imm : in std_logic_vector (31 downto 0);
        i_int_addr : in std_logic_vector (31 downto 0);
        i_reti_addr : in std_logic_vector (31 downto 0);
        o_pc : out std_logic_vector (31 downto 0);
        o_next_pc : out std_logic_vector (31 downto 0)
    );
end PROGRAM_COUNTER;

architecture Behavioral of PROGRAM_COUNTER is
    signal s_pc, s_next_pc: unsigned(31 downto 0) := (others => '0');
    
begin
    process(i_clk, i_en, i_reset)
    begin
        if i_reset = '1' then
            s_pc <= (others => '0');
        elsif rising_edge(i_clk) and i_en = '1' then
            if i_exc = '1' then
                s_pc <= unsigned(i_int_addr);
            elsif i_int = '1' and i_en = '1' then
                s_pc <= unsigned(i_int_addr);
            elsif i_reti = '1' and i_en = '1' then
                s_pc <= unsigned(i_reti_addr);
            elsif i_en = '1' then
                s_pc <= s_next_pc;
            end if;
        end if;
    end process;
    
    process(i_jal, i_branch, i_should_branch, i_jalr, i_pc_imm, i_a_imm, i_pc_4)
    begin
        if i_jal = '1' or (i_branch = '1' and i_should_branch = '1') then
            s_next_pc <= unsigned(i_pc_imm and X"FFFFFFFE");
        elsif i_jalr = '1' then
            s_next_pc <= unsigned(i_a_imm and X"FFFFFFFE");
        else
            s_next_pc <= unsigned(i_pc_4);
        end if;
    end process;
    
    o_pc <= std_logic_vector(s_pc);
    o_next_pc <= std_logic_vector(s_next_pc);

end Behavioral;

