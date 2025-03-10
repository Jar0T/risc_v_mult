--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:05:20 01/28/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/MEMORY_CONTROLLER_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMORY_CONTROLLER
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
 
entity MEMORY_CONTROLLER_TB is
end MEMORY_CONTROLLER_TB;
 
architecture behavioral of MEMORY_CONTROLLER_TB is
 
    -- Component Declaration for the Unit Under Test (UUT)

    component MEMORY_CONTROLLER
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_we : in std_logic_vector(3 downto 0);
        i_addr : in std_logic_vector(31 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic;
        o_bank_0_en : out std_logic;
        o_bank_0_we : out std_logic_vector(3 downto 0);
        o_bank_0_addr : out std_logic_vector(31 downto 0);
        o_bank_0_data : out std_logic_vector(31 downto 0);
        i_bank_0_data : in std_logic_vector(31 downto 0);
        i_bank_0_valid : in std_logic;
        o_led_en : out std_logic;
        o_led_data : out std_logic_vector(7 downto 0)
        );
    end component;

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_we : std_logic_vector(3 downto 0) := (others => '0');
    signal i_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal i_bank_0_data : std_logic_vector(31 downto 0) := (others => '0');
    signal i_bank_0_valid : std_logic := '0';

 	--Outputs
    signal o_data : std_logic_vector(31 downto 0);
    signal o_valid : std_logic;
    signal o_bank_0_en : std_logic;
    signal o_bank_0_we : std_logic_vector(3 downto 0);
    signal o_bank_0_addr : std_logic_vector(31 downto 0);
    signal o_bank_0_data : std_logic_vector(31 downto 0);
    signal o_led_en : std_logic;
    signal o_led_data : std_logic_vector(7 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin

	-- Instantiate the Unit Under Test (UUT)
    uut: MEMORY_CONTROLLER Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_en,
        i_we => i_we,
        i_addr => i_addr,
        i_data => i_data,
        o_data => o_data,
        o_valid => o_valid,
        o_bank_0_en => o_bank_0_en,
        o_bank_0_we => o_bank_0_we,
        o_bank_0_addr => o_bank_0_addr,
        o_bank_0_data => o_bank_0_data,
        i_bank_0_data => i_bank_0_data,
        i_bank_0_valid => i_bank_0_valid,
        o_led_en => o_led_en,
        o_led_data => o_led_data
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
        i_bank_0_valid <= '0';
        wait for i_clk_period*1.6;
        i_we <= "0000";
        i_en <= '1';
        i_addr <= X"00000040";
        wait for i_clk_period;
        i_we <= "0000";
        i_en <= '0';
        i_addr <= X"00000000";
        wait for i_clk_period * 3;
        i_bank_0_valid <= '1';
        i_bank_0_data <= X"aaaaaaaa";
        
        wait for i_clk_period;
        i_we <= "1111";
        i_en <= '1';
        i_addr <= X"10000000";
        i_data <= X"12345678";
        wait for i_clk_period;
        i_we <= "0000";
        i_en <= '0';
        i_addr <= X"00000000";
        i_data <= X"00000000";
        wait for i_clk_period;

        wait;
    end process;

end;
