----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:28:09 01/12/2025 
-- Design Name: 
-- Module Name:    IMM_DECODER - Behavioral 
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

entity IMM_DECODER is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_instruction : in std_logic_vector (24 downto 0);
        i_instr_type : in std_logic_vector (2 downto 0);
        o_imm : out std_logic_vector (31 downto 0)
    );
end IMM_DECODER;

architecture Behavioral of IMM_DECODER is

begin
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) and i_en = '1' then
            case i_instr_type is
                when TYPE_R =>
                    o_imm <= X"00000000";
                
                when TYPE_I =>
                    o_imm <= std_logic_vector(resize(signed(i_instruction(24 downto 13)), o_imm'length));
                
                when TYPE_S =>
                    o_imm <= std_logic_vector(resize(signed(i_instruction(24 downto 18) & i_instruction(4 downto 0)), o_imm'length));
                
                when TYPE_B =>
                    o_imm <= std_logic_vector(resize(signed(i_instruction(24) & i_instruction(0) & i_instruction(23 downto 18) & i_instruction(4 downto 1) & '0'), o_imm'length));
                
                when TYPE_U =>
                    o_imm <= i_instruction(24 downto 5) & X"000";
                
                when TYPE_J =>
                    o_imm <= std_logic_vector(resize(signed(i_instruction(24) & i_instruction(12 downto 5) & i_instruction(13) & i_instruction(23 downto 14) & '0'), o_imm'length));
                
                when TYPE_O =>
                    o_imm <= X"000000" & "000" & i_instruction(12 downto 8);
                
                when others =>
                    o_imm <= X"00000000";
            end case;
        end if;
    end process;

end Behavioral;

