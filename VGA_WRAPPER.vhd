----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:28 03/09/2025 
-- Design Name: 
-- Module Name:    VGA_WRAPPER - Behavioral 
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

entity VGA_WRAPPER is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_calib_done : in std_logic;
        o_cmd_clk : out std_logic;
        o_cmd_en : out std_logic;
        o_cmd_instr : out std_logic_vector(2 downto 0);
        o_cmd_bl : out std_logic_vector(5 downto 0);
        o_cmd_byte_addr : out std_logic_vector(29 downto 0);
        i_cmd_empty : in std_logic;
        o_rd_clk : out std_logic;
        o_rd_en : out std_logic;
        i_rd_data : in std_logic_vector(31 downto 0);
        i_rd_empty : in std_logic;
        i_rd_error : in std_logic;
        o_color : out std_logic_vector (7 downto 0);
        o_hsync : out std_logic;
        o_vsync : out std_logic
    );
end VGA_WRAPPER;

architecture Behavioral of VGA_WRAPPER is

    component VGA
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_fifo_data : in std_logic_vector(7 downto 0);
        i_fifo_empty : in std_logic;          
        o_fifo_en : out std_logic;
        o_color : out std_logic_vector(7 downto 0);
        o_hsync : out std_logic;
        o_vsync : out std_logic
        );
    end component;
    
    component VGA_FIFO
    Port (
        rst : in std_logic;
        wr_clk : in std_logic;
        rd_clk : in std_logic;
        din : in std_logic_vector(31 downto 0);
        wr_en : in std_logic;
        rd_en : in std_logic;
        dout : out std_logic_vector(7 downto 0);
        full : out std_logic;
        empty : out std_logic
    );
    end component;
    
    signal s_color : std_logic_vector(7 downto 0) := (others => '0');
    signal s_fifo_rd_en, s_fifo_wr_en : std_logic := '0';
    signal s_fifo_empty, s_fifo_full : std_logic := '0';
    signal s_addr : integer range 0 to 1875 := 0;

begin

    Inst_VGA: VGA Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_fifo_data => s_color,
        i_fifo_empty => s_fifo_empty,
        o_fifo_en => s_fifo_rd_en,
        o_color => o_color,
        o_hsync => o_hsync,
        o_vsync => o_vsync
    );
    
    Inst_VGA_FIFO : VGA_FIFO
    PORT MAP (
        rst => i_reset,
        wr_clk => i_clk,
        rd_clk => i_clk,
        din => i_rd_data,
        wr_en => s_fifo_wr_en,
        full => s_fifo_full,
        dout => s_color,
        rd_en => s_fifo_rd_en,
        empty => s_fifo_empty
    );
    
    process(i_clk, i_calib_done)
    begin
        if rising_edge(i_clk) and i_calib_done = '1' then
            if i_rd_empty = '1' and i_cmd_empty = '1' then
                o_cmd_en <= '1';
            else
                o_cmd_en <= '0';
            end if;
        end if;
    end process;
    
    o_cmd_clk <= i_clk;
    o_cmd_instr <= "001";
    o_cmd_bl <= "111111";
    o_cmd_byte_addr <= std_logic_vector(to_unsigned(s_addr, o_cmd_byte_addr'length - 8)) & X"00";
    o_rd_clk <= i_clk;

end Behavioral;

