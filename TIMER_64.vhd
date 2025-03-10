----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:35:28 02/23/2025 
-- Design Name: 
-- Module Name:    TIMER - Behavioral 
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

entity TIMER_64 is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector (3 downto 0);
        i_addr : in std_logic;
        i_data : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0)
    );
end TIMER_64;

architecture Behavioral of TIMER_64 is

    signal s_tcr : unsigned(63 downto 0) := (others => '0');

begin

    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_tcr <= (others => '0');
        elsif rising_edge(i_clk) then
            s_tcr <= s_tcr + 1;
            if i_en = '1' then
                if i_we = "0000" then
                    if i_addr = '0' then
                        o_data <= std_logic_vector(s_tcr(31 downto 0));
                    else
                        o_data <= std_logic_vector(s_tcr(63 downto 32));
                    end if;
                else
                    if i_addr = '0' then
                        s_tcr(31 downto 0) <= unsigned(i_data);
                    else
                        s_tcr(63 downto 32) <= unsigned(i_data);
                    end if;
                end if;
            end if;
        end if;
    end process;


end Behavioral;

