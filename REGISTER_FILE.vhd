----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:18:45 01/09/2025 
-- Design Name: 
-- Module Name:    REGISTER_FILE - Behavioral 
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

entity REGISTER_FILE is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic;
        i_sel_a : in integer range 0 to 31;
        i_sel_b : in integer range 0 to 31;
        i_sel_d : in integer range 0 to 31;
        o_da : out std_logic_vector (31 downto 0) := X"00000000";
        o_db : out std_logic_vector (31 downto 0) := X"00000000";
        i_d : in std_logic_vector (31 downto 0) := X"00000000"
    );
end REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is
    type store_t is array (1 to 31) of std_logic_vector (31 downto 0);
    signal registers: store_t := (others => X"00000000");

begin
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) and i_en = '1' then
            if i_we = '1' and i_sel_d /= 0 then
                registers(i_sel_d) <= i_d;
            end if;
        end if;
    end process;
    
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) and i_en = '1' then
            if i_sel_a = 0 then
                o_da <= X"00000000";
            else
                o_da <= registers(i_sel_a);
            end if;
            
            if i_sel_b = 0 then
                o_db <= X"00000000";
            else
                o_db <= registers(i_sel_b);
            end if;
        end if;
    end process;

end Behavioral;

