library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
    generic ( WIDTH : integer := 32 );
    Port (
        data_0 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_1 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_2 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_3 : in  std_logic_vector(WIDTH - 1 downto 0);
        block_x : in  std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end mux_4to1;

architecture Behavioral of mux_4to1 is

begin
    data_out <=   data_0 when block_x = "00" else
                  data_1 when block_x = "01" else
                  data_2 when block_x = "10" else
                  data_3;
end Behavioral;
