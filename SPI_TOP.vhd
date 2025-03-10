----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:56:18 02/05/2025 
-- Design Name: 
-- Module Name:    SPI_TOP - Behavioral 
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

entity SPI_TOP is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector (3 downto 0);
        i_data : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0) := (others => '0');
        o_sclk : out std_logic := '0';
        o_mosi : out std_logic := '0';
        i_miso : in std_logic
    );
end SPI_TOP;

architecture Behavioral of SPI_TOP is

    component SPI
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_cpol : in std_logic;
        i_cpha : in std_logic;
        i_clk_div : in integer;
        i_data : in std_logic_vector(7 downto 0);
        i_execute : in std_logic;
        i_miso : in std_logic;          
        o_ready : out std_logic;
        o_data : out std_logic_vector(7 downto 0);
        o_valid : out std_logic;
        o_sclk : out std_logic;
        o_mosi : out std_logic
        );
    end component;
    
    signal s_cpol : std_logic := '0';
    signal s_cpha : std_logic := '0';
    signal s_ready : std_logic := '0';
    signal s_execute : std_logic := '0';
    signal s_valid : std_logic := '0';
    signal s_rx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_tx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_clk_div : std_logic_vector(15 downto 0) := (others => '0');
    signal s_clk_div_int : integer range 0 to 65535 := 0;

begin
    s_clk_div_int <= to_integer(unsigned(s_clk_div));

    Inst_SPI: SPI Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_cpol => s_cpol,
        i_cpha => s_cpha,
        i_clk_div => s_clk_div_int,
        i_data => s_tx_data,
        o_ready => s_ready,
        i_execute => s_execute,
        o_data => s_rx_data,
        o_valid => s_valid,
        o_sclk => o_sclk,
        o_mosi => o_mosi,
        i_miso => i_miso
    );
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_en = '1' then
                -- read
                if i_we = "0000" then
                    o_data <= s_clk_div & "00000" & s_ready & s_cpol & s_cpha & s_rx_data;
                -- write
                else
                    if i_we(0) = '1' then
                        s_tx_data <= i_data(7 downto 0);
                        s_execute <= '1';
                    end if;
                    if i_we(1) = '1' then
                        s_cpha <= i_data(8);
                        s_cpol <= i_data(9);
                    end if;
                    if i_we(2) = '1' then
                        s_clk_div(7 downto 0) <= i_data(23 downto 16);
                    end if;
                    if i_we(3) = '1' then
                        s_clk_div(15 downto 8) <= i_data(31 downto 24);
                    end if;
                end if;
            
            else
                s_execute <= '0';
            end if;
        end if;
    end process;


end Behavioral;

