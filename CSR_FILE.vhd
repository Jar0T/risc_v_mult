----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:10 02/15/2025 
-- Design Name: 
-- Module Name:    CSR_FILE - Behavioral 
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

entity CSR_FILE is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_opcode : in std_logic_vector(3 downto 0);
        i_csr_addr : in std_logic_vector(11 downto 0);
        i_csr_data : in std_logic_vector(31 downto 0);
        i_csr_imm : in std_logic_vector(31 downto 0);
        o_csr_data : out std_logic_vector(31 downto 0);
        i_is_imm : in std_logic;
        i_instret : in std_logic;
        i_ext_int : in std_logic;
        i_tim_int : in std_logic;
        o_int_en : out std_logic;
        o_ext_ie : out std_logic;
        o_tim_ie : out std_logic;
        i_int_cause : in std_logic_vector(31 downto 0);
        i_int_pc : in std_logic_vector(31 downto 0);
        i_int_tval : in std_logic_vector(31 downto 0);
        i_int : in std_logic;
        i_int_ret : in std_logic;
        o_tvec : out std_logic_vector(31 downto 0);
        o_epc : out std_logic_vector(31 downto 0)
    );
end CSR_FILE;

architecture Behavioral of CSR_FILE is

    constant c_addr_mvendorid : std_logic_vector(11 downto 0) := X"F11";
    constant c_addr_marchid : std_logic_vector(11 downto 0) := X"F12";
    constant c_addr_mimpid : std_logic_vector(11 downto 0) := X"F13";
    constant c_addr_mhartid : std_logic_vector(11 downto 0) := X"F14";
    constant c_addr_mconfigptr : std_logic_vector(11 downto 0) := X"F15";

    constant c_addr_mstatus : std_logic_vector(11 downto 0) := X"300";
    constant c_addr_misa : std_logic_vector(11 downto 0) := X"301";
    constant c_addr_mie : std_logic_vector(11 downto 0) := X"304";
    constant c_addr_mtvec : std_logic_vector(11 downto 0) := X"305";
    constant c_addr_mstatush : std_logic_vector(11 downto 0) := X"310";
    
    constant c_addr_mscratch : std_logic_vector(11 downto 0) := X"340";
    constant c_addr_mepc : std_logic_vector(11 downto 0) := X"341";
    constant c_addr_mcause : std_logic_vector(11 downto 0) := X"342";
    constant c_addr_mtval : std_logic_vector(11 downto 0) := X"343";
    constant c_addr_mip : std_logic_vector(11 downto 0) := X"344";
    
    constant c_addr_mcycle : std_logic_vector(11 downto 0) := X"B00";
    constant c_addr_instret : std_logic_vector(11 downto 0) := X"B02";
    constant c_addr_mcycleh : std_logic_vector(11 downto 0) := X"B80";
    constant c_addr_instreth : std_logic_vector(11 downto 0) := X"B82";

    signal s_csr_misa : std_logic_vector(31 downto 0) := X"40000100";
    signal s_csr_mstatus : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mtvec : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mie : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mip : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mepc : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mcause : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mtval : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mscratch : std_logic_vector(31 downto 0) := (others => '0');
    signal s_csr_mcycle : std_logic_vector(63 downto 0) := (others => '0');
    signal s_csr_minstret : std_logic_vector(63 downto 0) := (others => '0');
    
    signal s_csr_din : std_logic_vector(31 downto 0) := (others => '0');

