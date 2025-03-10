--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:44:43 01/09/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/REGISTER_FILE_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: REGISTER_FILE
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
USE ieee.numeric_std.ALL;

ENTITY REGISTER_FILE_TB IS
END REGISTER_FILE_TB;

ARCHITECTURE behavior OF REGISTER_FILE_TB IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT REGISTER_FILE
    PORT(
        clk : IN std_logic;
        we : IN std_logic;
        sel_a : IN integer range 0 to 31;
        sel_b : IN integer range 0 to 31;
        sel_d : IN integer range 0 to 31;
        da_out : OUT std_logic_vector(31 downto 0);
        db_out : OUT std_logic_vector(31 downto 0);
        d_in : IN std_logic_vector(31 downto 0)
    );
    END COMPONENT;


    --Inputs
    signal clk : std_logic := '0';
    signal we : std_logic := '0';
    signal sel_a : integer range 0 to 31 := 0;
    signal sel_b : integer range 0 to 31 := 0;
    signal sel_d : integer range 0 to 31 := 0;
    signal d_in : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal da_out : std_logic_vector(31 downto 0);
    signal db_out : std_logic_vector(31 downto 0);
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
    uut: REGISTER_FILE PORT MAP (
        clk => clk,
        we => we,
        sel_a => sel_a,
        sel_b => sel_b,
        sel_d => sel_d,
        da_out => da_out,
        db_out => db_out,
        d_in => d_in
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
        sel_a <= 0;
        sel_b <= 0;
        sel_d <= 0;
        d_in <= X"12345678";
        we <= '1';
        
        wait for clk_period;
        
        sel_d <= 1;
        d_in <= X"aaaaaaaa";
        we <= '1';
        
        wait for clk_period;
        
        sel_d <= 2;
        d_in <= X"55555555";
        we <= '1';
        
        wait for clk_period;
        
        sel_a <= 1;
        sel_b <= 2;
        we <= '0';
      
        for i in 0 to 31 loop
            sel_d <= i;
            d_in <= std_logic_vector(to_unsigned(i, d_in'length));
            we <= '1';
            wait for clk_period;
        end loop;

        wait;
    end process;

END;
