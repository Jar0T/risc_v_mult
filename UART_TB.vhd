--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:48:30 02/03/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/UART_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
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
 
entity UART_TB is
end UART_TB;
 
architecture behavior of UART_TB is

    -- Component Declaration for the Unit Under Test (UUT)
 
    component UART
    Port(
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_en : in  std_logic;
        i_we : in  std_logic;
        i_addr : in  std_logic_vector(1 downto 0);
        i_data : in  std_logic_vector(7 downto 0);
        o_data : out  std_logic_vector(7 downto 0);
        o_valid : out  std_logic;
        i_rx : in  std_logic;
        o_tx : out  std_logic
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_we : std_logic := '0';
    signal i_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal i_data : std_logic_vector(7 downto 0) := (others => '0');
    signal i_rx : std_logic := '0';

 	--Outputs
    signal o_data : std_logic_vector(7 downto 0);
    signal o_valid : std_logic;
    signal o_tx : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: UART Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_en,
        i_we => i_we,
        i_addr => i_addr,
        i_data => i_data,
        o_data => o_data,
        o_valid => o_valid,
        i_rx => i_rx,
        o_tx => o_tx
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
        i_rx <= '1';
        wait for i_clk_period * 10.6;
        i_data <= X"AA";
        i_en <= '1';
        i_we <= '1';
        i_addr <= "00";
        wait for i_clk_period;
        i_data <= X"55";
        wait for i_clk_period;
        i_data <= X"99";
        wait for i_clk_period;
        i_data <= X"66";
        wait for i_clk_period;
        i_en <= '0';
        i_we <= '0';
        
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        
        wait for i_clk_period * 10;
        
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        i_rx <= '0';
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        
        wait for i_clk_period * 10;
        
        i_addr <= "00";
        i_en <= '1';
        i_we <= '0';
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_en <= '0';

        wait;
    end process;

end;
