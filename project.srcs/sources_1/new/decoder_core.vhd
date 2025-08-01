library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_core is
    generic (
        NUM_CANDIDATE: Integer := 2;
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: Integer := 2;
        NUM_TALLY: Integer := 8;
        TAG_SIZE: Integer := 4
    );
    port ( 
           btnR   : in  std_logic;
           clk    : in  std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0) );
end decoder_core;

architecture Behavioral of decoder_core is

signal sig_tag_sz          : std_logic_vector(3 downto 0);
signal sig_record_sz       : std_logic_vector(5 downto 0);

signal sig_record          : std_logic_vector(31 downto 0);
signal sig_block_bp_0      : std_logic_vector(7 downto 0);
signal sig_block_bp_1      : std_logic_vector(7 downto 0);
signal sig_block_bp_2      : std_logic_vector(7 downto 0);
signal sig_block_bp_3      : std_logic_vector(7 downto 0);

signal sig_block_bp_0_out  : std_logic_vector(7 downto 0);
signal sig_block_bp_1_out  : std_logic_vector(7 downto 0);
signal sig_block_bp_2_out  : std_logic_vector(7 downto 0);
signal sig_block_bp_3_out  : std_logic_vector(7 downto 0);
signal sig_record_bp       : std_logic_vector(31 downto 0);

signal sig_block_flip_0    : std_logic_vector(7 downto 0);
signal sig_block_flip_1    : std_logic_vector(7 downto 0);
signal sig_block_flip_2    : std_logic_vector(7 downto 0);
signal sig_block_flip_3    : std_logic_vector(7 downto 0);

signal sig_block_flip_0_out : std_logic_vector(7 downto 0);
signal sig_block_flip_1_out : std_logic_vector(7 downto 0);
signal sig_block_flip_2_out : std_logic_vector(7 downto 0);
signal sig_block_flip_3_out : std_logic_vector(7 downto 0);
signal sig_record_flip     : std_logic_vector(31 downto 0);

signal sig_block_swp_0    : std_logic_vector(7 downto 0);
signal sig_block_swp_1    : std_logic_vector(7 downto 0);
signal sig_block_swp_2    : std_logic_vector(7 downto 0);
signal sig_block_swp_3    : std_logic_vector(7 downto 0);

signal sig_block_swp_0_out : std_logic_vector(7 downto 0);
signal sig_block_swp_1_out : std_logic_vector(7 downto 0);
signal sig_block_swp_2_out : std_logic_vector(7 downto 0);
signal sig_block_swp_3_out : std_logic_vector(7 downto 0);
signal sig_record_swp     : std_logic_vector(31 downto 0);

signal sig_block_shift_0    : std_logic_vector(7 downto 0);
signal sig_block_shift_1    : std_logic_vector(7 downto 0);
signal sig_block_shift_2    : std_logic_vector(7 downto 0);
signal sig_block_shift_3    : std_logic_vector(7 downto 0);

signal sig_block_shift_0_out : std_logic_vector(7 downto 0);
signal sig_block_shift_1_out : std_logic_vector(7 downto 0);
signal sig_block_shift_2_out : std_logic_vector(7 downto 0);
signal sig_block_shift_3_out : std_logic_vector(7 downto 0);
signal sig_record_shift     : std_logic_vector(31 downto 0);

signal sig_block_x : std_logic_vector(7 downto 0);
signal sig_block_y : std_logic_vector(7 downto 0);
signal sig_swaped_block_x : std_logic_vector(7 downto 0);
signal sig_swaped_block_y : std_logic_vector(7 downto 0);

--for read and write stage
signal reset: std_logic;
signal sig_num_candidate: integer := NUM_CANDIDATE;
signal sig_num_district: integer := NUM_DISTRICT;
signal sig_num_tally: integer := NUM_TALLY;

signal sig_mem_write: std_logic;
signal sig_mem_read: std_logic;
signal sig_rec_tag: std_logic_vector(3 downto 0);
signal sig_cal_tag: std_logic_vector(3 downto 0);

signal sig_write_data_carry_out: std_logic;
signal sig_write_sum_carry_out: std_logic;
signal ex_write_data   : std_logic_vector(NUM_TALLY - 1 downto 0);
signal ex_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);

signal mux_select_candidate: std_logic;
signal mux_select_district: std_logic;
signal ex_read_data    : std_logic_vector(NUM_TALLY - 1 downto 0);
signal ex_read_sum     : std_logic_vector(NUM_TALLY - 1 downto 0);

signal sig_candidate_r  : std_logic_vector(NUM_CANDIDATE downto 0);
signal sig_candidate_w  : std_logic_vector(NUM_DISTRICT downto 0);
signal sig_district_r   : std_logic_vector(NUM_CANDIDATE downto 0);
signal sig_district_w   : std_logic_vector(NUM_DISTRICT downto 0);
signal sig_read_data    : std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_read_sum     : std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_write_data   : std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);

signal mem_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
signal mem_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);

