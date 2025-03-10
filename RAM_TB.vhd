--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:29:39 01/13/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/RAM_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RAM
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
 
entity RAM_TB is
end RAM_TB;
 
architecture behavior of RAM_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component RAM
    port(
        i_clk : in std_logic;
        i_en_a : in std_logic;
        i_addr_a : in std_logic_vector (11 downto 0);
        i_we_a : in std_logic_vector (3 downto 0);
        i_data_a : in std_logic_vector (31 downto 0);
        o_data_a : out std_logic_vector (31 downto 0);
        i_clk_b : in std_logic;
        i_en_b : in std_logic;
        i_addr_b : in std_logic_vector (11 downto 0);
        i_we_b : in std_logic_vector (3 downto 0);
        i_data_b : in std_logic_vector (31 downto 0);
        o_data_b : out std_logic_vector (31 downto 0)
        );
    end component;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_en_a : std_logic := '0';
   signal i_we_a : std_logic_vector(3 downto 0) := (others => '0');
   signal i_addr_a : std_logic_vector(11 downto 0) := (others => '0');
   signal i_data_a : std_logic_vector(31 downto 0) := (others => '0');
   signal i_clk_b : std_logic := '0';
   signal i_en_b : std_logic := '0';
   signal i_we_b : std_logic_vector(3 downto 0) := (others => '0');
   signal i_addr_b : std_logic_vector(11 downto 0) := (others => '0');
   signal i_data_b : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal o_data_a : std_logic_vector(31 downto 0);
   signal o_data_b : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          i_clk => i_clk,
          i_en_a => i_en_a,
          i_addr_a => i_addr_a,
          i_we_a => i_we_a,
          i_data_a => i_data_a,
          o_data_a => o_data_a,
          i_clk_b => i_clk_b,
          i_en_b => i_en_b,
          i_addr_b => i_addr_b,
          i_we_b => i_we_b,
          i_data_b => i_data_b,
          o_data_b => o_data_b
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
        i_clk_b <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
        i_clk_b <= '1';
		wait for i_clk_period/2;
   end process;
 

    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        -- test disabled
        i_addr_a <= (others => '0');
        wait for i_clk_period * 5;
        
        -- test read
        i_en_a <= '1';
        for i in 0 to 7 loop
            i_addr_a <= std_logic_vector(to_unsigned(i, i_addr_a'length));
            wait for i_clk_period;
        end loop;
        i_en_a <= '0';
        wait for i_clk_period;
        
        -- test write
        -- test word write
        i_en_a <= '1';
        i_we_a <= "1111";
        for i in 0 to 63 loop
            i_addr_a <= std_logic_vector(to_unsigned(i, i_addr_a'length));
            i_data_a <= std_logic_vector(to_unsigned(i, 8)) & std_logic_vector(to_unsigned(i, 8)) & std_logic_vector(to_unsigned(i, 8)) & std_logic_vector(to_unsigned(i, 8));
            wait for i_clk_period;
        end loop;
        i_we_a <= "0000";
        i_en_a <= '0';
        wait for i_clk_period;
        
        -- test half word write
        i_en_a <= '1';
        for i in 0 to 63 loop
            i_addr_a <= std_logic_vector(to_unsigned(i + 64, i_addr_a'length));
            i_we_a <= "0011";
            i_data_a <= std_logic_vector(to_unsigned(i * 2, 8)) & std_logic_vector(to_unsigned(i * 2, 8)) & std_logic_vector(to_unsigned(i * 2, 8)) & std_logic_vector(to_unsigned(i * 2, 8));
            wait for i_clk_period;
            i_we_a <= "1100";
            i_data_a <= std_logic_vector(to_unsigned((i * 2) + 1, 8)) & std_logic_vector(to_unsigned((i * 2) + 1, 8)) & std_logic_vector(to_unsigned((i * 2) + 1, 8)) & std_logic_vector(to_unsigned((i * 2) + 1, 8));
            wait for i_clk_period;
        end loop;
        i_we_a <= "0000";
        i_en_a <= '0';
        wait for i_clk_period;
        
        -- test byte write
        i_en_a <= '1';
        for i in 0 to 63 loop
            i_addr_a <= std_logic_vector(to_unsigned(i + 128, i_addr_a'length));
            i_we_a <= "0001";
            i_data_a <= std_logic_vector(to_unsigned(i * 4, 8)) & std_logic_vector(to_unsigned(i * 4, 8)) & std_logic_vector(to_unsigned(i * 4, 8)) & std_logic_vector(to_unsigned(i * 4, 8));
            wait for i_clk_period;
            i_we_a <= "0010";
            i_data_a <= std_logic_vector(to_unsigned((i * 4) + 1, 8)) & std_logic_vector(to_unsigned((i * 4) + 1, 8)) & std_logic_vector(to_unsigned((i * 4) + 1, 8)) & std_logic_vector(to_unsigned((i * 4) + 1, 8));
            wait for i_clk_period;
            i_we_a <= "0100";
            i_data_a <= std_logic_vector(to_unsigned((i * 4) + 2, 8)) & std_logic_vector(to_unsigned((i * 4) + 2, 8)) & std_logic_vector(to_unsigned((i * 4) + 2, 8)) & std_logic_vector(to_unsigned((i * 4) + 2, 8));
            wait for i_clk_period;
            i_we_a <= "1000";
            i_data_a <= std_logic_vector(to_unsigned((i * 4) + 3, 8)) & std_logic_vector(to_unsigned((i * 4) + 3, 8)) & std_logic_vector(to_unsigned((i * 4) + 3, 8)) & std_logic_vector(to_unsigned((i * 4) + 3, 8));
            wait for i_clk_period;
        end loop;
        i_we_a <= "0000";
        i_en_a <= '0';
        wait for i_clk_period;
        
        i_en_a <= '1';
        for i in 0 to 7 loop
            i_addr_a <= std_logic_vector(to_unsigned(i, 3)) & "000000000";
            wait for i_clk_period;
        end loop;
        i_en_a <= '0';
        wait for i_clk_period;

        wait;
    end process;

end;
