library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project is
    port ( 
           btnR   : in  std_logic;
           vlk    : in  std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0) );
end project;

architecture structural of project is

component program_counter is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(3 downto 0);
           addr_out : out std_logic_vector(3 downto 0) );
end component;

component instruction_memory is
    port ( reset    : in  std_logic;
           addr_in  : in  std_logic_vector(3 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end component;

component sign_extend_4to16 is
    port ( data_in  : in  std_logic_vector(3 downto 0);
           data_out : out std_logic_vector(15 downto 0) );
end component;

component mux_2to1_4b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(3 downto 0);
           data_b     : in  std_logic_vector(3 downto 0);
           data_out   : out std_logic_vector(3 downto 0) );
end component;

component mux_2to1_16b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(15 downto 0);
           data_b     : in  std_logic_vector(15 downto 0);
           data_out   : out std_logic_vector(15 downto 0) );
end component;

component control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           reg_dst    : out std_logic;
           reg_write  : out std_logic;
           alu_src    : out std_logic;
           mem_write  : out std_logic;
           mem_to_reg : out std_logic;
           branch     : out std_logic;
           disp       : out std_logic;
           sw_to_reg  : out std_logic );
end component;

component register_file is
    port (  reset             : in  std_logic;
            clk               : in  std_logic;
            led_output_en     : in  std_logic;
            read_register_a   : in  std_logic_vector(3 downto 0);
            read_register_b   : in  std_logic_vector(3 downto 0);
            write_enable      : in  std_logic;
            write_register    : in  std_logic_vector(3 downto 0);
            write_data        : in  std_logic_vector(15 downto 0);
            read_data_a       : out std_logic_vector(15 downto 0);
            read_data_b       : out std_logic_vector(15 downto 0);
            led               : out std_logic_vector(15 downto 0) );
end component;

component adder_4b is
    port ( src_a     : in  std_logic_vector(3 downto 0);
           src_b     : in  std_logic_vector(3 downto 0);
           sum       : out std_logic_vector(3 downto 0);
           carry_out : out std_logic );
end component;

component adder_16b is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           sum       : out std_logic_vector(15 downto 0);
           carry_out : out std_logic;
           zero      : out std_logic );
end component;

component data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(15 downto 0);
           addr_in      : in  std_logic_vector(3 downto 0);
           data_out     : out std_logic_vector(15 downto 0) );
end component;

component debounce is
        Port (
        clk      : in  std_logic;  -- 100 MHz clock
        btn_in   : in  std_logic;  -- raw button input
        btn_out  : out std_logic   -- debounced output
    );
end component;

signal sig_next_pc              : std_logic_vector(3 downto 0);
signal sig_curr_pc              : std_logic_vector(3 downto 0);
signal sig_pc_carry_out         : std_logic;

signal sig_instr_src             : std_logic_vector(15 downto 0);
signal sig_instr                 : std_logic_vector(15 downto 0);

signal sig_sign_extended_offset : std_logic_vector(15 downto 0);
signal sig_reg_dst              : std_logic;
signal sig_reg_write            : std_logic;
signal sig_alu_src              : std_logic;
signal sig_mem_write            : std_logic;
signal sig_mem_to_reg           : std_logic;
signal sig_write_register       : std_logic_vector(3 downto 0);
signal sig_write_data           : std_logic_vector(15 downto 0);
signal sig_read_data_a          : std_logic_vector(15 downto 0);
signal sig_read_data_b          : std_logic_vector(15 downto 0);
signal sig_alu_src_b            : std_logic_vector(15 downto 0);
signal sig_alu_result           : std_logic_vector(15 downto 0); 
signal sig_alu_carry_out        : std_logic;
signal sig_data_mem_out         : std_logic_vector(15 downto 0);

-- Own Signals
signal sig_branch               : std_logic;
signal sig_normal_next_pc       : std_logic_vector(3 downto 0);
signal sig_branch_next_pc       : std_logic_vector(3 downto 0);
signal sig_pc_branch_carry_out  : std_logic;
signal sig_pc_mux_select        : std_logic;
signal sig_mux_mem_to_reg_result: std_logic_vector(15 downto 0);
signal sig_stall : std_logic;

signal reset                    : std_logic;
signal clk : std_logic := '0';  -- internal slow clock
signal clk_count : integer := 0;
constant DIVISOR : integer := 50_000_000; -- adjust as needed

