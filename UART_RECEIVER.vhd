----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:10:44 02/03/2025 
-- Design Name: 
-- Module Name:    UART_RECEIVER - Behavioral 
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

entity UART_RECEIVER is
    Generic (
        g_clk_freq : integer := 100_000_000;    -- 100 MHz
        g_baud_rate : integer := 19200
    );
    Port (
        i_clk : in  STD_LOGIC;
        i_reset : in  STD_LOGIC;
        i_rx : in  STD_LOGIC;
        i_full : in  STD_LOGIC;
        o_data : out  STD_LOGIC_VECTOR (7 downto 0);
        o_valid : out  STD_LOGIC
    );
end UART_RECEIVER;

architecture Behavioral of UART_RECEIVER is

    constant c_baud_ticks : integer := g_clk_freq / g_baud_rate;
    
    type t_state is (IDLE, START, DATA, STOP);
    signal s_state, s_next_state : t_state := IDLE;
    signal s_baud_count  : integer range 0 to c_baud_ticks-1 := c_baud_ticks - 1;
    signal s_bit_count   : integer range 0 to 7 := 7;
    signal s_shift_reg   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_sample_reg  : std_logic := '1';
    signal s_valid_reg   : std_logic := '0';

begin
    o_valid <= s_valid_reg;
    o_data  <= s_shift_reg;
    
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
                s_shift_reg <= (others => '0');
            elsif s_state = DATA then
                if s_baud_count = 0 then
                    if s_bit_count = 0 then
                        s_bit_count <= 7;
                    else
                        s_bit_count <= s_bit_count - 1;
                    end if;
                elsif s_baud_count = c_baud_ticks / 2 then
                    s_shift_reg <= i_rx & s_shift_reg(7 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    process(s_state, i_rx, s_baud_count, s_bit_count, i_full)
    begin
        case s_state is
            when IDLE =>
                s_valid_reg <= '0';
                if i_rx = '0' then
                    s_next_state <= START;
                else
                    s_next_state <= IDLE;
                end if;
            
            when START =>
                s_valid_reg <= '0';
                if s_baud_count = 0 then
                    s_next_state <= DATA;
                else
                    s_next_state <= START;
                end if;
            
            when DATA =>
                s_valid_reg <= '0';
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
                if s_baud_count = 0 then
                    if i_full = '0' then
                        s_valid_reg <= '1';
                    else
                        s_valid_reg <= '0';
                    end if;
                    s_next_state <= IDLE;
                else
                    s_valid_reg <= '0';
                    s_next_state <= STOP;
                end if;
        end case;
    end process;

end Behavioral;

