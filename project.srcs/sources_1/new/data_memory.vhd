library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tally_table is
    generic (
        NUM_CANDIDATE: Integer := 2;
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: Integer := 2;
        NUM_TALLY: Integer := 8
    );
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
--           FOR read stage
           read_enable: in std_logic;
           candidate_r: in  std_logic_vector(NUM_CANDIDATE - 1 downto 0);
           district_r: in  std_logic_vector(NUM_DISTRICT - 1 downto 0);
           read_data: out std_logic_vector(NUM_TALLY - 1 downto 0);
           read_sum: out std_logic_vector(NUM_TALLY - 1 downto 0);
--           For write stage
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           write_sum: in std_logic_vector(NUM_TALLY - 1 downto 0);
           candidate_w: in  std_logic_vector(NUM_CANDIDATE - 1 downto 0);
           district_w: in  std_logic_vector(NUM_DISTRICT - 1 downto 0);
           data_out     : out std_logic_vector(NUM_TALLY - 1 downto 0);
           sum_out: out std_logic_vector(NUM_TALLY - 1 downto 0) );
end tally_table;

architecture behavioral of tally_table is
--default sum is 16bits
type mem_array is array(0 to NUM_CANDIDATE - 1, 0 to NUM_DISTRICT) of std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_data_mem : mem_array;
signal var_candidate_r    : integer;
signal var_district_r     : integer;

begin
    var_candidate_r <= conv_integer(candidate_r);
    var_district_r <= conv_integer(district_r);
    mem_process: process ( clk,
                           write_enable,
                           write_data,
                           write_sum,
                           candidate_w,
                           district_w ) is
  
    variable var_data_mem : mem_array;
    variable var_write_data: integer;
    variable var_write_sum: integer;
    variable var_candidate_w    : integer;
    variable var_district_w     : integer;
  
    begin
        var_candidate_w := conv_integer(candidate_w);
        var_district_w := conv_integer(district_w);
        var_write_data  := conv_integer(write_data);
        var_write_sum  := conv_integer(write_sum);
        
        if (reset = '1') then
            for i in 0 to NUM_CANDIDATE - 1 loop
                for j in 0 to NUM_DISTRICT - 1 loop
                    var_data_mem(i, j) := (others=>'0');
                end loop;
            end loop;
        elsif (rising_edge(clk) and write_enable = '1') then
            -- memory writes on the falling clock edge
            var_data_mem(var_candidate_w, var_district_w) := write_data;
            var_data_mem(var_candidate_w, 2**NUM_DISTRICT + 1) := write_sum;
        end if;
       
        -- continuous read of the memory location given by var_addr 
        data_out <= var_data_mem(var_candidate_w, var_district_w);
        sum_out <= var_data_mem(var_candidate_w, 2**(NUM_DISTRICT - 1) + 1);
 
        -- the following are probe signals (for simulation purpose) 
        sig_data_mem <= var_data_mem;

    end process;
    
    read_data <= sig_data_mem(var_candidate_r, var_district_r) when read_enable = '1' else (others=>'0');
    read_sum <= sig_data_mem(var_candidate_r, 2**(NUM_DISTRICT - 1) + 1) when read_enable = '1' else (others=>'0');
  
end behavioral;