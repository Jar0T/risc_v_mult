--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:42:33 03/09/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/VGA_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGA
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
 
ENTITY VGA_TB IS
END VGA_TB;
 
ARCHITECTURE behavior OF VGA_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGA
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN  std_logic;
         i_fifo_data : IN  std_logic_vector(7 downto 0);
         i_fifo_empty : IN  std_logic;
         o_fifo_en : OUT  std_logic;
         o_color : OUT  std_logic_vector(7 downto 0);
         o_hsync : OUT  std_logic;
         o_vsync : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_fifo_data : std_logic_vector(7 downto 0) := (others => '0');
   signal i_fifo_empty : std_logic := '0';

 	--Outputs
   signal o_fifo_en : std_logic;
   signal o_color : std_logic_vector(7 downto 0);
   signal o_hsync : std_logic;
   signal o_vsync : std_logic;

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
   
    type t_fifo is array (0 to 7) of std_logic_vector(7 downto 0);
    signal s_fifo : t_fifo := (
        X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80"
    );
    signal s_fifo_index : integer range 0 to 7 := 0;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
          i_clk => i_clk,
          i_reset => i_reset,
          i_fifo_data => i_fifo_data,
          i_fifo_empty => i_fifo_empty,
          o_fifo_en => o_fifo_en,
          o_color => o_color,
          o_hsync => o_hsync,
          o_vsync => o_vsync
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
      -- hold reset state for 100 ns.
      i_fifo_empty <= '1';
      wait for i_clk_period*50;
      i_fifo_empty <= '0';

      -- insert stimulus here 

      wait;
   end process;
   
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if o_fifo_en = '1' then
                i_fifo_data <= s_fifo(s_fifo_index);
                
                if s_fifo_index = 7 then
                    s_fifo_index <= 0;
                else
                    s_fifo_index <= s_fifo_index + 1;
                end if;
            end if;
        end if;
    end process;

END;
