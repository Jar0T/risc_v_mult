----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:54 01/16/2025 
-- Design Name: 
-- Module Name:    MEMORY_CONTROLLER - Behavioral 
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

entity MEMORY_CONTROLLER is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        -- cpu
        i_en : in std_logic;
        i_we : in std_logic_vector (3 downto 0);
        i_addr : in std_logic_vector (31 downto 0);
        i_data : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0) := (others => '0');
        o_valid : out std_logic := '0';
        -- bank 0
        o_bank_0_en : out std_logic := '0';
        o_bank_0_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_bank_0_addr : out std_logic_vector (31 downto 0) := (others => '0');
        o_bank_0_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_bank_0_data : in std_logic_vector (31 downto 0);
        i_bank_0_valid : in std_logic;
        -- bank 1
        o_bank_1_en : out std_logic := '0';
        o_bank_1_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_bank_1_addr : out std_logic_vector (31 downto 0) := (others => '0');
        o_bank_1_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_bank_1_data : in std_logic_vector (31 downto 0);
        i_bank_1_valid : in std_logic;
        -- bank 2
        o_bank_2_en : out std_logic := '0';
        o_bank_2_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_bank_2_addr : out std_logic_vector (31 downto 0) := (others => '0');
        o_bank_2_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_bank_2_data : in std_logic_vector (31 downto 0);
        i_bank_2_valid : in std_logic;
        -- bank 3
        o_bank_3_en : out std_logic := '0';
        o_bank_3_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_bank_3_addr : out std_logic_vector (31 downto 0) := (others => '0');
        o_bank_3_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_bank_3_data : in std_logic_vector (31 downto 0);
        i_bank_3_valid : in std_logic;
        -- mmio
        o_mmio_en : out std_logic := '0';
        o_mmio_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_mmio_addr : out std_logic_vector (13 downto 0) := (others => '0');
        o_mmio_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_mmio_data : in std_logic_vector (31 downto 0);
        i_mmio_valid : in std_logic;
        -- ddr
        o_ddr_en : out std_logic := '0';
        o_ddr_we : out std_logic_vector (3 downto 0) := (others => '0');
        o_ddr_addr : out std_logic_vector (1 downto 0) := (others => '0');
        o_ddr_data : out std_logic_vector (31 downto 0) := (others => '0');
        i_ddr_data : in std_logic_vector (31 downto 0);
        i_ddr_valid : in std_logic
    );
end MEMORY_CONTROLLER;

architecture Behavioral of MEMORY_CONTROLLER is
    
    type t_state is (IDLE, LOAD, STORE, PRESENT);
    signal s_state : t_state := IDLE;
    signal s_next_state : t_state := IDLE;
    
    signal s_valid : std_logic := '0';
    signal s_address : std_logic_vector(31 downto 0) := (others => '0');
    signal s_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_en : std_logic := '0';

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
                    if (s_address(31 downto 14) = X"0000" & "00") then
                        o_data <= i_bank_0_data;
                    elsif (s_address(31 downto 14) = X"0000" & "01") then
                        o_data <= i_bank_1_data;
                    elsif (s_address(31 downto 14) = X"0000" & "10") then
                        o_data <= i_bank_2_data;
                    elsif (s_address(31 downto 14) = X"0000" & "11") then
                        o_data <= i_bank_3_data;
                    elsif (s_address(31 downto 14) = X"2000" & "00") then
                        o_data <= i_ddr_data;
                    elsif (s_address(31 downto 14) = X"1000" & "00") then
                        o_data <= i_mmio_data;
                    end if;
                
                when others =>
            end case;
        end if;
    end process;
    
    s_en <= '0' when s_state = IDLE else
            '1' when s_state = LOAD else
            '1' when s_state = STORE else
            not s_valid when s_state = PRESENT else
            '0';
    
    o_bank_0_en <= s_en when s_address(31 downto 14) = X"0000" & "00" else '0';
    o_bank_1_en <= s_en when s_address(31 downto 14) = X"0000" & "01" else '0';
    o_bank_2_en <= s_en when s_address(31 downto 14) = X"0000" & "10" else '0';
    o_bank_3_en <= s_en when s_address(31 downto 14) = X"0000" & "11" else '0';
    o_mmio_en <= s_en when s_address(31 downto 14) = X"1000" & "00" else '0';
    o_ddr_en <= s_en when s_address(31 downto 14) = X"2000" & "00" else '0';
    
    o_bank_0_we <= s_we;
    o_bank_1_we <= s_we;
    o_bank_2_we <= s_we;
    o_bank_3_we <= s_we;
    o_mmio_we <= s_we;
    o_ddr_we <= s_we;

    o_bank_0_addr <= s_address;
    o_bank_1_addr <= s_address;
    o_bank_2_addr <= s_address;
    o_bank_3_addr <= s_address;
    o_mmio_addr <= s_address(13 downto 0);
    o_ddr_addr <= s_address(3 downto 2);

    o_bank_0_data <= s_i_data;
    o_bank_1_data <= s_i_data;
    o_bank_2_data <= s_i_data;
    o_bank_3_data <= s_i_data;
    o_mmio_data <= s_i_data;
    o_ddr_data <= s_i_data;
    
    s_valid <= i_bank_0_valid when s_address(31 downto 14) = X"0000" & "00" else
               i_bank_1_valid when s_address(31 downto 14) = X"0000" & "01" else
               i_bank_2_valid when s_address(31 downto 14) = X"0000" & "10" else
               i_bank_3_valid when s_address(31 downto 14) = X"0000" & "11" else
               i_mmio_valid when s_address(31 downto 14) = X"1000" & "00" else
               i_ddr_valid when s_address(31 downto 14) = X"2000" & "00" else
               '0';
    
    o_valid <= '1' when s_state = IDLE else '0';

end Behavioral;

