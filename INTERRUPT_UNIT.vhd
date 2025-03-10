----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:11 02/22/2025 
-- Design Name: 
-- Module Name:    INTERRUPT_UNIT - Behavioral 
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

entity INTERRUPT_UNIT is
    Generic (
        NUM_INTERRUPTS : integer := 1
    );
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_int_src : in std_logic_vector(NUM_INTERRUPTS - 1 downto 0);
        o_int : out std_logic;
        o_tval : out std_logic_vector (31 downto 0)
    );
end INTERRUPT_UNIT;

architecture Behavioral of INTERRUPT_UNIT is

    signal s_tval : std_logic_vector(31 downto 0) := (others => '0');

begin

    o_tval <= s_tval;
    
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_tval <= (others => '0');
            o_int <= '0';
        elsif rising_edge(i_clk) then
            o_int <= '0';
            s_tval <= (others => '0');
            
            for i in 0 to NUM_INTERRUPTS-1 loop
                if i_int_src(i) = '1' then
                    o_int <= '1';
                    s_tval <= std_logic_vector(to_unsigned(i, s_tval'length));
                    exit;
                end if;
            end loop;
        end if;
    end process;

end Behavioral;

