library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity swap is
    port (
        block_x         : in  std_logic_vector(7 downto 0);
        block_y         : in  std_logic_vector(7 downto 0);
        px         : in  std_logic_vector(3 downto 0);
        py         : in  std_logic_vector(3 downto 0);
        s          : in  std_logic_vector(3 downto 0);
        bx_swapped : out std_logic_vector(7 downto 0);
        by_swapped : out std_logic_vector(7 downto 0));
end swap;

architecture behavioral of swap is
    constant BLOCK_WIDTH : integer := 8;
begin
    swap_proc: process(block_x, block_y, px, py, s)
        variable temp_bx, id_x : std_logic_vector(BLOCK_WIDTH - 1 downto 0);
        variable temp_by, id_y : std_logic_vector(BLOCK_WIDTH - 1 downto 0);
        variable temp_bit : std_logic;

        variable idx_x, idx_y : integer;

    begin
        temp_bx := block_x;
        temp_by := block_y;

        for i in 0 to to_integer(unsigned(s)) - 1 loop
            idx_x := (to_integer(unsigned(px)) + i) mod BLOCK_WIDTH;
            idx_y := (to_integer(unsigned(py)) + i) mod BLOCK_WIDTH;
            temp_bit := temp_bx(idx_x);
            temp_bx(idx_x) := temp_by(idx_y);
            temp_by(idx_y) := temp_bit;
        end loop;

        bx_swapped <= temp_bx;
        by_swapped <= temp_by;

    end process swap_proc;
end behavioral;