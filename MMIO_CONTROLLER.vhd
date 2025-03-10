----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:52 02/12/2025 
-- Design Name: 
-- Module Name:    MMIO_CONTROLLER - Behavioral 
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

entity MMIO_CONTROLLER is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(13 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0) := (others => '0');
        o_valid : out std_logic := '1';
        -- uart 0
        o_uart_0_en : out std_logic := '0';
        o_uart_0_we : out std_logic_vector(3 downto 0) := (others => '0');
        o_uart_0_addr : out std_logic_vector(1 downto 0) := (others => '0');
        o_uart_0_data : out std_logic_vector(31 downto 0) := (others => '0');
        i_uart_0_data : in std_logic_vector(31 downto 0);
        i_uart_0_valid : std_logic;
        -- spi 0
        o_spi_0_en : out std_logic := '0';
        o_spi_0_we : out std_logic_vector(3 downto 0) := (others => '0');
        o_spi_0_data : out std_logic_vector(31 downto 0) := (others => '0');
        i_spi_0_data : in std_logic_vector(31 downto 0);
        -- leds
        o_led_en : out std_logic := '0';
        o_led_data : out std_logic_vector (7 downto 0) := (others => '0');
        -- reg
        o_reg_en : out std_logic := '0';
        o_reg_data : out std_logic_vector (7 downto 0) := (others => '0');
        -- timer 0
        o_timer_0_en : out std_logic := '0';
        o_timer_0_we : out std_logic_vector(3 downto 0) := (others => '0');
        o_timer_0_addr : out std_logic := '0';
        o_timer_0_data : out std_logic_vector(31 downto 0) := (others => '0');
        i_timer_0_data : in std_logic_vector(31 downto 0)
    );
end MMIO_CONTROLLER;

architecture Behavioral of MMIO_CONTROLLER is
    type t_state is (IDLE, LOAD, STORE, PRESENT);
    signal s_state : t_state := IDLE;
    signal s_next_state : t_state := IDLE;
    
    signal s_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_en : std_logic := '0';
    signal s_address : std_logic_vector(13 downto 0) := (others => '0');
    signal s_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_valid : std_logic := '0';

begin
    process(i_clk, i_reset)
    begin
        if (i_reset = '1') then
            s_state <= IDLE;
        elsif (rising_edge(i_clk)) then
            s_state <= s_next_state;
        end if;
    end process;
    
    process(s_state, i_en, i_we, s_valid)
    begin
        case s_state is
            when IDLE=>
                if (i_en = '1') then
                    if (i_we = "0000") then
                        s_next_state <= LOAD;
                    else
                        s_next_state <= STORE;
                    end if;
                else
                    s_next_state <= IDLE;
                end if;
            
            when LOAD =>
                s_next_state <= PRESENT;
            
            when PRESENT =>
                if (s_valid = '1') then
                    s_next_state <= IDLE;
                else
                    s_next_state <= PRESENT;
                end if;
            
            when STORE =>
                s_next_state <= IDLE;
            
            when others =>
                s_next_state <= IDLE;
        end case;
    end process;
    
    process(i_clk)
    begin
        if (rising_edge(i_clk)) then
            case s_state is
                when IDLE =>
                    s_address <= i_addr;
                    s_i_data <= i_data;
                    s_we <= i_we;
                
                when PRESENT =>
                    case s_address(13 downto 2) is
                        when X"000" => o_data <= i_uart_0_data;
                        when X"004" => o_data <= i_spi_0_data;
                        when X"400" => o_data <= i_timer_0_data;
                        when X"401" => o_data <= i_timer_0_data;
                        when others => o_data <= (others => '0');
                    end case;
                
                when others =>
            end case;
        end if;
    end process;
    
    s_en <= '0' when s_state = IDLE else
            '1' when s_state = LOAD else
            '1' when s_state = STORE else
            not s_valid when s_state = PRESENT else
            '0';
    
    o_uart_0_en <= s_en when s_address(13 downto 2) = X"000" else '0';
    o_spi_0_en <= s_en when s_address(13 downto 2) = X"004" else '0';
    o_timer_0_en <= s_en when s_address(13 downto 2) = X"400" else
                    s_en when s_address(13 downto 2) = X"401" else '0';
    o_led_en <= s_en when s_address(13 downto 2) = X"800" else '0';
    o_reg_en <= s_en when s_address(13 downto 2) = X"801" else '0';
    
    o_uart_0_we <= s_we;
    o_spi_0_we <= s_we;
    o_timer_0_we <= s_we;
    
    o_uart_0_addr <= s_address(1 downto 0);
    o_timer_0_addr <= s_address(2);
    
    o_uart_0_data <= s_i_data;
    o_spi_0_data <= s_i_data;
    o_timer_0_data <= s_i_data;
    o_led_data <= s_i_data(7 downto 0);
    o_reg_data <= s_i_data(7 downto 0);
    
    s_valid <= i_uart_0_valid when s_address(13 downto 2) = X"000" else
               '1' when s_address(13 downto 2) = X"004" else
               '1' when s_address(13 downto 2) = X"400" else
               '1' when s_address(13 downto 2) = X"401" else
               '1' when s_address(13 downto 2) = X"800" else
               '1' when s_address(13 downto 2) = X"801" else
               '0';

    o_valid <= '1' when s_state = IDLE else '0';

end Behavioral;

