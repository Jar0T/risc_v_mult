--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:46:31 02/01/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/LOAD_DECODER_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LOAD_DECODER
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
 
entity LOAD_DECODER_TB is
end LOAD_DECODER_TB;
 
architecture behavior of LOAD_DECODER_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component LOAD_DECODER
    Port(
        i_clk : in  std_logic;
        i_en : in  std_logic;
        i_data : in  std_logic_vector(31 downto 0);
        i_addr : in  std_logic_vector(1 downto 0);
        i_funct3 : in  std_logic_vector(2 downto 0);
        o_data : out  std_logic_vector(31 downto 0)
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_data : std_logic_vector(31 downto 0) := (others => '0');
    signal i_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal i_funct3 : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
    signal o_data : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: LOAD_DECODER Port map (
        i_clk => i_clk,
        i_en => i_en,
        i_data => i_data,
        i_addr => i_addr,
        i_funct3 => i_funct3,
        o_data => o_data
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
        i_en <= '1';
        i_data <= X"ffeeddcc";
        
        i_funct3 <= "000";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;
        
        i_funct3 <= "001";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;
        
        i_funct3 <= "010";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;
        
        i_funct3 <= "100";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;
        
        i_funct3 <= "101";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;
        
        i_en <= '0';
        i_funct3 <= "000";
        i_addr <= "00";
        wait for i_clk_period;
        i_addr <= "01";
        wait for i_clk_period;
        i_addr <= "10";
        wait for i_clk_period;
        i_addr <= "11";
        wait for i_clk_period;

        wait;
    end process;

end;
