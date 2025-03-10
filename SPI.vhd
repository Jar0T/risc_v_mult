----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:09:25 02/05/2025 
-- Design Name: 
-- Module Name:    SPI - Behavioral 
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

entity SPI is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_cpol : in std_logic;
        i_cpha : in std_logic;
        i_clk_div : in integer range 0 to 65535;
        i_data : in std_logic_vector (7 downto 0);
        o_ready : out std_logic;
        i_execute : in std_logic;
        o_data : out std_logic_vector (7 downto 0);
        o_valid : out std_logic;
        o_sclk : out std_logic;
        o_mosi : out std_logic;
        i_miso : in std_logic
    );
end SPI;

architecture Behavioral of SPI is

    type t_state is (IDLE, START, EXECUTE, STOP);
    signal s_state : t_state := IDLE;
    
    signal s_cpol, s_cpha : std_logic := '0';
    signal s_clk_div : integer range 0 to 65535 := 0;
    signal s_clk_count : integer range 0 to 65535 := 0;
    signal s_bit_count : integer range 0 to 7 := 7;
    
    signal s_sclk : std_logic := '0';
    
    signal s_rx_data, s_tx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_valid : std_logic := '0';

begin

    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_clk_div <= 0;
            s_cpol <= '0';
            s_cpha <= '0';
        elsif rising_edge(i_clk) then
            if s_state = IDLE then
                s_clk_div <= i_clk_div;
                s_cpol <= i_cpol;
                s_cpha <= i_cpha;
                if i_execute = '1' then
                    s_tx_data <= i_data;
                end if;
            end if;
        end if;
    end process;

    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            
        elsif rising_edge(i_clk) then
            case s_state is
                when IDLE =>
                    if i_execute = '1' then
                        s_state <= START;
                    else
                        s_state <= IDLE;
                    end if;
                    
                when START =>
                    if s_clk_count = 0 then
                        s_state <= EXECUTE;
                    else
                        s_state <= START;
                    end if;
                
                when EXECUTE =>
                    if s_clk_count = 0 and s_bit_count = 0 and s_sclk = '1' then
                        s_state <= STOP;
                    else
                        s_state <= EXECUTE;
                    end if;
                
                when STOP =>
                    if s_clk_count = 0 then
                        s_state <= IDLE;
                    else
                        s_state <= STOP;
                    end if;
                
            end case;
        end if;
    end process;
    
    process(i_clk, i_reset, s_clk_div)
    begin
        if i_reset = '1' then
            s_clk_count <= 0;
        elsif rising_edge(i_clk) then
            if s_state = IDLE then
                s_clk_count <= s_clk_div;
            else
                if s_clk_count = 0 then
                    s_clk_count <= s_clk_div;
                else
                    s_clk_count <= s_clk_count - 1;
                end if;
            end if;
        end if;
    end process;
    
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_sclk <= '0';
        elsif rising_edge(i_clk) then
            if s_state = START or s_state = EXECUTE then
                if s_clk_count = 0 then
                    s_sclk <= not s_sclk;
                end if;
            else
                s_sclk <= '0';
            end if;
        end if;
    end process;
    
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_bit_count <= 7;
        elsif rising_edge(i_clk) then
            if s_state = EXECUTE then
                if s_clk_count = 0 and s_bit_count /= 0 then
                    if s_sclk /= s_cpha then
                        s_bit_count <= s_bit_count - 1;
                    end if;
                end if;
            elsif s_state = STOP then
                s_bit_count <= 0;
            else
                s_bit_count <= 7;
            end if;
        end if;
    end process;
    
    process(s_state, s_tx_data, s_bit_count, s_cpha)
    begin
        case s_state is
            when IDLE =>
                o_mosi <= 'Z';
            
            when START =>
                if s_cpha = '1' then
                    o_mosi <= 'Z';
                else
                    o_mosi <= s_tx_data(s_bit_count);
                end if;
            
            when EXECUTE =>
                o_mosi <= s_tx_data(s_bit_count);
            
            when STOP =>
                if s_cpha = '1' then
                    o_mosi <= s_tx_data(s_bit_count);
                else
                    o_mosi <= 'Z';
                end if;
        end case;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (s_state = START or s_state = EXECUTE) and s_clk_count = 0 and s_sclk = s_cpha then
                s_rx_data(s_bit_count) <= i_miso;
            end if;
            if s_state = STOP and s_clk_count = 0 then
                s_valid <= '1';
            else
                s_valid <= '0';
            end if;
        end if;
    end process;
    
    o_sclk <= s_sclk when s_cpol = '0' else not s_sclk;
    o_valid <= s_valid;
    o_data <= s_rx_data;
    o_ready <= '1' when s_state = IDLE and s_valid = '0' else '0';

end Behavioral;

