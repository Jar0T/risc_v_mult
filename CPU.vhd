----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:48:00 01/18/2025 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
    Port (
        i_clk : in std_logic;
        i_reset_n : in std_logic;
        o_led : out std_logic_vector(7 downto 0) := X"00";
        o_reg : out std_logic_vector(7 downto 0) := X"FF";
        i_rx : in std_logic;
        o_tx : out std_logic;
        o_sd_sclk : out std_logic;
        o_sd_mosi : out std_logic;
        i_sd_miso : in std_logic;
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
end CPU;

architecture Behavioral of CPU is
    
    component MAIN_PLL
    Port(
        -- Clock in ports
        CLK_IN1 : in std_logic;
        -- Clock out ports
        cpu_clk : out std_logic;
        ddr_clk : out std_logic;
        -- Status and control signals
        RESET : in std_logic;
        LOCKED : out std_logic
        );
    end component;

    component HART
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_mem_data : in std_logic_vector(31 downto 0);
        i_mem_valid : in std_logic;          
        o_mem_en : out std_logic;
        o_mem_we : out std_logic_vector(3 downto 0);
        o_mem_addr : out std_logic_vector(31 downto 0);
        o_mem_data : out std_logic_vector(31 downto 0);
        i_ext_int : in std_logic;
        i_ext_tval : in std_logic_vector(31 downto 0);
        i_tim_int : in std_logic;
        i_tim_tval : in std_logic_vector(31 downto 0)
        );
    end component;
    
    component MEMORY_CONTROLLER
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        -- cpu
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(31 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        -- bank 0
        o_bank_0_en : out std_logic;
        o_bank_0_we : out std_logic_vector(3 downto 0);
        o_bank_0_addr : out std_logic_vector(31 downto 0);
        o_bank_0_data : out std_logic_vector(31 downto 0);
        i_bank_0_data : in std_logic_vector(31 downto 0);
        i_bank_0_valid : in std_logic;
        -- bank 1
        o_bank_1_en : out std_logic;
        o_bank_1_we : out std_logic_vector(3 downto 0);
        o_bank_1_addr : out std_logic_vector (31 downto 0);
        o_bank_1_data : out std_logic_vector (31 downto 0);
        i_bank_1_data : in std_logic_vector (31 downto 0);
        i_bank_1_valid : in std_logic;
        -- bank 2
        o_bank_2_en : out std_logic;
        o_bank_2_we : out std_logic_vector(3 downto 0);
        o_bank_2_addr : out std_logic_vector (31 downto 0);
        o_bank_2_data : out std_logic_vector (31 downto 0);
        i_bank_2_data : in std_logic_vector (31 downto 0);
        i_bank_2_valid : in std_logic;
        -- bank 3
        o_bank_3_en : out std_logic;
        o_bank_3_we : out std_logic_vector(3 downto 0);
        o_bank_3_addr : out std_logic_vector (31 downto 0);
        o_bank_3_data : out std_logic_vector (31 downto 0);
        i_bank_3_data : in std_logic_vector (31 downto 0);
        i_bank_3_valid : in std_logic;
        -- mmio
        o_mmio_en : out std_logic;
        o_mmio_we : out std_logic_vector (3 downto 0);
        o_mmio_addr : out std_logic_vector (13 downto 0);
        o_mmio_data : out std_logic_vector (31 downto 0);
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
    end component;
    
    component MMIO_CONTROLLER
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(13 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        -- uart_0
        o_uart_0_en : out std_logic;
        o_uart_0_we : out std_logic_vector(3 downto 0);
        o_uart_0_addr : out std_logic_vector(1 downto 0);
        o_uart_0_data : out std_logic_vector(31 downto 0);
        i_uart_0_data : in std_logic_vector(31 downto 0);
        i_uart_0_valid : std_logic;
        -- spi_0
        o_spi_0_en : out std_logic;
        o_spi_0_we : out std_logic_vector(3 downto 0);
        o_spi_0_data : out std_logic_vector(31 downto 0);
        i_spi_0_data : in std_logic_vector(31 downto 0);
        -- leds
        o_led_en : out std_logic;
        o_led_data : out std_logic_vector (7 downto 0);
        -- reg
        o_reg_en : out std_logic;
        o_reg_data : out std_logic_vector (7 downto 0);
        -- timer 0
        o_timer_0_en : out std_logic := '0';
        o_timer_0_we : out std_logic_vector(3 downto 0) := (others => '0');
        o_timer_0_addr : out std_logic := '0';
        o_timer_0_data : out std_logic_vector(31 downto 0) := (others => '0');
        i_timer_0_data : in std_logic_vector(31 downto 0)
    );
    end component;
    
    component RAM
    Port(
        i_clk : in std_logic;
        i_en_a : in std_logic;
        i_addr_a : in std_logic_vector(11 downto 0);
        i_we_a : in std_logic_vector(3 downto 0);
        i_data_a : in std_logic_vector(31 downto 0);
        i_clk_b : in std_logic;
        i_en_b : in std_logic;
        i_addr_b : in std_logic_vector(11 downto 0);
        i_we_b : in std_logic_vector(3 downto 0);
        i_data_b : in std_logic_vector(31 downto 0);          
        o_data_a : out std_logic_vector(31 downto 0);
        o_data_b : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component LPDDR_TOP
    Port(
        i_ddr_clk : in std_logic;
        i_cpu_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(1 downto 0);
        i_data : in std_logic_vector(31 downto 0);    
        mcb3_dram_dq : inout std_logic_vector(15 downto 0);
        mcb3_dram_udqs : inout std_logic;
        mcb3_rzq : inout std_logic;
        mcb3_dram_dqs : inout std_logic;      
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        mcb3_dram_a : out std_logic_vector(12 downto 0);
        mcb3_dram_ba : out std_logic_vector(1 downto 0);
        mcb3_dram_cke : out std_logic;
        mcb3_dram_ras_n : out std_logic;
        mcb3_dram_cas_n : out std_logic;
        mcb3_dram_we_n : out std_logic;
        mcb3_dram_dm : out std_logic;
        mcb3_dram_udm : out std_logic;
        mcb3_dram_ck : out std_logic;
        mcb3_dram_ck_n : out std_logic
        );
    end component;
    
    component UART
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(1 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        i_rx : in std_logic;          
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        o_tx : out std_logic
        );
    end component;
    
    component SPI_TOP
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        i_miso : in std_logic;          
        o_data : out std_logic_vector(31 downto 0);
        o_sclk : out std_logic;
        o_mosi : out std_logic
        );
	end component;
    
    component TIMER_64
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic;
        i_data : in std_logic_vector(31 downto 0);          
        o_data : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component INTERRUPT_UNIT
    Generic(
        NUM_INTERRUPTS : integer
    );
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_int_src : in std_logic_vector(0 to 0);          
        o_int : out std_logic;
        o_tval : out std_logic_vector(31 downto 0)
        );
	end component;
    
    signal s_hart_mem_en : std_logic := '0';
    signal s_hart_mem_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_hart_mem_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_hart_mem_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_hart_mem_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_hart_mem_valid : std_logic := '0';
    
    signal s_mmio_en : std_logic := '0';
    signal s_mmio_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_mmio_addr : std_logic_vector(13 downto 0) := (others => '0');
    signal s_mmio_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_mmio_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_mmio_valid : std_logic := '0';
    
    signal s_bank_0_en : std_logic := '0';
    signal s_bank_0_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_bank_0_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_0_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_0_i_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_bank_1_en : std_logic := '0';
    signal s_bank_1_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_bank_1_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_1_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_1_i_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_bank_2_en : std_logic := '0';
    signal s_bank_2_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_bank_2_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_2_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_2_i_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_bank_3_en : std_logic := '0';
    signal s_bank_3_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_bank_3_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_3_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_bank_3_i_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_ddr_en : std_logic := '0';
    signal s_ddr_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_ddr_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal s_ddr_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_ddr_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_ddr_valid : std_logic := '0';
    
    signal s_uart_en : std_logic := '0';
    signal s_uart_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_uart_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal s_uart_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_uart_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_uart_valid : std_logic := '0';
    
    signal s_spi_en : std_logic := '0';
    signal s_spi_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_spi_i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_spi_o_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_led_en : std_logic := '0';
    signal s_led_data : std_logic_vector(7 downto 0) := (others => '0');
    
    signal s_reg_en : std_logic := '0';
    signal s_reg_data : std_logic_vector(7 downto 0) := (others => '0');
    
    signal s_timer_0_en : std_logic := '0';
    signal s_timer_0_we : std_logic_vector(3 downto 0) := (others => '0');
    signal s_timer_0_addr : std_logic := '0';
    signal s_timer_0_o_data : std_logic_vector(31 downto 0) := (others => '0');
    signal s_timer_0_i_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_ext_int, s_tim_int : std_logic := '0';
    signal s_ext_tval, s_tim_tval : std_logic_vector(31 downto 0) := (others => '0');
    
    signal s_reset, s_system_reset : std_logic := '0';
    signal s_cpu_clk, s_ddr_clk : std_logic := '0';
    signal s_pll_locked : std_logic := '0';

