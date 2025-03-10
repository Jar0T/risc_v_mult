--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:40:21 02/18/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/INTERRUPT_CONTROLLER_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: INTERRUPT_CONTROLLER
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
 
entity INTERRUPT_CONTROLLER_TB is
end INTERRUPT_CONTROLLER_TB;
 
architecture behavior of INTERRUPT_CONTROLLER_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component INTERRUPT_CONTROLLER
    Port(
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_en : in  std_logic;
        i_exc : in  std_logic;
        i_exc_cause : in  std_logic_vector(31 downto 0);
        i_exc_tval : in  std_logic_vector(31 downto 0);
        i_ext_int : in  std_logic;
        i_ext_tval : in  std_logic_vector(31 downto 0);
        i_tim_int : in  std_logic;
        i_tim_tval : in  std_logic_vector(31 downto 0);
        i_gie : in  std_logic;
        i_ext_ie : in  std_logic;
        i_tim_ie : in  std_logic;
        i_tvec : in  std_logic_vector(31 downto 0);
        i_pc : in  std_logic_vector(31 downto 0);
        i_next_pc : in  std_logic_vector(31 downto 0);
        o_int : out  std_logic;
        o_addr : out  std_logic_vector(31 downto 0);
        o_cause : out  std_logic_vector(31 downto 0);
        o_tval : out  std_logic_vector(31 downto 0);
        o_ext_ack : out  std_logic;
        o_tim_ack : out  std_logic;
        o_pc : out  std_logic_vector(31 downto 0)
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_exc : std_logic := '0';
    signal i_exc_cause : std_logic_vector(31 downto 0) := (others => '0');
    signal i_exc_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal i_ext_int : std_logic := '0';
    signal i_ext_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal i_tim_int : std_logic := '0';
    signal i_tim_tval : std_logic_vector(31 downto 0) := (others => '0');
    signal i_gie : std_logic := '0';
    signal i_ext_ie : std_logic := '0';
    signal i_tim_ie : std_logic := '0';
    signal i_tvec : std_logic_vector(31 downto 0) := (others => '0');
    signal i_pc : std_logic_vector(31 downto 0) := (others => '0');
    signal i_next_pc : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal o_int : std_logic;
    signal o_addr : std_logic_vector(31 downto 0);
    signal o_cause : std_logic_vector(31 downto 0);
    signal o_tval : std_logic_vector(31 downto 0);
    signal o_ext_ack : std_logic;
    signal o_tim_ack : std_logic;
    signal o_pc : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut: INTERRUPT_CONTROLLER PORT MAP (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_en,
        i_exc => i_exc,
        i_exc_cause => i_exc_cause,
        i_exc_tval => i_exc_tval,
        i_ext_int => i_ext_int,
        i_ext_tval => i_ext_tval,
        i_tim_int => i_tim_int,
        i_tim_tval => i_tim_tval,
        i_gie => i_gie,
        i_ext_ie => i_ext_ie,
        i_tim_ie => i_tim_ie,
        i_tvec => i_tvec,
        i_pc => i_pc,
        i_next_pc => i_next_pc,
        o_int => o_int,
        o_addr => o_addr,
        o_cause => o_cause,
        o_tval => o_tval,
        o_ext_ack => o_ext_ack,
        o_tim_ack => o_tim_ack,
        o_pc => o_pc
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
        wait for i_clk_period * 10;
        i_pc <= X"00000004";
        i_next_pc <= X"00000008";
        i_tvec <= X"10000000";
        i_exc <= '1';
        i_exc_cause <= X"00000008";
        i_exc_tval <= X"11111111";
        wait for i_clk_period;
        i_exc <= '0';
        wait for i_clk_period * 5;
        i_exc <= '1';
        i_tvec <= X"10000001";
        wait for i_clk_period;
        i_exc <= '0';
        wait for i_clk_period * 5;
        
        i_en <= '1';
        i_ext_ie <= '1';
        i_ext_int <= '1';
        i_ext_tval <= X"00000005";
        wait for i_clk_period;
        i_gie <= '1';
        wait for i_clk_period;
        i_ext_int <= '0';
        wait for i_clk_period * 5;
        
        i_tim_int <= '1';
        i_tim_tval <= X"00000007";
        wait for i_clk_period;
        i_tim_ie <= '1';
        wait for i_clk_period;
        i_tim_int <= '0';
        wait for i_clk_period * 5;

        wait;
    end process;

end;
