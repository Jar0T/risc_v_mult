-- TestBench Template 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity CPU_TB is
end CPU_TB;

architecture behavior of CPU_TB is 

    -- Component Declaration for the Unit Under Test (UUT)
    
    component CPU
    Port(
        i_clk : in std_logic;    
        i_reset_n : in std_logic;
        o_led : out std_logic_vector(7 downto 0);
        o_reg : out std_logic_vector(7 downto 0);
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
    end component;

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset_n : std_logic := '1';
    signal i_rx : std_logic := '1';
    signal i_sd_miso : std_logic := '0';
    
    --Outputs
    signal o_led : std_logic_vector(7 downto 0) := (others => '0');
    signal o_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal o_tx : std_logic := '0';
    signal o_sd_sclk : std_logic := '0';
    signal o_sd_mosi : std_logic := '0';
    signal mcb3_dram_a : std_logic_vector(12 downto 0) := (others => '0');
    signal mcb3_dram_ba : std_logic_vector(1 downto 0) := (others => '0');
    signal mcb3_dram_cke : std_logic := '0';
    signal mcb3_dram_ras_n : std_logic := '0';
    signal mcb3_dram_cas_n : std_logic := '0';
    signal mcb3_dram_we_n : std_logic := '0';
    signal mcb3_dram_dm : std_logic := '0';
    signal mcb3_dram_udm : std_logic := '0';
    signal mcb3_dram_ck : std_logic := '0';
    signal mcb3_dram_ck_n : std_logic := '0';
    
    --In/Out
    signal mcb3_dram_dq : std_logic_vector(15 downto 0) := (others => '0');
    signal mcb3_dram_udqs : std_logic := '0';
    signal mcb3_rzq : std_logic := '0';
    signal mcb3_dram_dqs : std_logic := '0';
    
    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
    
    signal mcb3_dram_dqs_vector : std_logic_vector(1 downto 0);
    signal mcb3_dram_dm_vector : std_logic_vector(1 downto 0);
    signal mcb3_command : std_logic_vector(2 downto 0);
    signal mcb3_enable1 : std_logic;
    signal mcb3_enable2 : std_logic;
    
    component lpddr_model_c3
    Port(
        addr : in std_logic_vector(12 downto 0);
        ba : in std_logic_vector(1 downto 0);
        clk : in std_logic;
        clk_n : in std_logic;
        cke : in std_logic;
        cs_n : in std_logic;
        ras_n : in std_logic;
        cas_n : in std_logic;
        we_n : in std_logic;
        dm : in std_logic_vector(1 downto 0);       
        dq : inout std_logic_vector(15 downto 0);
        dqs : inout std_logic_vector(1 downto 0)
        );
    end component;

BEGIN

    rzq_pulldown3 : PULLDOWN port map(O => mcb3_rzq);

    -- Instantiate the Unit Under Test (UUT)
    uut: CPU Port map(
        i_clk => i_clk,
        i_reset_n => i_reset_n,
        o_led => o_led,
        o_reg => o_reg,
        i_rx => i_rx,
        o_tx => o_tx,
        o_sd_sclk => o_sd_sclk,
        o_sd_mosi => o_sd_mosi,
        i_sd_miso => i_sd_miso,
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
    
    mcb3_dram_dqs_vector(1 downto 0) <= (mcb3_dram_udqs & mcb3_dram_dqs)
                                        when (mcb3_enable2 = '0' and mcb3_enable1 = '0')
                                        else "ZZ";
    
    mcb3_dram_dqs <= mcb3_dram_dqs_vector(0) when mcb3_enable1 = '1' else 'Z';
    mcb3_dram_udqs <= mcb3_dram_dqs_vector(1) when mcb3_enable1 = '1' else 'Z';
    
    mcb3_dram_dm_vector <= (mcb3_dram_udm & mcb3_dram_dm);
    
    mcb3_command <= (mcb3_dram_ras_n & mcb3_dram_cas_n & mcb3_dram_we_n);
    
    process(mcb3_dram_ck)
    begin
        if rising_edge(mcb3_dram_ck) then
            if i_reset_n = '0' then
                mcb3_enable1 <= '0';
                mcb3_enable2 <= '0';
            elsif mcb3_command = "100" then
                mcb3_enable2 <= '0';
            elsif mcb3_command = "101" then
                mcb3_enable2 <= '1';
            else
                mcb3_enable2 <= mcb3_enable2;
            end if;
            mcb3_enable1 <= mcb3_enable2;
        end if;
    end process;
    
    u_mem_c3 : lpddr_model_c3 port map(
        Clk => mcb3_dram_ck,
        Clk_n => mcb3_dram_ck_n,
        Cke => mcb3_dram_cke,
        Cs_n => '0',
        Ras_n => mcb3_dram_ras_n,
        Cas_n => mcb3_dram_cas_n,
        We_n => mcb3_dram_we_n,
        Dm => mcb3_dram_dm_vector ,
        Ba => mcb3_dram_ba,
        Addr => mcb3_dram_a,
        Dq => mcb3_dram_dq,
        Dqs => mcb3_dram_dqs_vector
        );
    
    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= not i_clk;
        wait for i_clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin
        -- insert stimulus here
        
        wait;
    end process;

END;
