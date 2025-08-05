----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2025 16:32:53
-- Design Name: 
-- Module Name: bp_flip_pipe_reg - Behavioral
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

entity if_id_pipe_reg is
    port ( clk          : in  std_logic;
           insn_in      : in  std_logic_vector(31 downto 0);
           insn_out     : out  std_logic_vector(31 downto 0));
           
end if_id_pipe_reg;

architecture behavioural of if_id_pipe_reg is

begin
    process (clk)
        begin
           if (rising_edge(clk)) then
               insn_out   <= insn_in;
           end if;

        end process; 
end behavioural;