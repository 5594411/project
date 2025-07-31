----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/07/30 23:39:14
-- Design Name: 
-- Module Name: mux_2to1_1b - Behavioral
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

entity mux_2to1_1b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic;
           data_b     : in  std_logic;
           data_out   : out std_logic );
end mux_2to1_1b;

architecture behavioural of mux_2to1_1b is
begin

    data_out <= data_a when mux_select = '0' else
                data_b when mux_select = '1' else
                'X';

end behavioural;
