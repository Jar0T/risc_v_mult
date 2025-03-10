----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:59:00 03/06/2025 
-- Design Name: 
-- Module Name:    LPDDR_TOP - Behavioral 
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

entity LPDDR_TOP is
    Port (
        i_ddr_clk : in std_logic;
        i_cpu_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(1 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        mcb3_dram_dq : inout std_logic_vector(15 downto 0);
        mcb3_dram_a : out std_logic_vector(12 downto 0);
        mcb3_dram_ba : out std_logic_vector(1 downto 0);
        mcb3_dram_cke : out std_logic;
        mcb3_dram_ras_n : out std_logic;
        mcb3_dram_cas_n : out std_logic;
        mcb3_dram_we_n : out std_logic;
        mcb3_dram_dm : out std_logic;
        mcb3_dram_udqs : inout std_logic;
        mcb3_rzq : inout std_logic;
        mcb3_dram_udm : out std_logic;
        mcb3_dram_dqs : inout std_logic;
        mcb3_dram_ck : out std_logic;
        mcb3_dram_ck_n : out std_logic
    );
end LPDDR_TOP;

architecture Behavioral of LPDDR_TOP is

    component LPDDR_CONTROLLER
    Generic(
        C3_P0_MASK_SIZE : integer := 4;
        C3_P0_DATA_PORT_SIZE : integer := 32;
        C3_P1_MASK_SIZE : integer := 4;
        C3_P1_DATA_PORT_SIZE : integer := 32;
        C3_MEMCLK_PERIOD : integer := 10000;
        C3_RST_ACT_LOW : integer := 0;
        C3_INPUT_CLK_TYPE : string := "SINGLE_ENDED";
        C3_CALIB_SOFT_IP : string := "TRUE";
        C3_SIMULATION : string := "FALSE";
        DEBUG_EN : integer := 0;
        C3_MEM_ADDR_ORDER : string := "ROW_BANK_COLUMN";
        C3_NUM_DQ_PINS : integer := 16;
        C3_MEM_ADDR_WIDTH : integer := 13;
        C3_MEM_BANKADDR_WIDTH : integer := 2
    );
    Port(
        mcb3_dram_dq : inout std_logic_vector(C3_NUM_DQ_PINS-1 downto 0);
        mcb3_dram_a : out std_logic_vector(C3_MEM_ADDR_WIDTH-1 downto 0);
        mcb3_dram_ba : out std_logic_vector(C3_MEM_BANKADDR_WIDTH-1 downto 0);
        mcb3_dram_cke : out std_logic;
        mcb3_dram_ras_n : out std_logic;
        mcb3_dram_cas_n : out std_logic;
        mcb3_dram_we_n : out std_logic;
        mcb3_dram_dm : out std_logic;
        mcb3_dram_udqs : inout std_logic;
        mcb3_rzq : inout std_logic;
        mcb3_dram_udm : out std_logic;
        c3_sys_clk : in std_logic;
        c3_sys_rst_i : in std_logic;
        c3_calib_done : out std_logic;
        c3_clk0 : out std_logic;
        c3_rst0 : out std_logic;
        mcb3_dram_dqs : inout std_logic;
        mcb3_dram_ck : out std_logic;
        mcb3_dram_ck_n : out std_logic;
        c3_p0_cmd_clk : in std_logic;
        c3_p0_cmd_en : in std_logic;
        c3_p0_cmd_instr : in std_logic_vector(2 downto 0);
        c3_p0_cmd_bl : in std_logic_vector(5 downto 0);
        c3_p0_cmd_byte_addr : in std_logic_vector(29 downto 0);
        c3_p0_cmd_empty : out std_logic;
        c3_p0_cmd_full : out std_logic;
        c3_p0_wr_clk : in std_logic;
        c3_p0_wr_en : in std_logic;
        c3_p0_wr_mask : in std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
        c3_p0_wr_data : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
        c3_p0_wr_full : out std_logic;
        c3_p0_wr_empty : out std_logic;
        c3_p0_wr_count : out std_logic_vector(6 downto 0);
        c3_p0_wr_underrun : out std_logic;
        c3_p0_wr_error : out std_logic;
        c3_p0_rd_clk : in std_logic;
        c3_p0_rd_en : in std_logic;
        c3_p0_rd_data : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
        c3_p0_rd_full : out std_logic;
        c3_p0_rd_empty : out std_logic;
        c3_p0_rd_count : out std_logic_vector(6 downto 0);
        c3_p0_rd_overflow : out std_logic;
        c3_p0_rd_error : out std_logic
    );
    end component;
    
    signal s_calib_done : std_logic := '0';
    
    signal s_cmd_en : std_logic := '0';
    signal s_cmd_instr : std_logic_vector(2 downto 0) := (others => '0');
    signal s_cmd_bl : std_logic_vector(5 downto 0) := (others => '0');
    signal s_cmd_byte_addr : std_logic_vector(29 downto 0) := (others => '0');
    signal s_cmd_empty : std_logic := '0';
    signal s_cmd_full : std_logic := '0';
    
    signal s_wr_en : std_logic := '0';
    signal s_wr_mask : std_logic_vector(3 downto 0) := (others => '0');
    signal s_wr_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_wr_full : std_logic := '0';
    signal s_wr_empty : std_logic := '0';
    signal s_wr_count : std_logic_vector(6 downto 0) := (others => '0');
    signal s_wr_underrun : std_logic := '0';
    signal s_wr_error : std_logic := '0';
    
    signal s_rd_en : std_logic := '0';
    signal s_rd_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_rd_full : std_logic := '0';
    signal s_rd_empty : std_logic := '0';
    signal s_rd_count : std_logic_vector(6 downto 0) := (others => '0');
    signal s_rd_overflow : std_logic := '0';
    signal s_rd_error : std_logic := '0';
    
    signal s_valid : std_logic := '1';

begin
    o_valid <= s_valid;

    Inst_LPDDR_CONTROLLER : LPDDR_CONTROLLER Generic map(
        C3_P0_MASK_SIZE => 4,
        C3_P0_DATA_PORT_SIZE => 32,
        C3_P1_MASK_SIZE => 4,
        C3_P1_DATA_PORT_SIZE => 32,
        C3_MEMCLK_PERIOD => 10000,
        C3_RST_ACT_LOW => 0,
        C3_INPUT_CLK_TYPE => "SINGLE_ENDED",
        C3_CALIB_SOFT_IP => "TRUE",
        C3_SIMULATION => "FALSE",
        DEBUG_EN => 0,
        C3_MEM_ADDR_ORDER => "ROW_BANK_COLUMN",
        C3_NUM_DQ_PINS => 16,
        C3_MEM_ADDR_WIDTH => 13,
        C3_MEM_BANKADDR_WIDTH => 2
    )
    Port map(
        c3_sys_clk => i_ddr_clk,
        c3_sys_rst_i => i_reset,                        

        mcb3_dram_dq => mcb3_dram_dq,  
        mcb3_dram_a => mcb3_dram_a,  
        mcb3_dram_ba => mcb3_dram_ba,
        mcb3_dram_ras_n => mcb3_dram_ras_n,                        
        mcb3_dram_cas_n => mcb3_dram_cas_n,                        
        mcb3_dram_we_n => mcb3_dram_we_n,                          
        mcb3_dram_cke => mcb3_dram_cke,                          
        mcb3_dram_ck => mcb3_dram_ck,                          
        mcb3_dram_ck_n => mcb3_dram_ck_n,       
        mcb3_dram_dqs => mcb3_dram_dqs,                          
        mcb3_dram_udqs => mcb3_dram_udqs,    -- for X16 parts           
        mcb3_dram_udm => mcb3_dram_udm,     -- for X16 parts
        mcb3_dram_dm => mcb3_dram_dm,
        mcb3_rzq => mcb3_rzq,

        c3_clk0	=> open,
        c3_rst0	=> open,
        c3_calib_done => s_calib_done,

        c3_p0_cmd_clk => i_cpu_clk,
        c3_p0_cmd_en => s_cmd_en,
        c3_p0_cmd_instr => s_cmd_instr,
        c3_p0_cmd_bl => s_cmd_bl,
        c3_p0_cmd_byte_addr => s_cmd_byte_addr,
        c3_p0_cmd_empty => s_cmd_empty,
        c3_p0_cmd_full => s_cmd_full,

        c3_p0_wr_clk => i_cpu_clk,
        c3_p0_wr_en => s_wr_en,
        c3_p0_wr_mask => s_wr_mask,
        c3_p0_wr_data => s_wr_data,
        c3_p0_wr_full => s_wr_full,
        c3_p0_wr_empty => s_wr_empty,
        c3_p0_wr_count => s_wr_count,
        c3_p0_wr_underrun => s_wr_underrun,
        c3_p0_wr_error => s_wr_error,

        c3_p0_rd_clk => i_cpu_clk,
        c3_p0_rd_en => s_rd_en,
        c3_p0_rd_data => s_rd_data,
        c3_p0_rd_full => s_rd_full,
        c3_p0_rd_empty => s_rd_empty,
        c3_p0_rd_count => s_rd_count,
        c3_p0_rd_overflow => s_rd_overflow,
        c3_p0_rd_error => s_rd_error
    );
    
    process(i_cpu_clk, i_reset)
    begin
        if i_reset = '1' then
            s_cmd_en <= '0';
            s_wr_en <= '0';
            s_rd_en <= '0';
            s_valid <= '1';
        elsif rising_edge(i_cpu_clk) then
            s_cmd_en <= '0';
            s_wr_en <= '0';
            s_rd_en <= '0';
            s_valid <= '1';
            if i_en = '1' then
                if i_we = "0000" then
                    case i_addr is
                        when "00" =>
                            o_data <= "0000000" &
                                      s_calib_done &
                                      s_rd_count &
                                      s_wr_count &
                                      s_rd_error &
                                      s_wr_error & 
                                      s_rd_overflow & 
                                      s_rd_full & 
                                      s_rd_empty &
                                      s_wr_underrun &
                                      s_wr_full &
                                      s_wr_empty &
                                      s_cmd_full &
                                      s_cmd_empty;
                        when others =>
                            s_rd_en <= '1';
                            s_valid <= '0';
                    end case;
                else
                    case i_addr is
                        when "00" =>
                            s_cmd_byte_addr <= i_data(29 downto 0);
                        when "01" =>
                            s_cmd_bl <= i_data(5 downto 0);
                            s_cmd_instr <= i_data(8 downto 6);
                            s_cmd_en <= i_data(9);
                        when "10" =>
                            s_wr_data <= i_data;
                        when others =>
                            s_wr_mask <= i_data(3 downto 0);
                            s_wr_en <= i_data(4);
                    end case;
                end if;
            end if;
            if s_rd_en = '1' then
                s_rd_en <= '0';
                s_valid <= '1';
                o_data <= s_rd_data;
            end if;
        end if;
    end process;

end Behavioral;

