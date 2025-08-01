library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shifter is
    port (
        block_0, block_1, block_2, block_3 : in std_logic_vector(7 downto 0);
        shift_select, r_in : in std_logic_vector(1 downto 0);
        block_size_in : in std_logic_vector(3 downto 0);
        shift_0, shift_1, shift_2, shift_3 : out std_logic_vector(7 downto 0)
    );
end entity shifter;
architecture Behavioral of shifter is
    component mux_4to1 is
    generic ( WIDTH : integer := 32 );
    Port (
        data_0 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_1 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_2 : in  std_logic_vector(WIDTH - 1 downto 0);
        data_3 : in  std_logic_vector(WIDTH - 1 downto 0);
        block_x : in  std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    signal block_start, modulo, block_size, r : integer range 0 to 8;
    signal s_b, shift_o                     : std_logic_vector(7 downto 0);
begin
    --pick the one to shift
    mux1 : mux_4to1
    generic map ( WIDTH => 8 )
    port map (
        data_0 => block_0,
        data_1 => block_1,
        data_2 => block_2,
        data_3 => block_3,
        block_x => shift_select,
        data_out => s_b
    );
    
    --case: rotate by 4 block size 
    block_size <= to_integer(unsigned(block_size_in));
    r <= to_integer(unsigned(r_in));
    with block_size select
    modulo <= r mod 15 when 0,
              r mod block_size when others;
    
    block_start <= block_size - 1; --it is 1
    process (block_size, modulo, s_b)
    begin
        if (block_size = 1) then --bo change as there is only 1 bit
            shift_o <= s_b;
        else
            if (modulo = 1) then
                shift_o(block_start downto 0) <= (s_b(block_start - 1 downto 0) & s_b(block_start));
                shift_o(7 downto block_size) <= ( others => '0');
            elsif (modulo = block_size - 1) then
                shift_o(block_start downto 0) <= s_b(0) & s_b(block_start downto 1);
                shift_o(7 downto block_size) <= ( others => '0');
            else
                --7 downto 1 is 3 downto 1 & 7 downto 4
                shift_o(block_start downto 0) <= s_b(block_start - modulo downto 0) & s_b(block_start downto block_start - modulo + 1);
                shift_o(7 downto block_size) <= ( others => '0');
            end if;
        end if;
    end process;
    
    process(shift_select, shift_o, block_0, block_1, block_2, block_3)
    begin
        case shift_select is
            when "00" =>
                shift_0 <= shift_o ; shift_1 <= block_1; shift_2 <= block_2; shift_3 <= block_3;
            when "01" =>
                shift_0 <= block_0; shift_1 <= shift_o; shift_2 <= block_2; shift_3 <= block_3;
            when "10" =>
                shift_0 <= block_0; shift_1 <= block_1; shift_2 <= shift_o; shift_3 <= block_3;
            when "11" =>
                shift_0 <= block_0; shift_1 <= block_1; shift_2 <= block_2; shift_3 <= shift_o;
            when others =>
                shift_0 <= block_0; shift_1 <= block_1; shift_2 <= block_2; shift_3 <= shift_o;
        end case;
    end process;
end architecture Behavioral;
