library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project is
    generic (
        NUM_CANDIDATE: Integer := 4;
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
signal sig_write_sum    : std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
signal sig_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);

signal mem_data_out: std_logic_vector(NUM_TALLY - 1 downto 0);
signal mem_sum_out: std_logic_vector(NUM_TALLY - 1 downto 0);

signal secret_key: std_logic_vector(15 downto 0);
signal final_tag: std_logic_vector(7 downto 0);
signal sig_tag: std_logic_vector(7 downto 0);

signal sig_next_pc              : std_logic_vector(3 downto 0);
signal sig_curr_pc              : std_logic_vector(3 downto 0);
signal sig_one_4b               : std_logic_vector(3 downto 0);
signal sig_pc_carry_out         : std_logic;
signal stall                    : std_logic;
signal sig_insn, sig_insn_ifid  : std_logic_vector(31 downto 0);
signal sig_reg_write            : std_logic;
signal sig_push_en              : std_logic;
signal sig_write_register       : std_logic_vector(1 downto 0);
signal sig_write_data           : std_logic_vector(31 downto 0);
signal sig_key_en, sig_mem_read : std_logic; 
signal sig_old_key              : std_logic_vector(15 downto 0);
signal rec_out                  : std_logic_vector(31 downto 0);
signal tag_out                  : std_logic_vector(7 downto 0);
signal decoder_key              : std_logic_vector(15 downto 0);
signal mem_read_idtd            : std_logic; 
signal reg_write_idtd           : std_logic;
signal rec_out_idtd             : std_logic_vector(31 downto 0);
signal tag_out_idtd             : std_logic_vector(7 downto 0);
begin
    -- tag size <= 8 
    -- tag size >= record size/4
    -- record size < 32
    sig_tag_sz <= "0100";
    sig_record_sz <= "010000";
    sig_record(15 downto 0) <= sw;
    sig_record(31 downto 16) <= "0000000000000000";
    secret_key <= "1110100001011001";
    
    pc : entity work.program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc,
               enable => '1'
                ); 

    next_pc : entity work.adder_4b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => sig_one_4b,
               sum       => sig_next_pc,   
               carry_out => sig_pc_carry_out );
    
    insn_mem : entity work.instruction_memory 
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn );
               
               
     ifid : entity work.if_id_pipe_reg port map(
        clk => clk, 
        insn_in => sig_insn,
        insn_out => sig_insn_ifid   
    );


    ctrl_unit : entity work.control_unit 
    port map ( opcode     => sig_insn(31 downto 28),
               reg_write  => sig_reg_write,
               push_en => sig_push_en,
               key_en => sig_key_en,
               mem_read => sig_mem_read
                );
                

    reg_file : entity work.register_file 
    port map ( reset           => reset, 
               clk             => clk,
               old_key         => sig_old_key,
               new_key         =>  sig_insn(15 downto 0),
               write_enable    => sig_reg_write,
               write_register  => sig_write_register,
               write_data      => sig_write_data,
               stall => stall, 
               key_en           => sig_key_en);
               
    
    rec_q : entity work.record_queue
    port map(
        reset =>reset,
        clk => clk, 
        push_en     => sig_push_en,
        record_out => rec_out,
        tag_out => tag_out
    );
   
    idtd : entity work.id_td_pipe_reg port map(
        clk => clk, 
        sk_in => sig_old_key, 
        sk_out => decoder_key,
        mem_read_in => sig_mem_read, 
        mem_read_out => mem_read_idtd, 
        register_write_in => sig_reg_write, 
        register_write_out => reg_write_idtd,
        record_in=>rec_out,
        record_out=>rec_out_idtd,
        tag_in=>tag_out,
        tag_out=>tag_out_idtd
    
    );
    
    decoder1: entity work.decoder_core
    port map ( clk => clk,
               record_in => sig_record,
               tag_out => sig_tag);
    
    record_reg: entity work.pipe_reg
    generic map ( WIDTH => 8 )
    port map (clk => clk,
              din => final_tag,
              dout => sig_tag);
    
        
    mux_select_candidate <= '1' when (sig_candidate_r = sig_candidate_w) else '0';
    mux_select_district <= '1' when (sig_candidate_r = sig_candidate_w and sig_district_r = sig_district_w ) else '0';
    
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
               src_b     => sig_record(TAG_SIZE + NUM_TALLY - 1 downto TAG_SIZE),
               sum       => ex_write_data,
               carry_out => sig_write_data_carry_out );
    
    alu_write_sum : entity work.adder_8b 
    port map ( src_a     => ex_read_sum,
               src_b     => sig_record(TAG_SIZE + NUM_TALLY - 1 downto TAG_SIZE),
               sum       => ex_write_sum,
               carry_out => sig_write_sum_carry_out );
               
    process(clk, reset)
    begin
        if (reset = '1') then
            sig_write_data <= (others=>'0');
            sig_write_sum <= (others=>'0');
            sig_candidate_w <= (others=>'0');
            sig_district_w <= (others=>'0');
            sig_mem_write <= '0';
        elsif (rising_edge(clk)) then
            sig_write_data(7 downto 0) <= ex_write_data;
            sig_write_sum <= ex_write_sum;
            sig_candidate_w <= sig_candidate_r;
            sig_district_w <= sig_district_r;
            sig_mem_write <= sig_mem_read;
        end if;
    end process;
--    sig_write_data <= ex_write_data when reset = '0' else (others=>'0');
--    sig_write_sum <= ex_write_sum when reset = '0' else (others=>'0');
--    sig_candidate_w <= sig_candidate_r when reset = '0' else (others=>'0');
--    sig_district_w <= sig_district_r when reset = '0' else (others=>'0');
--    sig_mem_write <= sig_mem_read when reset = '0' else '0';
    
    data_memory: entity work.tally_table
        generic map (
            NUM_CANDIDATE => NUM_CANDIDATE,
            NUM_DISTRICT => NUM_DISTRICT,
            NUM_TALLY => NUM_TALLY
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
            write_data   => sig_write_data(7 downto 0),
            write_sum    => sig_write_sum,
            candidate_w  => sig_candidate_w,
            district_w   => sig_district_w,
            data_out     => sig_data_out,
            sum_out      => sig_sum_out  
        );
        
        mem_data_out <= sig_data_out when reset = '0' else (others=>'0');
        mem_sum_out <= sig_sum_out when reset = '0' else (others=>'0');
        led(7 downto 0) <= mem_sum_out;
end structural;
