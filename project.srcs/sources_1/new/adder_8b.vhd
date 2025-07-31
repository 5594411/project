----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/07/30 23:07:55
-- Design Name: 
-- Module Name: adder_8b - Behavioral
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

entity adder_8b is
    generic (
        NUM_TALLY: Integer := 8
    );
    port ( src_a     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           src_b     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           sum       : out std_logic_vector(NUM_TALLY - 1 downto 0);
           carry_out : out std_logic );
end adder_8b;

architecture behavioural of adder_8b is

signal sig_result : std_logic_vector(NUM_TALLY downto 0);

begin

    sig_result <= ('0' & src_a) + ('0' & src_b);
    sum        <= sig_result(NUM_TALLY - 1 downto 0);
    carry_out  <= sig_result(NUM_TALLY);
    
end behavioural;
