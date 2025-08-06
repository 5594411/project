library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binarytobcd is
    generic (
        BIN_WIDTH  : natural := 8;   -- e.g. 8-bit tally
        DIGITS     : natural := 3    -- how many decimal digits?
    );
    port (
        bin_in   : in  std_logic_vector(BIN_WIDTH-1 downto 0);
        bcd_out  : out std_logic_vector(DIGITS*4-1 downto 0)
        -- { digit(DIGITS-1), …, digit(1), digit(0) }
    );
end entity;

architecture behavioural of binarytobcd is
    -- total shift register width: BIN_WIDTH + 4*DIGITS
       subtype shift_t is unsigned(BIN_WIDTH + 4*DIGITS - 1 downto 0);
begin
    process(bin_in)
        variable sr : shift_t := (others => '0');
        constant N  : integer := BIN_WIDTH;
        constant M  : integer := DIGITS;
    begin
        -- load binary into the LSB end of sr
        sr := unsigned(bin_in) & (M*4-1 downto 0 => '0');

        -- double-dabble: N shifts
        for i in 1 to N loop
        -- for each BCD digit chunk, if ≥5 add 3
        for d in 0 to M-1 loop
            if sr(N + 4*d + 3 downto N + 4*d) > 4 then
                sr(N + 4*d + 3 downto N + 4*d) := 
                sr(N + 4*d + 3 downto N + 4*d) + 3;
            end if;
        end loop;
        -- shift left
        sr := sr(BIN_WIDTH+4*M-2 downto 0) & '0';
        end loop;

        -- extract the BCD digits
        for d in 0 to M-1 loop
            bcd_out((d+1)*4-1 downto d*4) <= std_logic_vector(
            sr(N + 4*d + 3 downto N + 4*d)
        );
        end loop;
    end process;
end behavioural;