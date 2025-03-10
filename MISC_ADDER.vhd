----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:10 01/13/2025 
-- Design Name: 
-- Module Name:    MISC_ADDER - Behavioral 
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

entity MISC_ADDER is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_a : in std_logic_vector (31 downto 0);
        i_imm : in std_logic_vector (31 downto 0);
        i_pc : in std_logic_vector (31 downto 0);
        o_a_imm : out std_logic_vector (31 downto 0) := X"00000000";
        o_pc_imm : out std_logic_vector (31 downto 0) := X"00000000";
        o_pc_4 : out std_logic_vector (31 downto 0) := X"00000000"
    );
end MISC_ADDER;

architecture Behavioral of MISC_ADDER is

begin
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) and i_en = '1' then
            o_a_imm <= std_logic_vector(unsigned(i_a) + unsigned(i_imm));
            o_pc_imm <= std_logic_vector(unsigned(i_pc) + unsigned(i_imm));
            o_pc_4 <= std_logic_vector(unsigned(i_pc) + 4);
        end if;
    end process;

end Behavioral;

