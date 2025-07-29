----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2025 17:12:46
-- Design Name: 
-- Module Name: shift_mem_pipe_reg - Behavioral
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

entity shift_mem_pipe_reg is
    port ( clk          : in  std_logic;
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : in std_logic_vector(7 downto 0);
           block_1      : in std_logic_vector(7 downto 0);
           block_2      : in std_logic_vector(7 downto 0);
           block_3      : in std_logic_vector(7 downto 0);
           block_0_out  : out std_logic_vector(7 downto 0);
           block_1_out  : out std_logic_vector(7 downto 0);
           block_2_out  : out std_logic_vector(7 downto 0);
           block_3_out  : out std_logic_vector(7 downto 0);
           record_out   : out  std_logic_vector(31 downto 0));
           
end shift_mem_pipe_reg;

architecture behavioural of shift_mem_pipe_reg is

begin
    process (clk)
        begin
           if (rising_edge(clk)) then
               block_0_out  <= block_0;
               block_1_out  <= block_1;
               block_2_out  <= block_2;
               block_3_out  <= block_3;
               record_out   <= record_in;
           end if;

        end process; 
end behavioural;