begin
    s_csr_din <= i_csr_data when i_is_imm = '0' else i_csr_imm;
    s_csr_mip <= X"00000" & i_ext_int & "000" & i_tim_int & "000" & X"0";
    o_int_en <= s_csr_mstatus(3);
    o_ext_ie <= s_csr_mie(11);
    o_tim_ie <= s_csr_mie(7);
    o_tvec <= s_csr_mtvec;
    o_epc <= s_csr_mepc;

    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
        
        elsif rising_edge(i_clk) then
            s_csr_mcycle <= std_logic_vector(unsigned(s_csr_mcycle) + 1);
            
            if i_instret = '1' then
                s_csr_minstret <= std_logic_vector(unsigned(s_csr_minstret) + 1);
            end if;
            
            if i_int = '1' then
                s_csr_mstatus(12 downto 11) <= "11";    -- mpp = M-mode
                s_csr_mstatus(7) <= s_csr_mstatus(3);   -- mpie = mie
                s_csr_mstatus(3) <= '0';                -- mie = 0
                s_csr_mcause <= i_int_cause;
                s_csr_mepc <= i_int_pc;
                s_csr_mtval <= i_int_tval;
            
            elsif i_int_ret = '1' then
                s_csr_mstatus(12 downto 11) <= "11";    -- mpp = M-mode
                s_csr_mstatus(3) <= s_csr_mstatus(7);   -- mie = mpie
                s_csr_mstatus(7) <= '1';                -- mpie = 1
            
            elsif i_en = '1' then
                case i_opcode is
                    when "1100" => -- CSRRW, !x0
                        case i_csr_addr is
                            when c_addr_mvendorid =>
                                o_csr_data <= (others => '0');
                            when c_addr_marchid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mimpid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mhartid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mconfigptr =>
                                o_csr_data <= (others => '0');
                            when c_addr_mstatus =>
                                o_csr_data <= s_csr_mstatus;
                                s_csr_mstatus <= s_csr_din;
                            when c_addr_misa =>
                                o_csr_data <= s_csr_misa;
                                s_csr_misa <= s_csr_din;
                            when c_addr_mie =>
                                o_csr_data <= s_csr_mie;
                                s_csr_mie <= s_csr_din;
                            when c_addr_mtvec =>
                                o_csr_data <= s_csr_mtvec;
                                s_csr_mtvec <= s_csr_din;
                            when c_addr_mstatush =>
                                o_csr_data <= (others => '0');
                            when c_addr_mscratch =>
                                o_csr_data <= s_csr_mscratch;
                                s_csr_mscratch <= s_csr_din;
                            when c_addr_mepc =>
                                o_csr_data <= s_csr_mepc;
                                s_csr_mepc <= s_csr_din;
                            when c_addr_mcause =>
                                o_csr_data <= s_csr_mcause;
                                s_csr_mcause <= s_csr_din;
                            when c_addr_mtval =>
                                o_csr_data <= s_csr_mtval;
                                s_csr_mtval <= s_csr_din;
                            when c_addr_mip =>
                                o_csr_data <= s_csr_mip;
                            when c_addr_mcycle =>
                                o_csr_data <= s_csr_mcycle(31 downto 0);
                                s_csr_mcycle(31 downto 0) <= s_csr_din;
                            when c_addr_instret =>
                                o_csr_data <= s_csr_minstret(31 downto 0);
                                s_csr_minstret(31 downto 0) <= s_csr_din;
                            when c_addr_mcycleh =>
                                o_csr_data <= s_csr_mcycle(63 downto 32);
                                s_csr_mcycle(63 downto 32) <= s_csr_din;
                            when c_addr_instreth =>
                                o_csr_data <= s_csr_minstret(63 downto 32);
                                s_csr_minstret(63 downto 32) <= s_csr_din;
                            when others =>
                        end case;
                        
                    when "0100" => -- CSRRW, x0
                        case i_csr_addr is
                            when c_addr_mvendorid =>
                                o_csr_data <= (others => '0');
                            when c_addr_marchid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mimpid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mhartid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mconfigptr =>
                                o_csr_data <= (others => '0');
                            when c_addr_mstatus =>
                                o_csr_data <= s_csr_mstatus;
                                s_csr_mstatus <= s_csr_din;
                            when c_addr_misa =>
                                o_csr_data <= s_csr_misa;
                                s_csr_misa <= s_csr_din;
                            when c_addr_mie =>
                                o_csr_data <= s_csr_mie;
                                s_csr_mie <= s_csr_din;
                            when c_addr_mtvec =>
                                o_csr_data <= s_csr_mtvec;
                                s_csr_mtvec <= s_csr_din;
                            when c_addr_mstatush =>
                                o_csr_data <= (others => '0');
                            when c_addr_mscratch =>
                                o_csr_data <= s_csr_mscratch;
                                s_csr_mscratch <= s_csr_din;
                            when c_addr_mepc =>
                                o_csr_data <= s_csr_mepc;
                                s_csr_mepc <= s_csr_din;
                            when c_addr_mcause =>
                                o_csr_data <= s_csr_mcause;
                                s_csr_mcause <= s_csr_din;
                            when c_addr_mtval =>
                                o_csr_data <= s_csr_mtval;
                                s_csr_mtval <= s_csr_din;
                            when c_addr_mip =>
                                o_csr_data <= s_csr_mip;
                            when c_addr_mcycle =>
                                o_csr_data <= s_csr_mcycle(31 downto 0);
                                s_csr_mcycle(31 downto 0) <= s_csr_din;
                            when c_addr_instret =>
                                o_csr_data <= s_csr_minstret(31 downto 0);
                                s_csr_minstret(31 downto 0) <= s_csr_din;
                            when c_addr_mcycleh =>
                                o_csr_data <= s_csr_mcycle(63 downto 32);
                                s_csr_mcycle(63 downto 32) <= s_csr_din;
                            when c_addr_instreth =>
                                o_csr_data <= s_csr_minstret(63 downto 32);
                                s_csr_minstret(63 downto 32) <= s_csr_din;
                            when others =>
                        end case;
                        
                    when "1010" => -- CSRRS, !x0
                        case i_csr_addr is
                            when c_addr_mvendorid =>
                                o_csr_data <= (others => '0');
                            when c_addr_marchid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mimpid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mhartid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mconfigptr =>
                                o_csr_data <= (others => '0');
                            when c_addr_mstatus =>
                                o_csr_data <= s_csr_mstatus;
                                s_csr_mstatus <= s_csr_mstatus or s_csr_din;
                            when c_addr_misa =>
                                o_csr_data <= s_csr_misa;
                                s_csr_misa <= s_csr_misa or s_csr_din;
                            when c_addr_mie =>
                                o_csr_data <= s_csr_mie;
                                s_csr_mie <= s_csr_mie or s_csr_din;
                            when c_addr_mtvec =>
                                o_csr_data <= s_csr_mtvec;
                                s_csr_mtvec <= s_csr_mtvec or s_csr_din;
                            when c_addr_mstatush =>
                                o_csr_data <= (others => '0');
                            when c_addr_mscratch =>
                                o_csr_data <= s_csr_mscratch;
                                s_csr_mscratch <= s_csr_mscratch or s_csr_din;
                            when c_addr_mepc =>
                                o_csr_data <= s_csr_mepc;
                                s_csr_mepc <= s_csr_mepc or s_csr_din;
                            when c_addr_mcause =>
                                o_csr_data <= s_csr_mcause;
                                s_csr_mcause <= s_csr_mcause or s_csr_din;
                            when c_addr_mtval =>
                                o_csr_data <= s_csr_mtval;
                                s_csr_mtval <= s_csr_mtval or s_csr_din;
                            when c_addr_mip =>
                                o_csr_data <= s_csr_mip;
                            when c_addr_mcycle =>
                                o_csr_data <= s_csr_mcycle(31 downto 0);
                                s_csr_mcycle(31 downto 0) <= s_csr_mcycle(31 downto 0) or s_csr_din;
                            when c_addr_instret =>
                                o_csr_data <= s_csr_minstret(31 downto 0);
                                s_csr_minstret(31 downto 0) <= s_csr_minstret(31 downto 0) or s_csr_din;
                            when c_addr_mcycleh =>
                                o_csr_data <= s_csr_mcycle(63 downto 32);
                                s_csr_mcycle(63 downto 32) <= s_csr_mcycle(63 downto 32) or s_csr_din;
                            when c_addr_instreth =>
                                o_csr_data <= s_csr_minstret(63 downto 32);
                                s_csr_minstret(63 downto 32) <= s_csr_minstret(63 downto 32) or s_csr_din;
                            when others =>
                        end case;
                        
                    when "1001" => -- CSRRC, !x0
                        case i_csr_addr is
                            when c_addr_mvendorid =>
                                o_csr_data <= (others => '0');
                            when c_addr_marchid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mimpid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mhartid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mconfigptr =>
                                o_csr_data <= (others => '0');
                            when c_addr_mstatus =>
                                o_csr_data <= s_csr_mstatus;
                                s_csr_mstatus <= s_csr_mstatus and not s_csr_din;
                            when c_addr_misa =>
                                o_csr_data <= s_csr_misa;
                                s_csr_misa <= s_csr_misa and not s_csr_din;
                            when c_addr_mie =>
                                o_csr_data <= s_csr_mie;
                                s_csr_mie <= s_csr_mie and not s_csr_din;
                            when c_addr_mtvec =>
                                o_csr_data <= s_csr_mtvec;
                                s_csr_mtvec <= s_csr_mtvec and not s_csr_din;
                            when c_addr_mstatush =>
                                o_csr_data <= (others => '0');
                            when c_addr_mscratch =>
                                o_csr_data <= s_csr_mscratch;
                                s_csr_mscratch <= s_csr_mscratch and not s_csr_din;
                            when c_addr_mepc =>
                                o_csr_data <= s_csr_mepc;
                                s_csr_mepc <= s_csr_mepc and not s_csr_din;
                            when c_addr_mcause =>
                                o_csr_data <= s_csr_mcause;
                                s_csr_mcause <= s_csr_mcause and not s_csr_din;
                            when c_addr_mtval =>
                                o_csr_data <= s_csr_mtval;
                                s_csr_mtval <= s_csr_mtval and not s_csr_din;
                            when c_addr_mip =>
                                o_csr_data <= s_csr_mip;
                            when c_addr_mcycle =>
                                o_csr_data <= s_csr_mcycle(31 downto 0);
                                s_csr_mcycle(31 downto 0) <= s_csr_mcycle(31 downto 0) and not s_csr_din;
                            when c_addr_instret =>
                                o_csr_data <= s_csr_minstret(31 downto 0);
                                s_csr_minstret(31 downto 0) <= s_csr_minstret(31 downto 0) and not s_csr_din;
                            when c_addr_mcycleh =>
                                o_csr_data <= s_csr_mcycle(63 downto 32);
                                s_csr_mcycle(63 downto 32) <= s_csr_mcycle(63 downto 32) and not s_csr_din;
                            when c_addr_instreth =>
                                o_csr_data <= s_csr_minstret(63 downto 32);
                                s_csr_minstret(63 downto 32) <= s_csr_minstret(63 downto 32) and not s_csr_din;
                            when others =>
                        end case;
                        
                    when "1000" => -- CSRRS/C, x0
                        case i_csr_addr is
                            when c_addr_mvendorid =>
                                o_csr_data <= (others => '0');
                            when c_addr_marchid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mimpid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mhartid =>
                                o_csr_data <= (others => '0');
                            when c_addr_mconfigptr =>
                                o_csr_data <= (others => '0');
                            when c_addr_mstatus =>
                                o_csr_data <= s_csr_mstatus;
                            when c_addr_misa =>
                                o_csr_data <= s_csr_misa;
                            when c_addr_mie =>
                                o_csr_data <= s_csr_mie;
                            when c_addr_mtvec =>
                                o_csr_data <= s_csr_mtvec;
                            when c_addr_mstatush =>
                                o_csr_data <= (others => '0');
                            when c_addr_mscratch =>
                                o_csr_data <= s_csr_mscratch;
                            when c_addr_mepc =>
                                o_csr_data <= s_csr_mepc;
                            when c_addr_mcause =>
                                o_csr_data <= s_csr_mcause;
                            when c_addr_mtval =>
                                o_csr_data <= s_csr_mtval;
                            when c_addr_mip =>
                                o_csr_data <= s_csr_mip;
                            when c_addr_mcycle =>
                                o_csr_data <= s_csr_mcycle(31 downto 0);
                            when c_addr_instret =>
                                o_csr_data <= s_csr_minstret(31 downto 0);
                            when c_addr_mcycleh =>
                                o_csr_data <= s_csr_mcycle(63 downto 32);
                            when c_addr_instreth =>
                                o_csr_data <= s_csr_minstret(63 downto 32);
                            when others =>
                        end case;
                        
                    when others =>
                end case;
            end if;
        end if;
    end process;

end Behavioral;