begin
    debouncer_r : debounce
    port map ( clk     => clk,
               btn_in  => btnR,
               btn_out => reset );

    pc : program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc );                                

    next_pc : adder_4b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => "0001",
               sum       => sig_normal_next_pc,   
               carry_out => sig_pc_carry_out);
               
    branch_pc : adder_4b
    port map ( src_a     => sig_normal_next_pc,
               src_b     => sig_instr(3 downto 0),
               sum       => sig_branch_next_pc,
               carry_out => sig_pc_branch_carry_out);
               
    pc_src : mux_2to1_4b
    port map ( mux_select => sig_branch,
               data_a     => sig_normal_next_pc,
               data_b     => sig_branch_next_pc,
               data_out   => sig_next_pc);
    
    insn_mem : instruction_memory 
    port map ( reset    => reset,
               addr_in  => sig_curr_pc,
               insn_out => sig_instr_src);
               
    pipe_reg_if_id: entity work.pipe_reg_if_id
    port map (
      clk => clk,
      reset => reset,
      stall => sig_stall,
      instr_in => sig_instr_src,
      instr_out => sig_instr);
    
    sign_extend : sign_extend_4to16 
    port map ( data_in  => sig_instr(3 downto 0),
               data_out => sig_sign_extended_offset );

    ctrl_unit : control_unit 
    port map ( opcode     => sig_instr(15 downto 12),
               reg_dst    => sig_reg_dst,
               reg_write  => sig_reg_write,
               alu_src    => sig_alu_src,
               mem_write  => sig_mem_write,
               mem_to_reg => sig_mem_to_reg,
               branch     => sig_branch);

    mux_reg_dst : mux_2to1_4b 
    port map ( mux_select => sig_reg_dst,
               data_a     => sig_instr(7 downto 4),
               data_b     => sig_instr(3 downto 0),
               data_out   => sig_write_register );

    reg_file : register_file 
    port map ( reset           => reset, 
               clk             => clk,
               read_register_a => sig_instr(11 downto 8),
               read_register_b => sig_instr(7 downto 4),
               write_enable    => sig_reg_write,
               write_register  => sig_write_register,
               write_data      => sig_write_data,
               read_data_a     => sig_read_data_a,
               read_data_b     => sig_read_data_b);
    
    -- All operation for assignment happend here
    decoder: entity work.decoder
    port map (
        src => sw;
    );
    
    pipe_reg_id_ex: entity work.pipe_reg_id_ex
    port map (
      clk => clk,
      reset => reset,
      stall => sig_stall,
      data_in(31 downto 16) => sig_read_data_a,
      data_in(15 downto 0) => sig_read_data_b,
      data_out(31 downto 16) => sig_read_data_a,
      data_out(15 downto 0) => sig_read_data_b,
      ctrl_MemWrite_in => sig_mem_write,
      ctrl_MemWrite_out => sig_mem_write,
      ctrl_RegWrite_in => sig_reg_write,
      ctrl_RegWrite_out => sig_reg_write,
      ctrl_Branch_in => sig_branch,
      ctrl_Branch_out => sig_branch
    );
        
    mux_alu_src : mux_2to1_16b 
    port map ( mux_select => sig_alu_src,
               data_a     => sig_read_data_b,
               data_b     => sig_sign_extended_offset,
               data_out   => sig_alu_src_b );

    alu : adder_16b 
    port map ( src_a     => sig_read_data_a,
               src_b     => sig_alu_src_b,
               sum       => sig_alu_result,
               carry_out => sig_alu_carry_out,
               zero      => "0");

   pipe_reg_ex_mem: entity work.pipe_reg_ex_mem
        port map (
          clk => clk,
          reset => reset,
          stall => sig_stall
        );

    data_mem : data_memory 
    port map ( reset        => reset,
               clk          => clk,
               write_enable => sig_mem_write,
               write_data   => sig_read_data_b,
               addr_in      => sig_alu_result(3 downto 0),
               data_out     => sig_data_mem_out );
               
    mux_mem_to_reg : mux_2to1_16b 
    port map ( mux_select => sig_mem_to_reg,
               data_a     => sig_alu_result,
               data_b     => sig_data_mem_out,
               data_out   => sig_mux_mem_to_reg_result );

    mux_sw_to_reg : mux_2to1_16b
    port map ( mux_select => sig_sw_to_reg,
               data_a     => sig_mux_mem_to_reg_result,
               data_b     => sw,
               data_out   => sig_write_data );
         
    output: entity work.disp_decoder
    port map ( data => sig_read_data_b );
end structural;
