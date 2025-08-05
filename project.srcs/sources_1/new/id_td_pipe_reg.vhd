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

entity id_td_pipe_reg is
    port ( clk                  : in  std_logic;
           sk_in                : in  std_logic_vector(15 downto 0);
           sk_out               : out  std_logic_vector(15 downto 0);
           mem_read_in          : in  std_logic;
           mem_read_out         : out std_logic;
           register_write_in    : in  std_logic;
           register_write_out   : out std_logic;
           record_in            : in std_logic_vector(31 downto 0);
           record_out           : out std_logic_vector(31 downto 0);
           tag_in               : in std_logic_vector(7 downto 0);
           tag_out               : out std_logic_vector(7 downto 0)); 
end id_td_pipe_reg;

architecture behavioural of id_td_pipe_reg is

begin
    process (clk)
        begin
           if (rising_edge(clk)) then
               sk_out               <= sk_in;
               mem_read_out         <= mem_read_in;
               register_write_out   <= register_write_in;
               tag_out<=tag_in;
               record_out <= record_in;
               
           end if;

        end process; 
end behavioural;    