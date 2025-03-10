--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:00:46 02/05/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/SPI_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity SPI_TB is
end SPI_TB;
 
architecture behavior of SPI_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component SPI
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_cpol : in std_logic;
        i_cpha : in std_logic;
        i_clk_div : in integer;
        i_data : in std_logic_vector(7 downto 0);
        o_ready : out std_logic;
        i_execute : in std_logic;
        o_data : out std_logic_vector(7 downto 0);
        o_valid : out std_logic;
        o_sclk : out std_logic;
        o_mosi : out std_logic;
        i_miso : in std_logic
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_cpol : std_logic := '0';
    signal i_cpha : std_logic := '0';
    signal i_clk_div : integer := 0;
    signal i_data : std_logic_vector(7 downto 0) := (others => '0');
    signal i_execute : std_logic := '0';
    signal i_miso : std_logic := '0';

 	--Outputs
    signal o_ready : std_logic;
    signal o_data : std_logic_vector(7 downto 0);
    signal o_valid : std_logic;
    signal o_sclk : std_logic;
    signal o_mosi : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;

begin
 
	-- Instantiate the Unit Under Test (UUT)
    uut: SPI Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_cpol => i_cpol,
        i_cpha => i_cpha,
        i_clk_div => i_clk_div,
        i_data => i_data,
        o_ready => o_ready,
        i_execute => i_execute,
        o_data => o_data,
        o_valid => o_valid,
        o_sclk => o_sclk,
        o_mosi => o_mosi,
        i_miso => i_miso
        );

    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= '0';
        wait for i_clk_period/2;
        i_clk <= '1';
        wait for i_clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        i_clk_div <= 1;
        wait for i_clk_period * 10;
        i_data <= X"AA";
        i_execute <= '1';
        wait for i_clk_period;
        i_execute <= '0';
        wait for i_clk_period * 4;
        i_cpha <= '1';
        wait for i_clk_period * 2;
        i_cpha <= '0';
        wait for i_clk_period * 32;
        i_cpha <= '1';
        wait for i_clk_period * 6;
        i_data <= X"55";
        i_execute <= '1';
        wait for i_clk_period;
        i_execute <= '0';
        wait for i_clk_period * 40;
        i_cpol <= '1';
        wait for i_clk_period * 4;
        i_execute <= '1';
        wait for i_clk_period;
        i_execute <= '0';

        wait;
    end process;
    
    i_miso <= o_mosi;

end;
