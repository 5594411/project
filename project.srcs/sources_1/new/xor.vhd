library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xor_mod is
    Port ( block_0, block_1,
           block_2, block_3 : in STD_LOGIC_VECTOR (7 downto 0);
           xor_out          : out STD_LOGIC_VECTOR(7 downto 0));
end xor_mod;
    
architecture Behavioral of xor_mod is

begin
    xor_out <= block_0 xor block_1 xor block_2 xor block_3;
end Behavioral;