begin

    s_reset <= not i_reset_n;
    s_system_reset <= s_reset or (not s_pll_locked);
    
    Inst_PLL : MAIN_PLL Port map(-- Clock in ports
        CLK_IN1 => i_clk,
        -- Clock out ports
        cpu_clk => s_cpu_clk,
        ddr_clk => s_ddr_clk,
        -- Status and control signals
        RESET  => s_reset,
        LOCKED => s_pll_locked
    );

    Inst_HART: HART Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        o_mem_en => s_hart_mem_en,
        o_mem_we => s_hart_mem_we,
        o_mem_addr => s_hart_mem_addr,
        o_mem_data => s_hart_mem_o_data,
        i_mem_data => s_hart_mem_i_data,
        i_mem_valid => s_hart_mem_valid,
        i_ext_int => s_ext_int,
        i_ext_tval => s_ext_tval,
        i_tim_int => s_tim_int,
        i_tim_tval => s_tim_tval
    );
    
    Inst_MEMORY_CONTROLLER: MEMORY_CONTROLLER Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        -- cpu
        i_en => s_hart_mem_en,
        i_we => s_hart_mem_we,
        i_addr => s_hart_mem_addr,
        i_data => s_hart_mem_o_data,
        o_data => s_hart_mem_i_data,
        o_valid => s_hart_mem_valid,
        -- bank 0
        o_bank_0_en => s_bank_0_en,
        o_bank_0_we => s_bank_0_we,
        o_bank_0_addr => s_bank_0_addr,
        o_bank_0_data => s_bank_0_o_data,
        i_bank_0_data => s_bank_0_i_data,
        i_bank_0_valid => '1',
        -- bank 1
        o_bank_1_en => s_bank_1_en,
        o_bank_1_we => s_bank_1_we,
        o_bank_1_addr => s_bank_1_addr,
        o_bank_1_data => s_bank_1_o_data,
        i_bank_1_data => s_bank_1_i_data,
        i_bank_1_valid => '1',
        -- bank 2
        o_bank_2_en => s_bank_2_en,
        o_bank_2_we => s_bank_2_we,
        o_bank_2_addr => s_bank_2_addr,
        o_bank_2_data => s_bank_2_o_data,
        i_bank_2_data => s_bank_2_i_data,
        i_bank_2_valid => '1',
        -- bank 3
        o_bank_3_en => s_bank_3_en,
        o_bank_3_we => s_bank_3_we,
        o_bank_3_addr => s_bank_3_addr,
        o_bank_3_data => s_bank_3_o_data,
        i_bank_3_data => s_bank_3_i_data,
        i_bank_3_valid => '1',
        -- mmio
        o_mmio_en => s_mmio_en,
        o_mmio_we => s_mmio_we,
        o_mmio_addr => s_mmio_addr,
        o_mmio_data => s_mmio_o_data,
        i_mmio_data => s_mmio_i_data,
        i_mmio_valid => s_mmio_valid,
        -- ddr
        o_ddr_en => s_ddr_en,
        o_ddr_we => s_ddr_we,
        o_ddr_addr => s_ddr_addr,
        o_ddr_data => s_ddr_o_data,
        i_ddr_data => s_ddr_i_data,
        i_ddr_valid => s_ddr_valid
    );
    
    Inst_MMIO_CONTROLLER: MMIO_CONTROLLER Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_en => s_mmio_en,
        i_we => s_mmio_we,
        i_addr => s_mmio_addr,
        i_data => s_mmio_o_data,
        o_data => s_mmio_i_data,
        o_valid => s_mmio_valid,
        -- uart_0
        o_uart_0_en => s_uart_en,
        o_uart_0_we => s_uart_we,
        o_uart_0_addr => s_uart_addr,
        o_uart_0_data => s_uart_o_data,
        i_uart_0_data => s_uart_i_data,
        i_uart_0_valid => s_uart_valid,
        -- spi_0
        o_spi_0_en => s_spi_en,
        o_spi_0_we => s_spi_we,
        o_spi_0_data => s_spi_o_data,
        i_spi_0_data => s_spi_i_data,
        -- leds
        o_led_en => s_led_en,
        o_led_data => s_led_data,
        -- reg
        o_reg_en => s_reg_en,
        o_reg_data => s_reg_data,
        -- timer 0
        o_timer_0_en => s_timer_0_en,
        o_timer_0_we => s_timer_0_we,
        o_timer_0_addr => s_timer_0_addr,
        o_timer_0_data => s_timer_0_o_data,
        i_timer_0_data => s_timer_0_i_data
    );
    
    Inst_RAM_0: RAM Port map(
        i_clk => s_cpu_clk,
        i_en_a => s_bank_0_en,
        i_addr_a => s_bank_0_addr(13 downto 2),
        i_we_a => s_bank_0_we,
        i_data_a => s_bank_0_o_data,
        o_data_a => s_bank_0_i_data,
        i_clk_b => s_cpu_clk,
        i_en_b => '0',
        i_addr_b => X"000",
        i_we_b => "0000",
        i_data_b => X"00000000",
        o_data_b => open
    );
    
    Inst_RAM_1: RAM Port map(
        i_clk => s_cpu_clk,
        i_en_a => s_bank_1_en,
        i_addr_a => s_bank_1_addr(13 downto 2),
        i_we_a => s_bank_1_we,
        i_data_a => s_bank_1_o_data,
        o_data_a => s_bank_1_i_data,
        i_clk_b => s_cpu_clk,
        i_en_b => '0',
        i_addr_b => X"000",
        i_we_b => "0000",
        i_data_b => X"00000000",
        o_data_b => open
    );
    
    Inst_RAM_2: RAM Port map(
        i_clk => s_cpu_clk,
        i_en_a => s_bank_2_en,
        i_addr_a => s_bank_2_addr(13 downto 2),
        i_we_a => s_bank_2_we,
        i_data_a => s_bank_2_o_data,
        o_data_a => s_bank_2_i_data,
        i_clk_b => s_cpu_clk,
        i_en_b => '0',
        i_addr_b => X"000",
        i_we_b => "0000",
        i_data_b => X"00000000",
        o_data_b => open
    );
    
    Inst_RAM_3: RAM Port map(
        i_clk => s_cpu_clk,
        i_en_a => s_bank_3_en,
        i_addr_a => s_bank_3_addr(13 downto 2),
        i_we_a => s_bank_3_we,
        i_data_a => s_bank_3_o_data,
        o_data_a => s_bank_3_i_data,
        i_clk_b => s_cpu_clk,
        i_en_b => '0',
        i_addr_b => X"000",
        i_we_b => "0000",
        i_data_b => X"00000000",
        o_data_b => open
    );
    
    Inst_LPDDR_TOP: LPDDR_TOP PORT MAP(
        i_ddr_clk => s_ddr_clk,
        i_cpu_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_en => s_ddr_en,
        i_we => s_ddr_we,
        i_addr => s_ddr_addr,
        i_data => s_ddr_o_data,
        o_data => s_ddr_i_data,
        o_valid => s_ddr_valid,
        mcb3_dram_dq => mcb3_dram_dq,
        mcb3_dram_a => mcb3_dram_a,
        mcb3_dram_ba => mcb3_dram_ba,
        mcb3_dram_cke => mcb3_dram_cke,
        mcb3_dram_ras_n => mcb3_dram_ras_n,
        mcb3_dram_cas_n => mcb3_dram_cas_n,
        mcb3_dram_we_n => mcb3_dram_we_n,
        mcb3_dram_dm => mcb3_dram_dm,
        mcb3_dram_udqs => mcb3_dram_udqs,
        mcb3_rzq => mcb3_rzq,
        mcb3_dram_udm => mcb3_dram_udm,
        mcb3_dram_dqs => mcb3_dram_dqs,
        mcb3_dram_ck => mcb3_dram_ck,
        mcb3_dram_ck_n => mcb3_dram_ck_n
	);
    
    Inst_UART: UART Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_en => s_uart_en,
        i_we => s_uart_we,
        i_addr => s_uart_addr,
        i_data => s_uart_o_data,
        o_data => s_uart_i_data,
        o_valid => s_uart_valid,
        i_rx => i_rx,
        o_tx => o_tx
    );
    
    Inst_SPI_TOP: SPI_TOP Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_en => s_spi_en,
        i_we => s_spi_we,
        i_data => s_spi_o_data,
        o_data => s_spi_i_data,
        o_sclk => o_sd_sclk,
        o_mosi => o_sd_mosi,
        i_miso => i_sd_miso
    );
    
    Inst_TIMER_64: TIMER_64 Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_en => s_timer_0_en,
        i_we => s_timer_0_we,
        i_addr => s_timer_0_addr,
        i_data => s_timer_0_o_data,
        o_data => s_timer_0_i_data
    );
    
    Inst_EXT_INTERRUPT_UNIT: INTERRUPT_UNIT Generic map(
        NUM_INTERRUPTS => 1
    )
    Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_int_src => "0",
        o_int => s_ext_int,
        o_tval => s_ext_tval
	);
    
    Inst_TIM_INTERRUPT_UNIT: INTERRUPT_UNIT Generic map(
        NUM_INTERRUPTS => 1
    )
    Port map(
        i_clk => s_cpu_clk,
        i_reset => s_system_reset,
        i_int_src => "0",
        o_int => s_tim_int,
        o_tval => s_tim_tval
	);
    
    process(s_cpu_clk, s_led_en)
    begin
        if rising_edge(s_cpu_clk) then
            if s_led_en = '1' then
                o_led <= s_led_data;
            elsif s_reg_en = '1' then
                o_reg <= s_reg_data;
            end if;
        end if;
    end process;

end Behavioral;

