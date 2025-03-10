--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:27:05 02/02/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/HART_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HART
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
 
entity HART_TB is
end HART_TB;
 
architecture behavior of HART_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component HART
    Port(
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        o_mem_en : out  std_logic;
        o_mem_we : out  std_logic_vector(3 downto 0);
        o_mem_addr : out  std_logic_vector(31 downto 0);
        o_mem_data : out  std_logic_vector(31 downto 0);
        i_mem_data : in  std_logic_vector(31 downto 0);
        i_mem_valid : in  std_logic
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
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_mem_data : std_logic_vector(31 downto 0) := (others => '0');
    signal i_mem_valid : std_logic := '0';

 	--Outputs
    signal o_mem_en : std_logic;
    signal o_mem_we : std_logic_vector(3 downto 0);
    signal o_mem_addr : std_logic_vector(31 downto 0);
    signal o_mem_data : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: HART Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        o_mem_en => o_mem_en,
        o_mem_we => o_mem_we,
        o_mem_addr => o_mem_addr,
        o_mem_data => o_mem_data,
        i_mem_data => i_mem_data,
        i_mem_valid => i_mem_valid
        );
    
    Inst_RAM: RAM Port map(
        i_clk => i_clk,
        i_en_a => o_mem_en,
        i_addr_a => o_mem_addr(13 downto 2),
        i_we_a => o_mem_we,
        i_data_a => o_mem_data,
        o_data_a => i_mem_data,
        i_clk_b => i_clk,
        i_en_b => '0',
        i_addr_b => X"000",
        i_we_b => "0000",
        i_data_b => X"00000000",
        o_data_b => open
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

        wait;
    end process;

end;
