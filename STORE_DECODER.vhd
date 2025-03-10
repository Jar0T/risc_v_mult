----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:49:00 01/29/2025 
-- Design Name: 
-- Module Name:    STORE_DECODER - Behavioral 
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

entity STORE_DECODER is
    Port (
        i_clk : in std_logic;
        i_en : in std_logic;
        i_data : in std_logic_vector (31 downto 0);
        i_addr : in std_logic_vector (1 downto 0);
        i_we : in std_logic;
        i_funct3 : in std_logic_vector (2 downto 0);
        o_data : out std_logic_vector (31 downto 0);
        o_we : out std_logic_vector (3 downto 0)
    );
end STORE_DECODER;

architecture Behavioral of STORE_DECODER is

begin

    process(i_clk, i_en)
    begin
        if (rising_edge(i_clk)) then
            if (i_en = '1' and i_we = '1') then
                case i_funct3 is
                    when "000" =>   -- SB
                        case i_addr is
                            when "00" =>
                                o_we <= "0001";
                                o_data <= X"000000" & i_data(7 downto 0);
                            
                            when "01" =>
                                o_we <= "0010";
                                o_data <= X"0000" & i_data(7 downto 0) & X"00";
                            
                            when "10" =>
                                o_we <= "0100";
                                o_data <= X"00" & i_data(7 downto 0) & X"0000";
                            
                            when "11" =>
                                o_we <= "1000";
                                o_data <= i_data(7 downto 0) & X"000000";
                            
                            when others =>
                                o_we <= "0000";
                                o_data <= X"00000000";
                        end case;
                    
                    when "001" =>   -- SH
                        if (i_addr(1) = '0') then
                            o_we <= "0011";
                            o_data <= X"0000" & i_data(15 downto 0);
                        else
                            o_we <= "1100";
                            o_data <= i_data(15 downto 0) & X"0000";
                        end if;
                    
                    when "010" =>   -- SW
                        o_we <= "1111";
                        o_data <= i_data;
                    
                    when others =>
                        o_we <= "0000";
                        o_data <= X"00000000";
                end case;
            else
                o_we <= "0000";
                o_data <= X"00000000";
            end if;
        end if;
    end process;

end Behavioral;

