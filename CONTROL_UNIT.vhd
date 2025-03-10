----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:05:44 01/12/2025 
-- Design Name: 
-- Module Name:    CONTROL_UNIT - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL_UNIT is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_mem_en : in std_logic;
        i_mem_we : in std_logic;
        i_mem_valid : in std_logic;
        o_fetch : out std_logic := '0';
        o_decode : out std_logic := '0';
        o_reg_read : out std_logic := '0';
        o_execute : out std_logic := '0';
        o_store : out std_logic := '0';
        o_mem : out std_logic := '0';
        o_load : out std_logic := '0';
        o_write_back : out std_logic := '0'
    );
end CONTROL_UNIT;

architecture Behavioral of CONTROL_UNIT is
    type t_state is (RESET, FETCH, DECODE, REG_READ, EXECUTE, STORE, MEM_ACCESS, LOAD, WRITE_BACK);
    signal s_state: t_state := RESET;
    signal s_next_state : t_state := RESET;

begin
    process(i_clk, i_reset)
    begin
        if (i_reset = '1') then
            s_state <= RESET;
        elsif (rising_edge(i_clk)) then
            s_state <= s_next_state;
        end if;
    end process;
    
    process(s_state, i_mem_en, i_mem_we, i_mem_valid)
    begin
        case s_state is
            when RESET =>
                s_next_state <= FETCH;
            
            when FETCH =>
                s_next_state <= DECODE;
            
            when DECODE =>
                if (i_mem_valid = '0') then
                    s_next_state <= DECODE;
                else
                    s_next_state <= REG_READ;
                end if;
            
            when REG_READ =>
                s_next_state <= EXECUTE;
            
            when EXECUTE =>
                if (i_mem_en = '0') then
                    s_next_state <= WRITE_BACK;
                else
                    if (i_mem_we = '0') then
                        s_next_state <= MEM_ACCESS;
                    else
                        s_next_state <= STORE;
                    end if;
                end if;
            
            when STORE =>
                s_next_state <= MEM_ACCESS;
            
            when MEM_ACCESS =>
                if (i_mem_we = '0') then
                    s_next_state <= LOAD;
                else
                    s_next_state <= WRITE_BACK;
                end if;
            
            when LOAD =>
                if (i_mem_valid = '0') then
                    s_next_state <= LOAD;
                else
                    s_next_state <= WRITE_BACK;
                end if;
            
            when WRITE_BACK =>
                s_next_state <= FETCH;
            
            when others =>
                s_next_state <= RESET;
        end case;
    end process;
    
    process(s_state, i_mem_en, i_mem_we)
    begin
        o_fetch <= '0';
        o_decode <= '0';
        o_reg_read <= '0';
        o_execute <= '0';
        o_store <= '0';
        o_mem <= '0';
        o_load <= '0';
        o_write_back <= '0';
        
        case s_state is
            when FETCH => o_fetch <= '1';
            when DECODE => o_decode <= '1';
            when REG_READ => o_reg_read <= '1';
            when EXECUTE => o_execute <= '1';
            when STORE => o_store <= '1';
            when MEM_ACCESS => o_mem <= '1';
            when LOAD => o_load <= '1';
            when WRITE_BACK => o_write_back <= '1';
            when others =>
        end case;
    end process;

end Behavioral;

