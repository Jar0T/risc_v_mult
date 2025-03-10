--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constants is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

    -- Instruction types
    constant TYPE_R:    std_logic_vector(2 downto 0) := "000";
    constant TYPE_I:    std_logic_vector(2 downto 0) := "001";
    constant TYPE_S:    std_logic_vector(2 downto 0) := "010";
    constant TYPE_B:    std_logic_vector(2 downto 0) := "011";
    constant TYPE_U:    std_logic_vector(2 downto 0) := "100";
    constant TYPE_J:    std_logic_vector(2 downto 0) := "101";
    constant TYPE_O:    std_logic_vector(2 downto 0) := "110";

    -- Opcodes
    constant OPCODE_LOAD:    std_logic_vector(4 downto 0) := "00000";   -- 0
    constant OPCODE_MISCMEM: std_logic_vector(4 downto 0) := "00011";   -- 3
    constant OPCODE_OPIMM:   std_logic_vector(4 downto 0) := "00100";   -- 4
    constant OPCODE_AUIPC:   std_logic_vector(4 downto 0) := "00101";   -- 5
    constant OPCODE_STORE:   std_logic_vector(4 downto 0) := "01000";   -- 8
    constant OPCODE_OP:      std_logic_vector(4 downto 0) := "01100";   -- 12
    constant OPCODE_LUI:     std_logic_vector(4 downto 0) := "01101";   -- 13
    constant OPCODE_BRANCH:  std_logic_vector(4 downto 0) := "11000";   -- 24
    constant OPCODE_JALR:    std_logic_vector(4 downto 0) := "11001";   -- 25
    constant OPCODE_JAL:     std_logic_vector(4 downto 0) := "11011";   -- 27
    constant OPCODE_SYSTEM:  std_logic_vector(4 downto 0) := "11100";   -- 28
    
    -- Writeback source
    constant WB_MEM:         std_logic_vector(2 downto 0) := "000";
    constant WB_ALU:         std_logic_vector(2 downto 0) := "001";
    constant WB_PCIMM:       std_logic_vector(2 downto 0) := "010";
    constant WB_IMM:         std_logic_vector(2 downto 0) := "011";
    constant WB_PC4:         std_logic_vector(2 downto 0) := "100";
    constant WB_CSR:         std_logic_vector(2 downto 0) := "101";

end constants;

package body constants is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end constants;
