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
    generic (
        w : integer := 8
    );
    port (
        r       : in  integer range 0 to w;
        s_b     : in  std_logic_vector(w-1 downto 0);
        shift_o : out std_logic_vector(w-1 downto 0)
    );
end entity shifter;

architecture Behavioral of shifter is
    signal modulo : integer range 0 to w;
begin
    modulo <= r mod w;
    process(modulo) begin
        if (modulo = 1) then
            shift_o <= s_b(w - 2 downto 0) & s_b(w - 1);
        elsif (modulo = 0) then
            shift_o <= s_b;
        elsif (modulo = w - 1) then
            shift_o <= s_b(0) & s_b(w - 1 downto 1);
        else
            shift_o <= s_b(w - 1 - modulo downto 0) & s_b(w - 1 downto w - modulo);
        end if;
    end process;
    --shift_o <= std_logic_vector(unsigned(s_b) rol modulo);
    --shift_o <= std_logic_vector(shift_left(unsigned(s_b), r)) when r < w
    --           else (others => '0');
end architecture Behavioral;
