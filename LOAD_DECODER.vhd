----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:42 02/01/2025 
-- Design Name: 
-- Module Name:    LOAD_DECODER - Behavioral 
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

entity LOAD_DECODER is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_data : in std_logic_vector (31 downto 0);
        i_addr : in std_logic_vector (1 downto 0);
        i_funct3 : in std_logic_vector (2 downto 0);
        o_data : out std_logic_vector (31 downto 0)
    );
end LOAD_DECODER;

architecture Behavioral of LOAD_DECODER is

begin
    
    process(i_clk, i_en)
    begin
        if (rising_edge(i_clk) and i_en = '1') then
            case i_funct3 is
                when "000" =>   -- LB
                    case i_addr is
                        when "00" => o_data <= std_logic_vector(resize(signed(i_data(7 downto 0)), o_data'length));
                        when "01" => o_data <= std_logic_vector(resize(signed(i_data(15 downto 8)), o_data'length));
                        when "10" => o_data <= std_logic_vector(resize(signed(i_data(23 downto 16)), o_data'length));
                        when "11" => o_data <= std_logic_vector(resize(signed(i_data(31 downto 24)), o_data'length));
                        when others => o_data <= X"00000000";
                    end case;
                
                when "001" =>   -- LH
                    if i_addr(1) = '0' then
                        o_data <= std_logic_vector(resize(signed(i_data(15 downto 0)), o_data'length));
                    else
                        o_data <= std_logic_vector(resize(signed(i_data(31 downto 16)), o_data'length));
                    end if;
                
                when "010" =>   -- LW
                    o_data <= i_data;
                
                when "100" =>   -- LBU
                    case i_addr is
                        when "00" => o_data <= X"000000" & i_data(7 downto 0);
                        when "01" => o_data <= X"000000" & i_data(15 downto 8);
                        when "10" => o_data <= X"000000" & i_data(23 downto 16);
                        when "11" => o_data <= X"000000" & i_data(31 downto 24);
                        when others => o_data <= X"00000000";
                    end case;
                
                when "101" =>   -- LHU
                    if i_addr(1) = '0' then
                        o_data <= X"0000" & i_data(15 downto 0);
                    else
                        o_data <= X"0000" & i_data(31 downto 16);
                    end if;
                
                when others =>
                    o_data <= X"00000000";
            end case;
        end if;
    end process;

end Behavioral;

