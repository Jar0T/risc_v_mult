----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:18:37 02/02/2025 
-- Design Name: 
-- Module Name:    UART_TRANSMITTER - Behavioral 
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

entity UART_TRANSMITTER is
    Generic (
        g_clk_freq : integer := 100_000_000;    -- 100 MHz
        g_baud_rate : integer := 19200
    );
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_data : in std_logic_vector (7 downto 0);
        i_empty : in std_logic;
        i_valid : in std_logic;
        o_ready : out std_logic;
        o_tx : out std_logic
    );
end UART_TRANSMITTER;

architecture Behavioral of UART_TRANSMITTER is

    constant c_baud_ticks : integer := g_clk_freq / g_baud_rate;
    
    type t_state is (IDLE, START, DATA, STOP, DELAY);
    signal s_state, s_next_state : t_state := IDLE;
    signal s_baud_count : integer range 0 to c_baud_ticks-1 := c_baud_ticks - 1;
    signal s_bit_count : integer range 0 to 7 := 0;
    signal s_shift_reg : std_logic_vector(7 downto 0);
    signal s_tx : std_logic := '1';

begin
    o_tx <= s_tx;
    
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_state <= IDLE;
        elsif rising_edge(i_clk) then
            s_state <= s_next_state;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_state = IDLE then
                s_baud_count <= c_baud_ticks - 1;
            elsif s_baud_count = 0 then
                s_baud_count <= c_baud_ticks - 1;
            else
                s_baud_count <= s_baud_count - 1;
            end if;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_state = IDLE then
                s_bit_count <= 7;
                s_shift_reg <= i_data;
            elsif s_state = DATA and s_baud_count = 0 then
                if s_bit_count = 0 then
                    s_bit_count <= 7;
                else
                    s_bit_count <= s_bit_count - 1;
                    s_shift_reg <= '0' & s_shift_reg(7 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    process(s_state, i_valid, s_baud_count, s_bit_count, s_shift_reg)
    begin
        case s_state is
            when IDLE =>
                o_ready <= '1';
                s_tx <= '1';
                if i_valid = '1' then
                    s_next_state <= START;
                else
                    s_next_state <= IDLE;
                end if;
            
            when START =>
                o_ready <= '0';
                s_tx <= '0'; -- Start bit
                if s_baud_count = 0 then
                    s_next_state <= DATA;
                else
                    s_next_state <= START;
                end if;
            
            when DATA =>
                o_ready <= '0';
                s_tx <= s_shift_reg(0);
                if s_baud_count = 0 then
                    if s_bit_count = 0 then
                        s_next_state <= STOP;
                    else
                        s_next_state <= DATA;
                    end if;
                else
                    s_next_state <= DATA;
                end if;
            
            when STOP =>
                o_ready <= '0';
                s_tx <= '1'; -- Stop bit
                if s_baud_count = 0 then
                    s_next_state <= DELAY;
                else
                    s_next_state <= STOP;
                end if;
                
            when DELAY =>
                o_ready <= '0';
                s_tx <= '1';
                if s_baud_count = 0 then
                    s_next_state <= IDLE;
                else
                    s_next_state <= DELAY;
                end if;
        end case;
    end process;

end Behavioral;

