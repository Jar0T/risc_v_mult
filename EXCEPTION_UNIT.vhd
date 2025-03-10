----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:35:40 02/21/2025 
-- Design Name: 
-- Module Name:    EXCEPTION_UNIT - Behavioral 
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

entity EXCEPTION_UNIT is
    Port (
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
        i_instr : in std_logic_vector (31 downto 0);
        i_instr_addr : in std_logic_vector (31 downto 0);
        i_data_addr : in std_logic_vector (31 downto 0);
        o_exc : out std_logic := '0';
        o_cause : out std_logic_vector (31 downto 0) := (others => '0');
        o_tval : out std_logic_vector (31 downto 0) := (others => '0')
    );
end EXCEPTION_UNIT;

architecture Behavioral of EXCEPTION_UNIT is

begin

    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            o_exc <= '0';
        elsif rising_edge(i_clk) then
            if i_fetch_misaligned = '1' then
                o_exc <= '1';
                o_cause <= X"00000000";
                o_tval <= i_instr_addr;
            elsif i_fetch_fault = '1' then
                o_exc <= '1';
                o_cause <= X"00000001";
                o_tval <= i_instr_addr;
            elsif i_illegal_instr = '1' then
                o_exc <= '1';
                o_cause <= X"00000002";
                o_tval <= i_instr;
            elsif i_load_misaligned = '1' then
                o_exc <= '1';
                o_cause <= X"00000004";
                o_tval <= i_data_addr;
            elsif i_load_fault = '1' then
                o_exc <= '1';
                o_cause <= X"00000005";
                o_tval <= i_data_addr;
            elsif i_store_misaligned = '1' then
                o_exc <= '1';
                o_cause <= X"00000006";
                o_tval <= i_data_addr;
            elsif i_store_fault = '1' then
                o_exc <= '1';
                o_cause <= X"00000007";
                o_tval <= i_data_addr;
            elsif i_ecall = '1' then
                o_exc <= '1';
                o_cause <= X"0000000B";
                o_tval <= X"00000000";
            else
                o_exc <= '0';
            end if;
        end if;
    end process;

end Behavioral;