signal secret_key: std_logic_vector(15 downto 0);
signal final_record: std_logic_vector(7 downto 0);
begin
    -- tag size <= 8 
    -- tag size >= record size/4
    -- record size < 32
    sig_tag_sz <= "0100";
    sig_record_sz <= "010000";
    sig_record(15 downto 0) <= sw;
    sig_record(31 downto 16) <= "0000000000000000";
    secret_key <= "1110100001011001";
    
    bp1: entity work.block_partitioner
    port map( clk          => clk,              
              tag_sz       => sig_tag_sz,
              record_sz    => sig_record_sz,
              record_in    => sig_record,
              block_0      => sig_block_bp_0,
              block_1      => sig_block_bp_1,
              block_2      => sig_block_bp_2,
              block_3      => sig_block_bp_3);

    bp_flip: entity work.block_pipe_reg
    port map( clk          => clk,
              record_in    => sig_record_bp,
              block_0      => sig_block_bp_0,
              block_1      => sig_block_bp_1,
              block_2      => sig_block_bp_2,
              block_3      => sig_block_bp_3,
              block_0_out  => sig_block_bp_0_out,
              block_1_out  => sig_block_bp_1_out,
              block_2_out  => sig_block_bp_2_out,
              block_3_out  => sig_block_bp_3_out,
              record_out   => sig_record_flip); 
              
   flip1: entity work.flip_blocks
   port map ( tag_size => sig_tag_sz,
              bf => secret_key(1 downto 0),
              A0_in => sig_block_bp_0_out,
              A1_in => sig_block_bp_1_out,
              A2_in => sig_block_bp_2_out,
              A3_in => sig_block_bp_3_out,
              A0_out => sig_block_flip_0,
              A1_out => sig_block_flip_1,
              A2_out => sig_block_flip_2,
              A3_out => sig_block_flip_3);
   
    flip_swp: entity work.block_pipe_reg
    port map( clk => clk,
              record_in => sig_record_flip,
              block_0 => sig_block_flip_0,
              block_1 => sig_block_flip_1,
              block_2 => sig_block_flip_2,
              block_3 => sig_block_flip_3,
              block_0_out => sig_block_flip_0_out,
              block_1_out => sig_block_flip_1_out,
              block_2_out => sig_block_flip_2_out,
              block_3_out => sig_block_flip_3_out,
              record_out => sig_record_swp); 
    
    mux1 : entity work.mux_4to2
    generic map ( WIDTH => 8 )
    port map ( data_0 => sig_block_flip_0_out,
               data_1 => sig_block_flip_1_out,
               data_2 => sig_block_flip_2_out,
               data_3 => sig_block_flip_3_out,
               block_x => secret_key(3 downto 2),
               block_y => secret_key(5 downto 4),
               data_out_x => sig_block_x,
               data_out_y => sig_block_y);

    swap1 : entity work.swap
    port map( block_x => sig_block_x,
              block_y => sig_block_y,
              px => secret_key(7 downto 6),
              py => secret_key(9 downto 8),
              s => secret_key(11 downto 10),
              tag_size => sig_tag_sz,
              bx_swapped => sig_swaped_block_x,
              by_swapped => sig_swaped_block_y);
              
    mux2 : entity work.mux_6to4
    port map ( data_0 => sig_block_flip_0_out,
               data_1 => sig_block_flip_1_out,
               data_2 => sig_block_flip_2_out,
               data_3 => sig_block_flip_3_out,
               data_x => sig_swaped_block_x,
               data_y => sig_swaped_block_y,
               block_x => secret_key(3 downto 2),
               block_y => secret_key(5 downto 4),
               data_0_out => sig_block_swp_0,
               data_1_out => sig_block_swp_1,
               data_2_out => sig_block_swp_2,
               data_3_out => sig_block_swp_3);
   
    swp_shift: entity work.block_pipe_reg
    port map( clk          => clk,
              record_in    => sig_record_swp,
              block_0      => sig_block_swp_0,
              block_1      => sig_block_swp_1,
              block_2      => sig_block_swp_2,
              block_3      => sig_block_swp_3,
              block_0_out  => sig_block_swp_0_out,
              block_1_out  => sig_block_swp_1_out,
              block_2_out  => sig_block_swp_2_out,
              block_3_out  => sig_block_swp_3_out,
              record_out   => sig_record_shift);

    shift1: entity work.shifter
    port map( block_0 => sig_block_swp_0_out,
              block_1 => sig_block_swp_1_out,
              block_2 => sig_block_swp_2_out,
              block_3 => sig_block_swp_3_out,
              shift_select => secret_key(15 downto 14),
              block_size_in => sig_tag_sz,
              r_in => secret_key(13 downto 12),
              shift_0 => sig_block_shift_0,
              shift_1 => sig_block_shift_1,
              shift_2 => sig_block_shift_2,
              shift_3 => sig_block_shift_3);
            
    shift_mem: entity work.block_pipe_reg
    port map( clk          => clk,
              record_in    => sig_record_shift,
              block_0      => sig_block_shift_0,
              block_1      => sig_block_shift_1,
              block_2      => sig_block_shift_2,
              block_3      => sig_block_shift_3,
              block_0_out  => sig_block_shift_0_out,
              block_1_out  => sig_block_shift_1_out,
              block_2_out  => sig_block_shift_2_out,
              block_3_out  => sig_block_shift_3_out,
              record_out   => sig_record_shift);
    
    xor1: entity work.xor_mod
    port map ( block_0 => sig_block_shift_0_out,
               block_1 => sig_block_shift_1_out,
               block_2 => sig_block_shift_2_out,
               block_3 => sig_block_shift_3_out,
               xor_out => final_record);

end Behavioral;
