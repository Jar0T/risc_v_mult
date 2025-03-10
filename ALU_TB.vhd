--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:08:06 01/11/2025
-- Design Name:   
-- Module Name:   /home/jarek/RV32I/ALU_TB.vhd
-- Project Name:  RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Funct3 : IN  std_logic_vector(2 downto 0);
         Funct7 : IN  std_logic_vector(6 downto 0);
         Is_Imm : IN  std_logic;
         Y : OUT  std_logic_vector(31 downto 0);
         B_cmp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Funct3 : std_logic_vector(2 downto 0) := (others => '0');
   signal Funct7 : std_logic_vector(6 downto 0) := (others => '0');
   signal Is_Imm : std_logic := '0';

 	--Outputs
   signal Y : std_logic_vector(31 downto 0);
   signal B_cmp : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Funct3 => Funct3,
          Funct7 => Funct7,
          Is_Imm => Is_Imm,
          Y => Y,
          B_cmp => B_cmp
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here
      A <= X"F0F0F0F0";
      B <= X"00000005";
      Funct3 <= "001";
      wait for clk_period;
      
      B <= X"00000010";
      wait for clk_period;

      wait;
   end process;

END;
