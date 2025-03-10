--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:36:12 02/03/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/UART_RECEIVER_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_RECEIVER
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
 
entity UART_RECEIVER_TB is
end UART_RECEIVER_TB;
 
architecture behavior of UART_RECEIVER_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component UART_RECEIVER
    Generic (
        g_clk_freq : integer;
        g_baud_rate : integer
        );
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_rx : in std_logic;
        i_full : in std_logic;
        o_data : out std_logic_vector(7 downto 0);
        o_valid : out std_logic
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_rx : std_logic := '0';
    signal i_full : std_logic := '0';

 	--Outputs
    signal o_data : std_logic_vector(7 downto 0);
    signal o_valid : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut: UART_RECEIVER Generic map (
        g_clk_freq => 100_000_000,
        g_baud_rate => 20_000_000
        )
    Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_rx => i_rx,
        i_full => i_full,
        o_data => o_data,
        o_valid => o_valid
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
        wait for i_clk_period * 7.6;
        
        i_rx <= '0';
        wait for i_clk_period * 5;
        
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        i_rx <= '1';
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        wait for i_clk_period * 5;
        
        wait for i_clk_period * 5;
        wait for i_clk_period * 20;
        
        i_rx <= '0';
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
        
        wait for i_clk_period * 5;
        wait for i_clk_period * 20;
        
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
        

        wait;
    end process;

end;
