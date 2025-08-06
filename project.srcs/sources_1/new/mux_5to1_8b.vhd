----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.08.2025 14:20:35
-- Design Name: 
-- Module Name: mux_5to1_8b - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;   
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_5to1_1b is
    port (
        sel    : in  std_logic_vector(2 downto 0);
        d0     : in  std_logic;
        d1     : in  std_logic;
        d2     : in  std_logic;
        d3     : in  std_logic;
        d4     : in  std_logic;
        y      : out std_logic
    );
end entity;

architecture behavioral of mux_5to1_1b is
begin
    process(sel, d0, d1, d2, d3, d4)
    begin
        case sel is
            when "000" => y <= d0;
            when "001" => y <= d1;
            when "010" => y <= d2;
            when "011" => y <= d3;
            when "100" => y <= d4;
            when others => y <= 'X';
        end case;
    end process;
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;   
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_5to1_8b is
    port (
        sel      : in  std_logic_vector(2 downto 0);
        data0    : in  std_logic_vector(7 downto 0);
        data1    : in  std_logic_vector(7 downto 0);
        data2    : in  std_logic_vector(7 downto 0);
        data3    : in  std_logic_vector(7 downto 0);
        data4    : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of mux_5to1_8b is

    component mux_5to1_1b is
        port (
            sel : in  std_logic_vector(2 downto 0);
            d0  : in  std_logic;
            d1  : in  std_logic;
            d2  : in  std_logic;
            d3  : in  std_logic;
            d4  : in  std_logic;
            y   : out std_logic
        );
    end component;

begin
    gen_bits : for i in 7 downto 0 generate
        bit_mux : mux_5to1_1b
            port map (
                sel => sel,
                d0  => data0(i),
                d1  => data1(i),
                d2  => data2(i),
                d3  => data3(i),
                d4  => data4(i),
                y   => data_out(i)
            );
    end generate gen_bits;
end structural;