----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:18:21 02/03/2025 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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

entity UART is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector (3 downto 0);
        i_addr : in std_logic_vector (1 downto 0);
        i_data : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0) := (others => '0');
        o_valid : out std_logic := '0';
        i_rx : in std_logic;
        o_tx : out std_logic := '1'
    );
end UART;

architecture Behavioral of UART is

    component UART_RECEIVER
    Generic (
        g_clk_freq : integer;
        g_baud_rate : integer
    );
	Port(
		i_clk : in std_logic;
		i_reset : in std_logic;
		i_rx : in std_logic;
		i_full : in std_logic;          
		o_data : out std_logic_vector(7 downto 0);
		o_valid : out std_logic
		);
	end component;
    
    component UART_TRANSMITTER
    Generic (
        g_clk_freq : integer;
        g_baud_rate : integer
    );
	Port(
		i_clk : in std_logic;
		i_reset : in std_logic;
		i_data : in std_logic_vector(7 downto 0);
		i_empty : in std_logic;
        i_valid : in std_logic;
		o_ready : out std_logic;
		o_tx : out std_logic
		);
	end component;
    
    component UART_FIFO
    Port (
        clk : in std_logic;
        rst : in std_logic;
        din : in std_logic_vector(7 downto 0);
        wr_en : in std_logic;
        rd_en : in std_logic;
        dout : out std_logic_vector(7 downto 0);
        full : out std_logic;
        empty : out std_logic;
        valid : out std_logic;
        data_count : out std_logic_vector(4 downto 0)
    );
    end component;
    
    signal s_rx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_rx_data_count : std_logic_vector(4 downto 0) := (others => '0');
    signal s_rx_full : std_logic := '0';
    signal s_rx_empty : std_logic := '0';
    signal s_rx_we : std_logic := '0';
    signal s_rx_rd : std_logic := '0';
    
    signal s_tx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_tx_data_count : std_logic_vector(4 downto 0) := (others => '0');
    signal s_tx_full : std_logic := '0';
    signal s_tx_empty : std_logic := '0';
    signal s_tx_we : std_logic := '0';
    signal s_tx_rd : std_logic := '0';
    signal s_tx_valid : std_logic := '0';
    
    signal s_o_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_i_data : std_logic_vector(7 downto 0) := (others => '0');

begin

    Inst_UART_RECEIVER: UART_RECEIVER Generic map(
        g_clk_freq => 100_000_000,
        g_baud_rate => 250_000
    )
    Port map(
		i_clk => i_clk,
		i_reset => i_reset,
		i_rx => i_rx,
		i_full => s_rx_full,
		o_data => s_rx_data,
		o_valid => s_rx_we
	);
    
    Inst_UART_TRANSMITTER: UART_TRANSMITTER Generic map(
        g_clk_freq => 100_000_000,
        g_baud_rate => 250_000
    )
    Port map(
		i_clk => i_clk,
		i_reset => i_reset,
		i_data => s_tx_data,
		i_empty => s_tx_empty,
        i_valid => s_tx_valid,
		o_ready => s_tx_rd,
		o_tx => o_tx
	);
    
    Inst_RX_UART_FIFO : UART_FIFO
    Port map (
        clk => i_clk,
        rst => i_reset,
        din => s_rx_data,
        wr_en => s_rx_we,
        rd_en => s_rx_rd,
        dout => s_o_data,
        full => s_rx_full,
        empty => s_rx_empty,
        valid => open,
        data_count => s_rx_data_count
    );
    
    Inst_TX_UART_FIFO : UART_FIFO
    Port map (
        clk => i_clk,
        rst => i_reset,
        din => s_i_data,
        wr_en => s_tx_we,
        rd_en => s_tx_rd,
        dout => s_tx_data,
        full => s_tx_full,
        empty => s_tx_empty,
        valid => s_tx_valid,
        data_count => s_tx_data_count
    );
    
    process(i_clk, i_en)
    begin
        if rising_edge(i_clk) then
            if i_en = '1' then
                o_valid <= '1';
                s_rx_rd <= '0';
                if i_we = "0000" then
                    o_data <=  (others => '0');
                    case i_addr is
                        when "00" =>
                            o_data(7 downto 0) <= s_o_data;
                            if s_rx_empty = '1' then
                                o_valid <= '0';
                            else
                                s_rx_rd <= '1';
                            end if;
                        
                        when "01" =>
                            o_data(15 downto 8) <= X"0" & s_tx_empty & s_tx_full & s_rx_empty & s_rx_full;
                        
                        when "10" =>
                            o_data(23 downto 16) <= "000" & s_rx_data_count;
                        
                        when "11" =>
                            o_data(31 downto 24) <= "000" & s_tx_data_count;
                        
                        when others =>
                            o_data <=  (others => '0');
                    end case;
                else
                    if i_we(0) = '1' then
                        s_tx_we <= '1';
                        s_i_data <= i_data(7 downto 0);
                    else
                        s_tx_we <= '0';
                    end if;
                end if;
            else
                o_valid <= '1';
                s_rx_rd <= '0';
                s_tx_we <= '0';
            end if;
        end if;
    end process;

end Behavioral;

