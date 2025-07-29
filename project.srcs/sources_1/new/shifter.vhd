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
        block_a, block_b        : in std_logic_vector(7 downto 0);
        shift_select            : in std_logic_vector(1 downto 0);
        block_c, block_d        : in  std_logic_vector(7 downto 0); --s_b
        block_size_in, r_in     : in std_logic_vector(3 downto 0);
        shift_a, shift_b, shift_c, shift_d : out std_logic_vector(7 downto 0)
    );
end entity shifter;
architecture Behavioral of shifter is
    component mux_4to1 is
    generic ( WIDTH : integer := 32 );
    Port (
        data_0 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_1 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_2 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_3 : in  std_logic_vector(WIDTH - 1 downto 0);
        block_x : in  std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    signal block_end, modulo, block_size, r : integer range 0 to 8;
    signal s_b, shift_o                     : std_logic_vector(7 downto 0);
begin
    --pick the one to shift
    mux1 : mux_4to1
    generic map ( WIDTH => 8 )
    port map (
        data_0 => block_a,
        data_1 => block_b,
        data_2 => block_c,
        data_3 => block_d,
        block_x => shift_select,
        data_out => s_b
    );
    
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
    
    process(shift_select, s_b, block_a, block_b, block_c, block_d)
    begin
        case shift_select is
            when "00" =>
                shift_a <= s_b; shift_b <= block_b; shift_c <= block_c; shift_d <= block_d;
            when "01" =>
                shift_a <= block_a; shift_b <= s_b; shift_c <= block_c; shift_d <= block_d;
            when "10" =>
                shift_a <= block_a; shift_b <= block_b; shift_c <= s_b; shift_d <= block_d;
            when "11" =>
                shift_a <= block_a; shift_b <= block_b; shift_c <= block_c; shift_d <= s_b;
        end case;
    end process;
end architecture Behavioral;
