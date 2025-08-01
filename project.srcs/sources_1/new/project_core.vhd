library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project is
    generic (
        NUM_CANDIDATE: Integer := 2;
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: Integer := 2;
        NUM_TALLY: Integer := 8;
        TAG_SIZE: Integer := 8
    );
    port ( 
           btnR   : in  std_logic;
           clk    : in  std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0) );
end project;

architecture structural of project is

component control_unit is
    generic (
        TAG_SIZE: integer := 8
    );
    port ( cal_tag     : in  std_logic_vector(TAG_SIZE - 1 downto 0);
           rec_tag     : in  std_logic_vector(TAG_SIZE - 1 downto 0);
           mem_read  : out std_logic);
end component;

component adder_8b is
    generic (
        NUM_TALLY: Integer := 8
    );
    port ( src_a     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           src_b     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           sum       : out std_logic_vector(NUM_TALLY - 1 downto 0);
           carry_out : out std_logic );
end component;

component mux_2to1_8b is
    generic (
        NUM_TALLY: Integer := 8
    );
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           data_b     : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           data_out   : out std_logic_vector(NUM_TALLY - 1 downto 0) );
end component;

component tally_table is
    generic (
        NUM_CANDIDATE: Integer := 2;
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: Integer := 2;
        NUM_TALLY: Integer := 8
    );
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           
           read_enable: in std_logic;
           candidate_r: in  std_logic_vector(NUM_CANDIDATE - 1 downto 0);
           district_r: in  std_logic_vector(NUM_DISTRICT - 1 downto 0);
           read_data: out std_logic_vector(NUM_TALLY - 1 downto 0);
           read_sum: out std_logic_vector(NUM_TALLY - 1 downto 0);
           
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(NUM_TALLY - 1 downto 0);
           write_sum: in std_logic_vector(NUM_TALLY - 1 downto 0);
           candidate_w: in  std_logic_vector(NUM_CANDIDATE - 1 downto 0);
           district_w: in  std_logic_vector(NUM_DISTRICT - 1 downto 0);
           data_out     : out std_logic_vector(NUM_TALLY - 1 downto 0);
           sum_out: out std_logic_vector(NUM_TALLY - 1 downto 0) );
end component;

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

signal sig_block_0, sig_block_1 : std_logic_vector(7 downto 0);
signal sig_block_2, sig_block_3 : std_logic_vector(7 downto 0);
signal sig_swaped_block_1, sig_swaped_block_2 : std_logic_vector(7 downto 0);

--for read and write stage
signal reset: std_logic;
signal sig_tag_size: integer := TAG_SIZE;
signal sig_num_candidate: integer := NUM_CANDIDATE;
signal sig_num_district: integer := NUM_DISTRICT;
signal sig_num_tally: integer := NUM_TALLY;

signal sig_mem_write: std_logic;
signal sig_mem_read: std_logic;

signal sig_write_data_carry_out: std_logic;
signal sig_write_sum_carry_out: std_logic;
signal ex_write_data   : std_logic_vector(NUM_TALLY - 1 downto 0);
signal ex_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);

signal mux_select_candidate: std_logic;
signal mux_select_district: std_logic;
signal ex_read_data    : std_logic_vector(NUM_TALLY - 1 downto 0);
signal ex_read_sum     : std_logic_vector(NUM_TALLY - 1 downto 0);

signal sig_candidate_r  : std_logic_vector(NUM_CANDIDATE - 1 downto 0);
signal sig_candidate_w  : std_logic_vector(NUM_DISTRICT - 1 downto 0);
signal sig_district_r   : std_logic_vector(NUM_CANDIDATE - 1 downto 0);
signal sig_district_w   : std_logic_vector(NUM_DISTRICT - 1 downto 0);
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
--    sig_tag_sz <= "0111";
--    sig_record_sz <= "010100";
--    sig_record <= "00000000000001010101010101010101";
--    sig_tag_sz <= "0100";
--    sig_record_sz <= "010000";
--    sig_record(15 downto 0) <= sw;
--    sig_record(31 downto 16) <= "0000000000000000";
--    secret_key <= "1110100001011001";
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
    
    reset <= btnR;
--    sig_tag_size <= conv_integer(sig_tag_sz); 
    sig_candidate_r <= sig_record(sig_tag_size + sig_num_tally + sig_num_candidate - 1 downto sig_tag_size + sig_num_tally);
    sig_district_r <= sig_record(sig_tag_size + sig_num_tally + sig_num_candidate + sig_num_district - 1 downto sig_tag_size + sig_num_tally + sig_num_candidate);    
    
    ctl_unit: control_unit
        generic map (
            TAG_SIZE => sig_tag_size
        )
        port map (
            cal_tag => final_record,
--            rec_tag => "00001001",
            rec_tag => sig_record(sig_tag_size - 1 downto 0),
            mem_read => sig_mem_read
        );
        
    mux_select_candidate <= '1' when (sig_candidate_r = sig_candidate_w) else '0';
    mux_select_district <= '1' when (sig_candidate_r = sig_candidate_w and sig_district_r = sig_district_w ) else '0';
    
    mux_2to1_candidate: mux_2to1_8b
    generic map (
            NUM_TALLY => sig_num_tally
        )
    port map (
        mux_select => mux_select_candidate,
        data_a => sig_read_sum,
        data_b => mem_sum_out,
        data_out => ex_read_sum
    );
    
    mux_2to1_district: mux_2to1_8b
    generic map (
            NUM_TALLY => sig_num_tally
        )
    port map (
        mux_select => mux_select_district,
        data_a => sig_read_data,
        data_b => mem_data_out,
        data_out => ex_read_data
    );
    
    alu_write_data : adder_8b 
    generic map (
            NUM_TALLY => sig_num_tally
        )
    port map ( src_a     => ex_read_data,
               src_b     => sig_record(sig_tag_size + sig_num_tally - 1 downto sig_tag_size),
               sum       => ex_write_data,
               carry_out => sig_write_data_carry_out );
    
    alu_write_sum : adder_8b 
    generic map (
            NUM_TALLY => sig_num_tally
        )
    port map ( src_a     => ex_read_sum,
               src_b     => sig_record(sig_tag_size + sig_num_tally - 1 downto sig_tag_size),
               sum       => ex_write_sum,
               carry_out => sig_write_sum_carry_out );
    sig_write_data <= ex_write_data when reset = '0' else (others=>'0');
    sig_write_sum <= ex_write_sum when reset = '0' else (others=>'0');
    sig_candidate_w <= sig_candidate_r when reset = '0' else (others=>'0');
    sig_district_w <= sig_district_r when reset = '0' else (others=>'0');
    sig_mem_write <= sig_mem_read when reset = '0' else '0';
    
    data_memory: tally_table
        generic map (
            NUM_CANDIDATE => sig_num_candidate,
            NUM_DISTRICT => sig_num_district,
            NUM_TALLY => sig_num_tally
        )
        port map ( 
            reset        => reset,
            clk          => clk,
            read_enable  => sig_mem_read,
            candidate_r  => sig_candidate_r,
            district_r   => sig_district_r,
            read_data    => sig_read_data,
            read_sum     => sig_read_sum,
            write_enable => sig_mem_write,
            write_data   => sig_write_data,
            write_sum    => sig_write_sum,
            candidate_w  => sig_candidate_w,
            district_w   => sig_district_w,
            data_out     => sig_data_out,
            sum_out      => sig_sum_out  
        );
        
        mem_data_out <= sig_data_out when reset = '0' else (others=>'0');
        mem_sum_out <= sig_sum_out when reset = '0' else (others=>'0');
end structural;
