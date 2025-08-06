library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project is
    generic (
        NUM_CANDIDATE: integer := 2; -- Bits for canidates
--        save the last column as sum for specfic candidate
        NUM_DISTRICT: integer := 2;
        NUM_TALLY: integer := 8; -- Bits for size of the tally
        TAG_SIZE: integer := 4;
        RECORD_SIZE : integer := 12
    );
    port ( 
           btnR   : in  std_logic;
           btnC   : in  std_logic;
           btnL : in std_logic;
           btnU : in std_logic;
           btnD : in std_logic;
           clk    : in  std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0);
           an : out std_logic_vector(3 downto 0);
           dp : out std_logic;
           seg : out std_logic_vector(6 downto 0) );
end project;

architecture structural of project is
component mux_4to1_8b is
generic 
    (
        NUM_TALLY: integer := 8
    );
    port 
    (
        btnU     : in std_logic;
        btnR     : in std_logic;
        btnD     : in std_logic;
        btnL     : in std_logic;
        dataA    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataB    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataC    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataD    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        data_out : out std_logic_vector(NUM_TALLY - 1 downto 0)
    );
end component;

component record_queue is
    generic ( SW_TAG_SIZE : integer := 4;
              SW_RECORD_SIZE : integer := 12 );
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           push_en      : in  std_logic;
           record_in : in std_logic_vector(15 downto 0);
           record_out   : out std_logic_vector(31 downto 0);
           tag_out      : out std_logic_vector(7 downto 0));
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

signal tag_match          : std_logic;
signal decoder_record_in : std_logic_vector(31 downto 0);

-- Display signals
signal c0, c1, c2, c3 : std_logic_vector(NUM_TALLY - 1 downto 0);
signal clk_divider    : std_logic_vector(15 downto 0);
signal display_data, temp_data   : std_logic_vector(NUM_TALLY - 1 downto 0);
signal result : integer range 0 to 1024;
begin
    -- tag size <= 8 
    -- tag size >= record size/4
    -- record size < 32
    sig_tag_sz <= "0100";
    sig_record_sz <= "010000";
    secret_key <= "1110100001011001";
    reset <= btnR;
    sig_one_4b <= "0001";
    
    pc : entity work.program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc,
               enable => '1' ); 

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
               
               
     ifid : entity work.if_id_pipe_reg
     port map( clk => clk, 
               insn_in => sig_insn,
               insn_out => sig_insn_ifid );


    ctrl_unit : entity work.control_unit 
    port map ( opcode     => sig_insn(31 downto 28),
               reg_write  => sig_reg_write,
               push_en => sig_push_en,
               key_en => sig_key_en,
               mem_read => sig_mem_read );

    reg_file : entity work.register_file 
    port map ( reset           => reset, 
               clk             => clk,
               old_key         => sig_old_key,
               new_key         => sig_insn(15 downto 0),
               write_enable    => sig_reg_write,
               write_register  => sig_write_register,
               write_data      => sig_write_data,
               stall => stall, 
               key_en           => sig_key_en);
               
    
    rec_q : record_queue
    port map(
        reset =>reset,
        clk => clk,
        push_en  => sig_push_en,
        record_in => sw,
        record_out => rec_out,
        tag_out => tag_out
    );
   
    idtd : entity work.id_td_pipe_reg
    port map( clk => clk, 
              -- sk_in => sig_old_key, 
              sk_in => secret_key,
              sk_out => decoder_key,
              mem_read_in => sig_mem_read, 
              mem_read_out => mem_read_idtd, 
              register_write_in => sig_reg_write, 
              register_write_out => reg_write_idtd,
              record_in => rec_out,
              record_out=> rec_out_idtd,
              tag_in => tag_out,
              tag_out => tag_out_idtd );

    decoder1: entity work.decoder_core
    generic map ( TAG_SIZE => TAG_SIZE,
                  RECORD_SIZE => RECORD_SIZE)
    port map ( clk => clk,
               decoder_key => decoder_key,
               record_in => rec_out_idtd,
               record_out => sig_record,
               expect_tag => tag_out_idtd,
               tag_match => tag_match);
 
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
            sum_out      => sig_sum_out,
            c0 => c0,
            c1 => c1,
            c2 => c2,
            c3 => c3
        );
        
    mem_data_out <= (others=>'0') when (reset = '1') else sig_data_out;
    mem_sum_out <= (others=>'0') when (reset = '1') else sig_sum_out;
    
    -- Mux that chooses between the memory outputs and sends into final data
    display_mux: mux_4to1_8b
        generic map
        (
            NUM_TALLY => NUM_TALLY
        )
        port map 
        (
            btnU => btnU,
            btnR => btnR,
            btnD => btnD,
            btnL => btnL,
            dataA => c0,
            dataB => c1,
            dataC => c2,
            dataD => c3,
            data_out => temp_data
        );
    
    -- Asynch display process after data memory -> convert binary to bcd
    result <= to_integer(unsigned(temp_data));
    process(clk)
    begin
        if rising_edge(clk) then
            clk_divider <= clk_divider + 1;
        case clk_divider(15 downto 14) is
            when "00" => 
                an <= "1110"; 
                display_data <= std_logic_vector(to_unsigned(result mod  10, 8));
            when "01" => 
                an <= "1101"; 
                display_data <= std_logic_vector(to_unsigned(result / 10 mod 10, 8));
            when "10" => 
                an <= "1011"; 
                display_data <= std_logic_vector(to_unsigned(result / 100, 8));
            when others => 
                an <= "0111"; 
                display_data <= (others => '0');
            end case;
        end if;
    end process;

    -- BCD to 7-segment
    process(display_data)
    begin
        case display_data is
            when "00000000" => seg <= "1000000";
            when "00000001" => seg <= "1111001";
            when "00000010" => seg <= "0100100";
            when "00000011" => seg <= "0110000";
            when "00000100" => seg <= "0011001";
            when "00000101" => seg <= "0010010";
            when "00000110" => seg <= "0000010";
            when "00000111" => seg <= "1111000";
            when "00001000" => seg <= "0000000";
            when "00001001" => seg <= "0010000";
            when others => seg <= "1111111";  -- Blank
        end case;
    end process;


end structural;
