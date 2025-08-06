library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity swap is
    generic ( MAX_TAG_SIZE : integer := 8 );
    port ( block_x : in  std_logic_vector(7 downto 0);
           block_y : in  std_logic_vector(7 downto 0);
           px : in  std_logic_vector(1 downto 0);
           py : in  std_logic_vector(1 downto 0);
           s : in  std_logic_vector(1 downto 0);
           tag_size : in std_logic_vector(3 downto 0);
           bx_swapped : out std_logic_vector(7 downto 0);
           by_swapped : out std_logic_vector(7 downto 0));
end swap;

architecture behavioral of swap is
begin
    process(block_x, block_y, px, py, s, tag_size)
        variable temp_bx : std_logic_vector(7 downto 0);
        variable temp_by : std_logic_vector(7 downto 0);
        variable temp_bit : std_logic;
        variable int_tag_size, divisor : integer range 0 to 8;
        variable id_x, id_y : integer;
        variable s_range : integer;
    begin
        temp_bx := block_x;
        temp_by := block_y;
        int_tag_size := to_integer(unsigned(tag_size));
        s_range := to_integer(unsigned(s));
        
        if (int_tag_size = 0) then
            divisor := MAX_TAG_SIZE;
        else
            divisor := int_tag_size;
        end if;

        for i in 0 to MAX_TAG_SIZE loop
            exit when i = s_range;
            id_x := (to_integer(unsigned(px)) + i) mod divisor;
            id_y := (to_integer(unsigned(py)) + i) mod divisor;
            
            temp_bit := temp_bx(id_x);
            temp_bx(id_x) := temp_by(id_y);
            temp_by(id_y) := temp_bit;
        end loop;

        bx_swapped <= temp_bx;
        by_swapped <= temp_by;
    end process;
end behavioral;