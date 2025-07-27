library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipe_reg is
  generic (
    WIDTH : integer := 32
  );
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    stall    : in  std_logic;                          -- '1' to hold, '0' to update
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    dout     : out std_logic_vector(WIDTH-1 downto 0)
  );
end entity;

architecture Behavioral of pipe_reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            dout <= (others=>'0');
        elsif rising_edge(clk) AND stall = '0' then
            dout <= din;
        end if;
    end process;
end architecture;


