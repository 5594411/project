----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2025 07:37:49 PM
-- Design Name: 
-- Module Name: shifter - Behavioral
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

entity shifter is
    port (
        s_b        : in  std_logic_vector(7 downto 0);
        block_size_in, r_in : std_logic_vector(3 downto 0);
        shift_o    : out std_logic_vector(7 downto 0)
    );
end entity shifter;
architecture Behavioral of shifter is
    signal block_end, modulo, block_size, r : integer range 0 to 8;
begin
    --case: rotate by 4 block size 
    block_size <= to_integer(unsigned(block_size_in));
    r <= to_integer(unsigned(r_in));
    modulo <= r mod block_size;  --modulo = 4
    
    block_end <= 8 - block_size; --it is 1
    process(block_size, modulo, s_b) begin
        if (block_size = 1) then --bo change as there is only 1 bit
            shift_o <= s_b;
        else
            if (modulo = 1) then
                shift_o(7 downto block_end) <= s_b(6 downto block_end) & s_b(7);
            elsif (modulo = block_size - 1) then
                shift_o(7 downto block_end) <= s_b(block_end) & s_b(7 downto block_end + 1);
            else
                --7 downto 1 is 3 downto 1 & 7 downto 4
                shift_o(7 downto block_end) <= s_b(7 - modulo downto block_end) & s_b(7 downto 7 - modulo + 1);
            end if;
        end if;
    end process;
    --shift_o <= std_logic_vector(unsigned(s_b) rol modulo);
    --shift_o <= std_logic_vector(shift_left(unsigned(s_b), r)) when r < w
    --           else (others => '0');
end architecture Behavioral;
