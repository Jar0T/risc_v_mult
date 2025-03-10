----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:30:55 01/11/2025 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_a : in std_logic_vector (31 downto 0);
        i_b : in std_logic_vector (31 downto 0);
        i_imm : in std_logic_vector (31 downto 0);
        i_funct3 : in std_logic_vector (2 downto 0);
        i_funct7 : in std_logic_vector (6 downto 0);
        i_is_imm : in std_logic;
        o_y : out std_logic_vector (31 downto 0);
        o_should_branch : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
    signal s_result: std_logic_vector (31 downto 0) := X"00000000";
    signal s_cmp: std_logic := '0';
    signal s_b: std_logic_vector (31 downto 0) := X"00000000";

begin
    s_b <= i_imm when i_is_imm = '1' else i_b;
    
    process(i_a, s_b, i_funct3, i_funct7, i_is_imm)
    begin
        case i_funct3 is
            when "000" =>   -- ADD/SUB
                if i_is_imm = '0' and i_funct7(5) = '1' then
                    s_result <= std_logic_vector(unsigned(i_a) - unsigned(s_b));
                else
                    s_result <= std_logic_vector(unsigned(i_a) + unsigned(s_b));
                end if;
            
            when "001" =>   -- SLL
                s_result <= std_logic_vector(shift_left(unsigned(i_a), to_integer(unsigned(s_b(4 downto 0)))));
            
            when "010" =>   -- SLT
                if signed(i_a) < signed(s_b) then
                    s_result <= X"00000001";
                else
                    s_result <= X"00000000";
                end if;
            
            when "011" =>   -- SLTU
                if unsigned(i_a) < unsigned(s_b) then
                    s_result <= X"00000001";
                else
                    s_result <= X"00000000";
                end if;
            
            when "100" =>   -- XOR
                s_result <= i_a xor s_b;
            
            when "101" =>   -- SRL/SRA
                if i_funct7(5) = '1' then
                    s_result <= std_logic_vector(shift_right(signed(i_a), to_integer(unsigned(s_b(4 downto 0)))));
                else
                    s_result <= std_logic_vector(shift_right(unsigned(i_a), to_integer(unsigned(s_b(4 downto 0)))));
                end if;
            
            when "110" =>   -- OR
                s_result <= i_a or s_b;
            
            when "111" =>   -- AND
                s_result <= i_a and s_b;
            
            when others =>
                s_result <= X"00000000";
        end case;
        
        case i_funct3 is
            when "000" =>   -- EQ
                if signed(i_a) = signed(s_b) then
                    s_cmp <= '1';
                else
                    s_cmp <= '0';
                end if;
            
            when "001" =>   -- NE
                if signed(i_a) = signed(s_b) then
                    s_cmp <= '0';
                else
                    s_cmp <= '1';
                end if;
            
            when "100" =>   -- LT
                if signed(i_a) < signed(s_b) then
                    s_cmp <= '1';
                else
                    s_cmp <= '0';
                end if;
            
            when "101" =>   -- GE
                if signed(i_a) < signed(s_b) then
                    s_cmp <= '0';
                else
                    s_cmp <= '1';
                end if;
            
            when "110" =>   -- LTU
                if unsigned(i_a) < unsigned(s_b) then
                    s_cmp <= '1';
                else
                    s_cmp <= '0';
                end if;
            
            when "111" =>   -- GEU
                if unsigned(i_a) < unsigned(s_b) then
                    s_cmp <= '0';
                else
                    s_cmp <= '1';
                end if;
            
            when others =>
                s_cmp <= '0';
            
        end case;
    end process;
    
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) and i_en = '1' then
            o_y <= s_result;
            o_should_branch <= s_cmp;
        end if;
    end process;

end Behavioral;

