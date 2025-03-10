--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:20:25 02/01/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/CONTROL_UNIT_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL_UNIT
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
 
entity CONTROL_UNIT_TB is
end CONTROL_UNIT_TB;
 
architecture behavior of CONTROL_UNIT_TB is 

    -- Component Declaration for the Unit Under Test (UUT)
 
    component CONTROL_UNIT
    Port(
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_mem_en : in  std_logic;
        i_mem_we : in  std_logic;
        i_mem_valid : in  std_logic;
        o_fetch : out  std_logic;
        o_decode : out  std_logic;
        o_reg_read : out  std_logic;
        o_execute : out  std_logic;
        o_store : out  std_logic;
        o_mem : out  std_logic;
        o_load : out  std_logic;
        o_write_back : out  std_logic
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_mem_en : std_logic := '0';
    signal i_mem_we : std_logic := '0';
    signal i_mem_valid : std_logic := '0';

 	--Outputs
    signal o_fetch : std_logic;
    signal o_decode : std_logic;
    signal o_reg_read : std_logic;
    signal o_execute : std_logic;
    signal o_store : std_logic;
    signal o_mem : std_logic;
    signal o_load : std_logic;
    signal o_write_back : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
    uut: CONTROL_UNIT Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_mem_en => i_mem_en,
        i_mem_we => i_mem_we,
        i_mem_valid => i_mem_valid,
        o_fetch => o_fetch,
        o_decode => o_decode,
        o_reg_read => o_reg_read,
        o_execute => o_execute,
        o_store => o_store,
        o_mem => o_mem,
        o_load => o_load,
        o_write_back => o_write_back
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
        i_mem_valid <= '1';
        wait until o_write_back = '0';
        
        wait until o_decode = '0';
        i_mem_en <= '1';
        
        wait until o_decode = '0';
        i_mem_we <= '1';
        
        wait until o_fetch = '0';
        i_mem_valid <= '0';
        wait for i_clk_period * 2;
        i_mem_valid <= '1';
        wait until o_decode = '0';
        i_mem_en <= '0';
        i_mem_we <= '0';

        wait;
    end process;

end;
