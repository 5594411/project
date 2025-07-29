library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity swap is
    port ( clk : in std_logic;
        enable : in std_logic;
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
    process(clk)
        variable temp_bx : std_logic_vector(BLOCK_WIDTH - 1 downto 0);
        variable temp_by : std_logic_vector(BLOCK_WIDTH - 1 downto 0);
        variable temp_bit : std_logic;

        variable id_x, id_y : integer;

    begin
        if rising_edge(clk) AND enable = '1' then
            temp_bx := block_x;
            temp_by := block_y;
    
            for i in 0 to to_integer(unsigned(s)) - 1 loop
                id_x := (to_integer(unsigned(px)) + i) mod BLOCK_WIDTH;
                id_y := (to_integer(unsigned(py)) + i) mod BLOCK_WIDTH;
                
                temp_bit := temp_bx(id_x);
                temp_bx(id_x) := temp_by(id_y);
                temp_by(id_y) := temp_bit;
            end loop;
    
            bx_swapped <= temp_bx;
            by_swapped <= temp_by;
        end if;
    end process;
end behavioral;