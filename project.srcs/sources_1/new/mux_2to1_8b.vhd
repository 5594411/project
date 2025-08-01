----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/07/30 23:44:23
-- Design Name: 
-- Module Name: mux_2to1_8b - Behavioral
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

entity mux_2to1_8b is
    generic (
        NUM_TALLY: Integer := 8
    );
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           data_b     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           data_out   : out std_logic_vector(NUM_TALLY - 1 downto 0) );
end mux_2to1_8b;

architecture structural of mux_2to1_8b is

component mux_2to1_1b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic;
           data_b     : in  std_logic;
           data_out   : out std_logic );
end component;

begin

    -- this for-generate-loop replicates 16 single-bit 2-to-1 mux
    muxes : for i in NUM_TALLY - 1 downto 0 generate
        bit_mux : mux_2to1_1b 
        port map ( mux_select => mux_select,
                   data_a     => data_a(i),
                   data_b     => data_b(i),
                   data_out   => data_out(i) );
    end generate muxes;
    
end structural;
