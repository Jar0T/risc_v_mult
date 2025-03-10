----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:34 02/18/2025 
-- Design Name: 
-- Module Name:    INTERRUPT_CONTROLLER - Behavioral 
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

entity INTERRUPT_CONTROLLER is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_exc : in std_logic;
        i_exc_cause : in std_logic_vector (31 downto 0);
        i_exc_tval : in std_logic_vector (31 downto 0);
        i_ext_int : in std_logic;
        i_ext_tval : in std_logic_vector (31 downto 0);
        i_tim_int : in std_logic;
        i_tim_tval : in std_logic_vector (31 downto 0);
        i_gie : in std_logic;
        i_ext_ie : in std_logic;
        i_tim_ie : in std_logic;
        i_tvec : in std_logic_vector (31 downto 0);
        i_pc : in std_logic_vector (31 downto 0);
        i_next_pc : in std_logic_vector (31 downto 0);
        o_int : out std_logic;
        o_addr : out std_logic_vector (31 downto 0);
        o_cause : out std_logic_vector (31 downto 0);
        o_tval : out std_logic_vector (31 downto 0);
        o_exc : out std_logic;
        o_pc : out std_logic_vector (31 downto 0)
    );
end INTERRUPT_CONTROLLER;

architecture Behavioral of INTERRUPT_CONTROLLER is

    signal s_ext_ie : std_logic := '0';
    signal s_tim_ie : std_logic := '0';

begin

    s_ext_ie <= i_ext_ie and i_gie;
    s_tim_ie <= i_tim_ie and i_gie;
    
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            o_int <= '0';
            o_exc <= '0';
        elsif rising_edge(i_clk) then
            if i_exc = '1' then
                o_int <= '1';
                o_exc <= '1';
                o_cause <= '0' & i_exc_cause(30 downto 0);
                o_tval <= i_exc_tval;
                o_pc <= i_pc;
                o_addr <= i_tvec(31 downto 2) & "00";
            elsif i_ext_int = '1' and s_ext_ie = '1' and i_en = '1' then
                o_int <= '1';
                o_cause <= X"8000000B";
                o_tval <= i_ext_tval;
                o_pc <= i_next_pc;
                if i_tvec(0) = '0' then
                    o_addr <= i_tvec(31 downto 2) & "00";
                else
                    o_addr <= std_logic_vector(unsigned(i_tvec) + X"0000002C") and X"FFFFFFFC";
                end if;
            elsif i_tim_int = '1' and s_tim_ie = '1' and i_en = '1' then
                o_int <= '1';
                o_cause <= X"80000007";
                o_tval <= i_tim_tval;
                o_pc <= i_next_pc;
                if i_tvec(0) = '0' then
                    o_addr <= i_tvec(31 downto 2) & "00";
                else
                    o_addr <= std_logic_vector(unsigned(i_tvec) + X"0000001C") and X"FFFFFFFC";
                end if;
            else
                o_int <= '0';
                o_exc <= '0';
            end if;
        end if;
    end process;


end Behavioral;

