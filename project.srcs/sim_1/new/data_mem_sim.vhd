library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity data_mem_sim is
    generic (
        NUM_CANDIDATE: integer := 2; -- Bits for canidates
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: integer := 2;
        NUM_TALLY: integer := 8; -- Bits for size of the tally
        TAG_SIZE: integer := 4;
        RECORD_SIZE : integer := 12
    );
--  Port ( );
end data_mem_sim;

architecture Behavioral of data_mem_sim is
    signal reset: std_logic;
    signal sig_tag_size: integer := TAG_SIZE;
    signal sig_num_candidate: integer := NUM_CANDIDATE;
    signal sig_num_district: integer := NUM_DISTRICT;
    signal sig_num_tally: integer := NUM_TALLY;
    
    signal sig_mem_read_for_memory: std_logic;
    signal sig_mem_write: std_logic;
    
    signal sig_write_data_carry_out: std_logic;
    signal sig_write_sum_carry_out: std_logic;
    signal ex_write_data   : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal ex_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);
    
    signal mux_select_candidate: std_logic;
    signal mux_select_district: std_logic;
    signal ex_read_data    : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal ex_read_sum     : std_logic_vector(NUM_TALLY - 1 downto 0);
    
    signal sig_candidate_r  : std_logic_vector(NUM_CANDIDATE - 1 downto 0);
    signal sig_candidate_w  : std_logic_vector(NUM_CANDIDATE - 1 downto 0);
    signal sig_district_r   : std_logic_vector(NUM_DISTRICT - 1 downto 0);
    signal sig_district_w   : std_logic_vector(NUM_DISTRICT - 1 downto 0);
    signal sig_read_data    : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal sig_read_sum     : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal sig_write_data_for_memory    : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal sig_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);
    signal sig_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
    signal sig_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);
    
    signal mem_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
    signal mem_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);
    
    signal clk, tag_match : std_logic;
    signal sig_record : std_logic_vector(31 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
 -- compare tag_out_idtd with sig_tag
    mux_select_candidate <= '1' when (sig_candidate_r = sig_candidate_w) else '0';
    mux_select_district <= '1' when (sig_candidate_r = sig_candidate_w and sig_district_r = sig_district_w) else '0';
    
    sig_mem_read_for_memory <= tag_match;
    sig_candidate_r <= sig_record(NUM_CANDIDATE + NUM_TALLY - 1 downto NUM_TALLY);
    sig_district_r <= sig_record(NUM_DISTRICT + NUM_CANDIDATE + NUM_TALLY - 1 downto NUM_CANDIDATE + NUM_TALLY);
    
    mux_2to1_candidate: entity work.mux_2to1_8b
    port map ( mux_select => mux_select_candidate,
               data_a => sig_read_sum,
               data_b => mem_sum_out,
               data_out => ex_read_sum );
    
    mux_2to1_district: entity work.mux_2to1_8b
    port map ( mux_select => mux_select_district,
               data_a => sig_read_data,
               data_b => mem_data_out,
               data_out => ex_read_data);
    
    alu_write_data : entity work.adder_8b 
    port map ( src_a     => ex_read_data,
               src_b     => sig_record(NUM_TALLY - 1 downto 0),
               sum       => ex_write_data,
               carry_out => sig_write_data_carry_out );
    
    alu_write_sum : entity work.adder_8b 
    port map ( src_a     => ex_read_sum,
               src_b     => sig_record(NUM_TALLY - 1 downto 0),
               sum       => ex_write_sum,
               carry_out => sig_write_sum_carry_out );
               
    process(clk, reset)
    begin
        if (reset = '1') then
            sig_write_data_for_memory  <= (others=>'0');
            sig_write_sum <= (others=>'0');
            sig_candidate_w <= (others=>'0');
            sig_district_w <= (others=>'0');
            sig_mem_write <= '0';
        elsif (rising_edge(clk)) then
            sig_write_data_for_memory  <= ex_write_data;
            sig_write_sum <= ex_write_sum;
            sig_candidate_w <= sig_candidate_r;
            sig_district_w <= sig_district_r;
            sig_mem_write <= sig_mem_read_for_memory;
        end if;
    end process;
--    sig_write_data_for_memory  <= ex_write_data when reset = '0' else (others=>'0');
--    sig_write_sum <= ex_write_sum when reset = '0' else (others=>'0');
--    sig_candidate_w <= sig_candidate_r when reset = '0' else (others=>'0');
--    sig_district_w <= sig_district_r when reset = '0' else (others=>'0');
--    sig_mem_write <= sig_mem_read_for_memory when reset = '0' else '0';
    
    data_memory: entity work.tally_table
        generic map (
            NUM_CANDIDATE => NUM_CANDIDATE,
            NUM_DISTRICT => NUM_DISTRICT,
            NUM_TALLY => NUM_TALLY
        )
        port map ( 
            reset        => reset,
            clk          => clk,
            read_enable  => sig_mem_read_for_memory,
            candidate_r  => sig_candidate_r,
            district_r   => sig_district_r,
            read_data    => sig_read_data,
            read_sum     => sig_read_sum,
            write_enable => sig_mem_write,
            write_data   => sig_write_data_for_memory,
            write_sum    => sig_write_sum,
            candidate_w  => sig_candidate_w,
            district_w   => sig_district_w,
            data_out     => sig_data_out,
            sum_out      => sig_sum_out
        );
        
    mem_data_out <= (others=>'0') when (reset = '1' OR is_x(sig_data_out)) else sig_data_out;
    mem_sum_out <= (others=>'0') when (reset = '1' OR is_x(sig_sum_out)) else sig_sum_out;
    
    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        sig_record <= "001110011000";
        tag_match <= '1';
        wait for 50 ns;
        sig_record <= "000100011011";
        tag_match <= '1';
        wait for 50 ns;
        sig_record <= "010101101100";
        tag_match <= '1';
        wait for 50 ns;
        sig_record <= "010101101111";
        tag_match <= '1';
        wait for 50 ns;
        sig_record <= "101110101000";
        tag_match <= '1';
        wait for 50 ns;
        sig_record <= "111100101000";
        tag_match <= '1';
        wait;
    end process stimulus;
end Behavioral;
