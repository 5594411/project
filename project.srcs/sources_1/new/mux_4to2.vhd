library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to2 is
    generic ( WIDTH : integer := 32 );
    Port (
        data_0 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_1 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_2 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_3 : in  std_logic_vector(WIDTH - 1 downto 0);
        block_x : in  std_logic_vector(1 downto 0);
        block_y : in  std_logic_vector(1 downto 0);
        data_out_x : out std_logic_vector(WIDTH - 1 downto 0);
        data_out_y : out std_logic_vector(WIDTH - 1 downto 0)
    );
end mux_4to2;

architecture Behavioral of mux_4to2 is

begin
    data_out_1 <= data_0 when block_x = "00" else
                  data_1 when block_x = "01" else
                  data_2 when block_x = "10" else
                  data_3 when block_x = "11" else
                  'X';

    data_out_2 <= data_0 when block_y = "00" else
                  data_1 when block_y = "01" else
                  data_2 when block_y = "10" else
                  data_3 when block_y = "11" else
                  'X';
end Behavioral;
