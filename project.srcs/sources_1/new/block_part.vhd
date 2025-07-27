----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2025 15:58:33
-- Design Name: 
-- Module Name: single_cycle_core - Behavioral
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
entity single_cycle_core is
    port ( clk    : in  std_logic);
end single_cycle_core;

architecture structural of single_cycle_core is

component block_partitioner is

    port ( clk          : in  std_logic;
           tag_sz       : in  std_logic_vector(3 downto 0);
           record_sz    : in  std_logic_vector(5 downto 0);
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : out std_logic_vector(7 downto 0);
           block_1      : out std_logic_vector(7 downto 0);
           block_2      : out std_logic_vector(7 downto 0);
           block_3      : out std_logic_vector(7 downto 0));
           
end component;
signal sig_tag_sz       : std_logic_vector(3 downto 0);
signal sig_record_sz    : std_logic_vector(5 downto 0);
signal sig_record_in    : std_logic_vector(31 downto 0);
signal sig_block_0      : std_logic_vector(7 downto 0);
signal sig_block_1      : std_logic_vector(7 downto 0);
signal sig_block_2      : std_logic_vector(7 downto 0);
signal sig_block_3      : std_logic_vector(7 downto 0);
begin
-- tag size < 8 
-- tag size >= record size/4
-- record size < 32
    sig_tag_sz <= "0111";
    sig_record_sz <= "010100";
    sig_record_in <= "00000000000001010101010101010101";
    bp1: block_partitioner
    port map( clk          => clk,              
              tag_sz       => sig_tag_sz,
              record_sz    => sig_record_sz,
              record_in    => sig_record_in,
              block_0      => sig_block_0,
              block_1      => sig_block_1,
              block_2      => sig_block_2,
              block_3      => sig_block_3);
end structural;
