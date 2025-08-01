library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_6to4 is
    Port (
        data_0 : in  std_logic_vector(7 downto 0);
        data_1 : in  std_logic_vector(7 downto 0);
        data_2 : in  std_logic_vector(7 downto 0);
        data_3 : in  std_logic_vector(7 downto 0);
        data_x : in  std_logic_vector(7 downto 0);
        data_y : in  std_logic_vector(7 downto 0);
        block_x : in  std_logic_vector(1 downto 0);
        block_y : in  std_logic_vector(1 downto 0);
        data_0_out : out std_logic_vector(7 downto 0);
        data_1_out : out std_logic_vector(7 downto 0);
        data_2_out : out std_logic_vector(7 downto 0);
        data_3_out : out std_logic_vector(7 downto 0));
end mux_6to4;

architecture Behavioral of mux_6to4 is

begin
    data_0_out <= data_x when block_x = "00" else
                  data_y when block_y = "00" else
                  data_0;

    data_1_out <= data_x when block_x = "01" else
                  data_y when block_y = "01" else
                  data_1;
                  
    data_2_out <= data_x when block_x = "10" else
                  data_y when block_y = "10" else
                  data_2;

    data_3_out <= data_x when block_x = "11" else
                  data_y when block_y = "11" else
                  data_3;
end Behavioral;
