----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:55 03/09/2025 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
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

entity VGA is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_fifo_data : in std_logic_vector (7 downto 0);
        i_fifo_empty : in std_logic;
        o_fifo_en : out std_logic;
        o_color : out std_logic_vector (7 downto 0);
        o_hsync : out std_logic;
        o_vsync : out std_logic
    );
end VGA;

architecture Behavioral of VGA is

    constant H_ACTIVE : integer := 800;
    constant H_FRONT_PORCH : integer := 56;
    constant H_SYNC_PULSE : integer := 120;
    constant H_BACK_PORCH : integer := 64;
    constant H_TOTAL : integer := H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    
    constant V_ACTIVE : integer := 600;
    constant V_FRONT_PORCH : integer := 37;
    constant V_SYNC_PULSE : integer := 6;
    constant V_BACK_PORCH : integer := 23;
    constant V_TOTAL : integer := V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
    
    signal s_h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal s_v_count : integer range 0 to V_TOTAL - 1 := 0;

    signal s_clk_div : std_logic := '0';
    signal s_fifo_en : std_logic := '0';
    signal s_color : std_logic_vector(7 downto 0) := (others => '0');
    signal s_active, s_hsync, s_vsync : std_logic_vector(1 downto 0) := "00";

begin

    process(i_clk, i_fifo_empty, i_reset)
    begin
        if i_reset = '1' then
            s_clk_div <= '0';
        elsif rising_edge(i_clk) and i_fifo_empty = '0' then
            s_clk_div <= not s_clk_div;
        end if;
    end process;

    process(i_clk, s_clk_div, i_reset)
    begin
        if i_reset = '1' then
            s_h_count <= 0;
            s_v_count <= 0;
        elsif rising_edge(i_clk) and s_clk_div = '1' and i_fifo_empty = '0' then
            if s_h_count < H_TOTAL - 1 then
                s_h_count <= s_h_count + 1;
            else
                s_h_count <= 0;
                if s_v_count < V_TOTAL - 1 then
                    s_v_count <= s_v_count + 1;
                else
                    s_v_count <= 0;
                end if;
            end if;
        end if;
    end process;
    
    process(i_clk, s_clk_div, i_reset)
    begin
        if i_reset = '1' then
            s_hsync <= "00";
            s_vsync <= "00";
        elsif rising_edge(i_clk) and s_clk_div = '1' then
            if s_h_count >= (H_ACTIVE + H_FRONT_PORCH) and s_h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE) then
                s_hsync(0) <= '0';
            else
                s_hsync(0) <= '1';
            end if;
            
            if s_v_count >= (V_ACTIVE + V_FRONT_PORCH) and s_v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE) then
                s_vsync(0) <= '0';
            else
                s_vsync(0) <= '1';
            end if;
            
            s_hsync(1) <= s_hsync(0);
            s_vsync(1) <= s_vsync(0);
        end if;
    end process;
    
    process(i_clk, s_fifo_en)
    begin
        if rising_edge(i_clk) and s_clk_div = '1' then
            s_color <= i_fifo_data;
            if s_h_count < H_ACTIVE and s_v_count < V_ACTIVE then
                s_active(0) <= '1';
            else
                s_active(0) <= '0';
            end if;
            s_active(1) <= s_active(0);
        end if;
    end process;
    
    s_fifo_en <= '1' when s_h_count < H_ACTIVE and s_v_count < V_ACTIVE and i_fifo_empty = '0' and s_clk_div = '1' else '0';
    o_fifo_en <= s_fifo_en;
    o_color <= s_color when s_active(1) = '1' else X"00";
    o_hsync <= s_hsync(1);
    o_vsync <= s_vsync(1);

end Behavioral;

