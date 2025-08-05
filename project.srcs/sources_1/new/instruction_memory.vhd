----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.08.2025 00:38:45
-- Design Name: 
-- Module Name: instruction_memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_memory is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           addr_in : in STD_LOGIC_VECTOR (3 downto 0);
           insn_out : out STD_LOGIC_VECTOR (31 downto 0));
end instruction_memory;

architecture Behavioral of instruction_memory is
type mem_array is array(0 to 15) of std_logic_vector(31 downto 0);
    signal sig_insn_mem : mem_array := (
        0 => X"30001234",
        1 => X"30000001",
        2 => X"30000002",
        3 => X"30000003",
        4 => X"30000004",
        5 => X"30000005",
        6 => X"00000006",
        7 => X"00000007",   
        8 => X"00000008",   
        others => X"00000000"
    );
begin
 mem_process : process(clk, reset)
        variable var_addr : integer;
    begin
        if reset = '1' then
            insn_out <= (others => '0');
        elsif rising_edge(clk) then
            var_addr := to_integer(unsigned(addr_in));
            insn_out <= sig_insn_mem(var_addr);
        end if;
    end process;

end Behavioral;