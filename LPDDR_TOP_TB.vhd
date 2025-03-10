--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:20:20 03/08/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/LPDDR_TOP_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LPDDR_TOP
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY LPDDR_TOP_TB IS
END LPDDR_TOP_TB;
 
ARCHITECTURE behavior OF LPDDR_TOP_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LPDDR_TOP
    PORT(
         i_ddr_clk : IN  std_logic;
         i_cpu_clk : IN  std_logic;
         i_reset : IN  std_logic;
         i_en : IN  std_logic;
         i_we : IN  std_logic_vector(3 downto 0);
         i_addr : IN  std_logic_vector(1 downto 0);
         i_data : IN  std_logic_vector(31 downto 0);
         o_data : OUT  std_logic_vector(31 downto 0);
         o_valid : OUT  std_logic;
         mcb3_dram_dq : INOUT  std_logic_vector(15 downto 0);
         mcb3_dram_a : OUT  std_logic_vector(12 downto 0);
         mcb3_dram_ba : OUT  std_logic_vector(1 downto 0);
         mcb3_dram_cke : OUT  std_logic;
         mcb3_dram_ras_n : OUT  std_logic;
         mcb3_dram_cas_n : OUT  std_logic;
         mcb3_dram_we_n : OUT  std_logic;
         mcb3_dram_dm : OUT  std_logic;
         mcb3_dram_udqs : INOUT  std_logic;
         mcb3_rzq : INOUT  std_logic;
         mcb3_dram_udm : OUT  std_logic;
         mcb3_dram_dqs : INOUT  std_logic;
         mcb3_dram_ck : OUT  std_logic;
         mcb3_dram_ck_n : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_ddr_clk : std_logic := '0';
   signal i_cpu_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_en : std_logic := '0';
   signal i_we : std_logic_vector(3 downto 0) := (others => '0');
   signal i_addr : std_logic_vector(1 downto 0) := (others => '0');
   signal i_data : std_logic_vector(31 downto 0) := (others => '0');

	--BiDirs
   signal mcb3_dram_dq : std_logic_vector(15 downto 0);
   signal mcb3_dram_udqs : std_logic;
   signal mcb3_rzq : std_logic;
   signal mcb3_dram_dqs : std_logic;

 	--Outputs
   signal o_data : std_logic_vector(31 downto 0);
   signal o_valid : std_logic;
   signal mcb3_dram_a : std_logic_vector(12 downto 0);
   signal mcb3_dram_ba : std_logic_vector(1 downto 0);
   signal mcb3_dram_cke : std_logic;
   signal mcb3_dram_ras_n : std_logic;
   signal mcb3_dram_cas_n : std_logic;
   signal mcb3_dram_we_n : std_logic;
   signal mcb3_dram_dm : std_logic;
   signal mcb3_dram_udm : std_logic;
   signal mcb3_dram_ck : std_logic;
   signal mcb3_dram_ck_n : std_logic;

   -- Clock period definitions
   constant i_ddr_clk_period : time := 10 ns;
   constant i_cpu_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LPDDR_TOP PORT MAP (
          i_ddr_clk => i_ddr_clk,
          i_cpu_clk => i_cpu_clk,
          i_reset => i_reset,
          i_en => i_en,
          i_we => i_we,
          i_addr => i_addr,
          i_data => i_data,
          o_data => o_data,
          o_valid => o_valid,
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

   -- Clock process definitions
   i_ddr_clk_process :process
   begin
		i_ddr_clk <= '0';
		wait for i_ddr_clk_period/2;
		i_ddr_clk <= '1';
		wait for i_ddr_clk_period/2;
   end process;
 
   i_cpu_clk_process :process
   begin
		i_cpu_clk <= '0';
		wait for i_cpu_clk_period/2;
		i_cpu_clk <= '1';
		wait for i_cpu_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_ddr_clk_period*10;

      -- insert stimulus here 
      i_en <= '1';
      i_addr <= "10";
      wait for i_cpu_clk_period * 2;
      i_en <= '0';

      wait;
   end process;

END;
