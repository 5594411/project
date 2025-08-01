library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipe_reg is
  generic (
    WIDTH : integer
  );
  port (
    clk      : in  std_logic;
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    dout     : out std_logic_vector(WIDTH-1 downto 0)
  );
end entity;

architecture Behavioral of pipe_reg is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            dout <= din;
        end if;
    end process;
end architecture;


