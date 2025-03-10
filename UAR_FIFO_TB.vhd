--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:32:43 02/03/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/UAR_FIFO_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_FIFO
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
 
entity UAR_FIFO_TB is
end UAR_FIFO_TB;
 
architecture behavior of UAR_FIFO_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component UART_FIFO
    Port(
        clk : in  std_logic;
        rst : in  std_logic;
        din : in  std_logic_vector(7 downto 0);
        wr_en : in  std_logic;
        rd_en : in  std_logic;
        dout : out  std_logic_vector(7 downto 0);
        full : out  std_logic;
        empty : out  std_logic;
        valid : out std_logic;
        data_count : out  std_logic_vector(4 downto 0)
        );
    end component;
    

    --Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal din : std_logic_vector(7 downto 0) := (others => '0');
    signal wr_en : std_logic := '0';
    signal rd_en : std_logic := '0';

 	--Outputs
    signal dout : std_logic_vector(7 downto 0);
    signal full : std_logic;
    signal empty : std_logic;
    signal data_count : std_logic_vector(4 downto 0);
    signal valid : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
    uut: UART_FIFO Port map (
        clk => clk,
        rst => rst,
        din => din,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => dout,
        full => full,
        empty => empty,
        valid => valid,
        data_count => data_count
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here 
        wait for clk_period * 10.6;
        wr_en <= '1';
        din <= X"AA";
        wait for clk_period;
        din <= X"55";
        wait for clk_period;
        wr_en <= '0';
        wait for clk_period * 5;
        rd_en <= '1';
        wait for clk_period;
        rd_en <= '0';
        wait for clk_period;
        rd_en <= '1';
        wait for clk_period;
        rd_en <= '0';
        
        wait;
    end process;

end;
