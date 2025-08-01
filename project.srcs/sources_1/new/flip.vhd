library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flip_blocks is
    Port (
        tag_size : in std_logic_vector(3 downto 0);
        bf       : in std_logic_vector(1 downto 0);  -- block to flip: 00, 01, 10, 11
        A0_in    : in std_logic_vector(7 downto 0);
        A1_in    : in std_logic_vector(7 downto 0);
        A2_in    : in std_logic_vector(7 downto 0);
        A3_in    : in std_logic_vector(7 downto 0);
        A0_out   : out std_logic_vector(7 downto 0);
        A1_out   : out std_logic_vector(7 downto 0);
        A2_out   : out std_logic_vector(7 downto 0);
        A3_out   : out std_logic_vector(7 downto 0)
    );
end flip_blocks;

architecture Behavioral of flip_blocks is

    function flip_bits(input : std_logic_vector(7 downto 0); relevant : integer) return std_logic_vector is
        variable output : std_logic_vector(7 downto 0);
    begin
        for i in 0 to 7 loop
            if i < relevant then
                output(i) := not input(i);
            else
                output(i) := input(i);
            end if;
        end loop;
        return output;
    end function;

begin
    process(tag_size, bf, A0_in, A1_in, A2_in, A3_in)
        variable int_tag_size : integer;
    begin
        A0_out <= A0_in;
        A1_out <= A1_in;
        A2_out <= A2_in;
        A3_out <= A3_in;
        int_tag_size := to_integer(unsigned(tag_size));

        case bf is
            when "00" =>
                A0_out <= flip_bits(A0_in, int_tag_size);
            when "01" =>
                A1_out <= flip_bits(A1_in, int_tag_size);
            when "10" =>
                A2_out <= flip_bits(A2_in, int_tag_size);
            when "11" =>
                A3_out <= flip_bits(A3_in, int_tag_size);
            when others =>
                null;  
        end case;
    end process;

end Behavioral;
