----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/29/2025 10:31:03 AM
-- Design Name: 
-- Module Name: xor - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xor_mod is
    Port ( block_a, block_b,
           block_c, block_d : in STD_LOGIC_VECTOR (7 downto 0);
           xor_out          : out STD_LOGIC_VECTOR(7 downto 0));
end xor_mod;
    
architecture Behavioral of xor_mod is

begin
    xor_out <= block_a xor block_b xor block_c xor block_d;
end Behavioral;
