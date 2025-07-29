library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project is
    port ( 
           btnR   : in  std_logic;
           clk    : in  std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0) );
end project;

architecture structural of project is

component block_partitioner is

    port ( clk          : in  std_logic;
           tag_sz       : in  std_logic_vector(3 downto 0);
           record_sz    : in  std_logic_vector(5 downto 0);
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : out std_logic_vector(7 downto 0);
           block_1      : out std_logic_vector(7 downto 0);
           block_2      : out std_logic_vector(7 downto 0);
           block_3      : out std_logic_vector(7 downto 0));
           
end component;

component bp_flip_pipe_reg is
    port ( clk          : in  std_logic;
           record_in   : in  std_logic_vector(31 downto 0);
           block_0      : in std_logic_vector(7 downto 0);
           block_1      : in std_logic_vector(7 downto 0);
           block_2      : in std_logic_vector(7 downto 0);
           block_3      : in std_logic_vector(7 downto 0);
           block_0_out  : out std_logic_vector(7 downto 0);
           block_1_out  : out std_logic_vector(7 downto 0);
           block_2_out  : out std_logic_vector(7 downto 0);
           block_3_out  : out std_logic_vector(7 downto 0);
           record_out   : out  std_logic_vector(31 downto 0));          
end component;

component flip_swp_pipe_reg is
    port ( clk          : in  std_logic;
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : in std_logic_vector(7 downto 0);
           block_1      : in std_logic_vector(7 downto 0);
           block_2      : in std_logic_vector(7 downto 0);
           block_3      : in std_logic_vector(7 downto 0);
           block_0_out  : out std_logic_vector(7 downto 0);
           block_1_out  : out std_logic_vector(7 downto 0);
           block_2_out  : out std_logic_vector(7 downto 0);
           block_3_out  : out std_logic_vector(7 downto 0);
           record_out   : out  std_logic_vector(31 downto 0));         
end component;

component swp_shift_pipe_reg is
    port ( clk          : in  std_logic;
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : in std_logic_vector(7 downto 0);
           block_1      : in std_logic_vector(7 downto 0);
           block_2      : in std_logic_vector(7 downto 0);
           block_3      : in std_logic_vector(7 downto 0);
           block_0_out  : out std_logic_vector(7 downto 0);
           block_1_out  : out std_logic_vector(7 downto 0);
           block_2_out  : out std_logic_vector(7 downto 0);
           block_3_out  : out std_logic_vector(7 downto 0);
           record_out   : out  std_logic_vector(31 downto 0));          
end component;

component shift_mem_pipe_reg is
    port ( clk          : in  std_logic;
           record_in    : in  std_logic_vector(31 downto 0);
           block_0      : in std_logic_vector(7 downto 0);
           block_1      : in std_logic_vector(7 downto 0);
           block_2      : in std_logic_vector(7 downto 0);
           block_3      : in std_logic_vector(7 downto 0);
           block_0_out  : out std_logic_vector(7 downto 0);
           block_1_out  : out std_logic_vector(7 downto 0);
           block_2_out  : out std_logic_vector(7 downto 0);
           block_3_out  : out std_logic_vector(7 downto 0);
           record_out   : out  std_logic_vector(31 downto 0));        
end component;

component shifter is
    port (
        s_b        : in  std_logic_vector(7 downto 0);
        block_size_in, r_in : std_logic_vector(3 downto 0);
        shift_o    : out std_logic_vector(7 downto 0)
    );
end component;

component xor_mod is
    Port ( block_a, block_b,
           block_c, block_d : in STD_LOGIC_VECTOR (7 downto 0);
           xor_out          : out STD_LOGIC_VECTOR(7 downto 0));
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

begin
    -- tag size <= 8 
    -- tag size >= record size/4
    -- record size < 32
    sig_tag_sz <= "0111";
    sig_record_sz <= "010100";
    sig_record <= "00000000000001010101010101010101";
    bp1: block_partitioner
    port map( clk          => clk,              
              tag_sz       => sig_tag_sz,
              record_sz    => sig_record_sz,
              record_in    => sig_record,
              block_0      => sig_block_0,
              block_1      => sig_block_1,
              block_2      => sig_block_2,
              block_3      => sig_block_3);

    bp_flip: bp_flip_pipe_reg
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
              
    flip_swp: flip_swp_pipe_reg
    port map( clk          => clk,
              record_in    => sig_record_flip,
              block_0      => sig_block_flip_0,
              block_1      => sig_block_flip_1,
              block_2      => sig_block_flip_2,
              block_3      => sig_block_flip_3,
              block_0_out  => sig_block_flip_0_out,
              block_1_out  => sig_block_flip_1_out,
              block_2_out  => sig_block_flip_2_out,
              block_3_out  => sig_block_flip_3_out,
              record_out   => sig_record_swp); 
              
    swp_shift: swp_shift_pipe_reg
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
    shift_mem: shift_mem_pipe_reg
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
    
    mux1 : entity work.mux_4to2
    generic map ( WIDTH => 8 );
    port map (
        data_0 => sig_block_0,
        data_1 => sig_block_1,
        data_2 => sig_block_2,
        data_3 => sig_block_3,
        block_x => "01",
        block_y => "00",
        data_out_x => sig_block_x,
        data_out_y => sig_block_y
    );

    swap1 : entity work.swap
    port map( block_x => sig_block_x,
              block_y => sig_block_y,
              px => "0001",
              py => "0001",
              s => "0001",
              bx_swapped => sig_swaped_block_1,
              by_swapped => sig_swaped_block_2);
    
    pipe_reg: entity work.pipe_reg
        GENERIC MAP (width => 35)
        port map (
          clk => clk,
          reset => btnR,
          stall => btnR,
          din => sw,
          dout => led);

    data_memory: entity work.data_memory
        port map (
           clk => clk,
           reset => btnR,
           write_enable => btnR,
           write_data => sw,
           addr_in => sw,
           data_out => led);
end structural;
