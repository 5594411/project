library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity block_partitioner is

    port ( clk          : in  std_logic;
           tag_sz       : in  std_logic_vector(3 downto 0);
           record_sz    : in  std_logic_vector(5 downto 0);
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : out std_logic_vector(7 downto 0);
           block_1      : out std_logic_vector(7 downto 0);
           block_2      : out std_logic_vector(7 downto 0);
           block_3      : out std_logic_vector(7 downto 0));
           
end block_partitioner;

architecture behavioral of block_partitioner is

begin
   process(clk)
    variable tag_len : integer;  
    variable rec_len : integer; 
    variable pos     : integer;
    variable trf_len : integer; 
    variable blk_tmp : std_logic_vector(7 downto 0);
    begin
        --if (reset = '1') then
            --block_0 <= (others => '0');
           -- block_1 <= (others => '0');
           -- block_2 <= (others => '0');
           -- block_3 <= (others => '0');
        if (rising_edge(clk)) then
            -- Convert sizes to integers and clamp
            tag_len := to_integer(unsigned(tag_sz));
            rec_len := to_integer(unsigned(record_sz));

            pos := 0;
            for blk in 0 to 3 loop
                blk_tmp := (others => '0');
                if (pos < rec_len) then
                    trf_len := rec_len - pos;
                    if (trf_len > tag_len) then
                            trf_len := tag_len;
                        end if;
                    blk_tmp(trf_len-1 downto 0) := record_in(pos + trf_len - 1 downto pos);
                else
                    blk_tmp := (others => '0');
                end if;
                pos := pos + tag_len;
                if (blk=3) then
                    block_3 <= blk_tmp;
                end if;
                if (blk=2) then
                    block_2 <= blk_tmp;
                end if;
                if (blk=1) then
                    block_1 <= blk_tmp;
                end if;
                if (blk=0) then
                    block_0 <= blk_tmp;
                end if;
            end loop;
        end if;
     end process;
 end behavioral;
