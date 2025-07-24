---------------------------------------------------------------------------
-- single_cycle_core.vhd - A Single-Cycle Processor Implementation
--
-- Notes : 
--
-- See single_cycle_core.pdf for the block diagram of this single
-- cycle processor core.
--
-- Instruction Set Architecture (ISA) for the single-cycle-core:
--   Each instruction is 16-bit wide, with four 4-bit fields.
--
--     noop      
--        # no operation or to signal end of program
--        # format:  | opcode = 0 |  0   |  0   |   0    | 
--
--     load  rt, rs, offset     
--        # load data at memory location (rs + offset) into rt
--        # format:  | opcode = 1 |  rs  |  rt  | offset |
--
--     store rt, rs, offset
--        # store data rt into memory location (rs + offset)
--        # format:  | opcode = 3 |  rs  |  rt  | offset |
--
--     add   rd, rs, rt
--        # rd <- rs + rt
--        # format:  | opcode = 8 |  rs  |  rt  |   rd   |
--
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity single_cycle_core is
    port ( 
--           reset  : in  std_logic;
           btnR   : in  std_logic;
           clk_1    : in  std_logic;
--           btnC   : in std_logic;
           sw     : in  std_logic_vector(15 downto 0);
           led    : out  std_logic_vector(15 downto 0) );
end single_cycle_core;

architecture structural of single_cycle_core is

component program_counter is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(3 downto 0);
           addr_out : out std_logic_vector(3 downto 0) );
end component;

component instruction_memory is
    port ( reset    : in  std_logic;
--           clk      : in  std_logic;
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
signal sig_one_4b               : std_logic_vector(3 downto 0);
signal sig_pc_carry_out         : std_logic;
signal sig_insn                 : std_logic_vector(15 downto 0);
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
signal sig_zero                 : std_logic;
signal sig_branch               : std_logic;
signal sig_normal_next_pc       : std_logic_vector(3 downto 0);
signal sig_branch_next_pc       : std_logic_vector(3 downto 0);
signal sig_pc_branch_carry_out  : std_logic;
signal sig_pc_mux_select        : std_logic;
signal sig_disp                 : std_logic;
signal sig_mux_mem_to_reg_result: std_logic_vector(15 downto 0);
signal sig_sw_to_reg            : std_logic;

signal reset                    : std_logic;
signal clk : std_logic := '0';  -- internal slow clock
signal clk_count : integer := 0;
constant DIVISOR : integer := 50_000_000; -- adjust as needed

begin

    process(clk_1)
    begin
        if rising_edge(clk_1) then
            if clk_count = DIVISOR/2 - 1 then
                clk <= not clk;
                clk_count <= 0;
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;

    debouncer_r : debounce
    port map ( clk     => clk,
               btn_in  => btnR,
               btn_out => reset );
    
    sig_one_4b <= "0001";

    pc : program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc );                                

    next_pc : adder_4b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => sig_one_4b,
               sum       => sig_normal_next_pc,   
               carry_out => sig_pc_carry_out );
               
    branch_pc : adder_4b
    port map ( src_a     => sig_normal_next_pc, -- changed from output from next_pc
               src_b     => sig_insn(3 downto 0),
               sum       => sig_branch_next_pc,
               carry_out => sig_pc_branch_carry_out );
               
    sig_pc_mux_select <= sig_branch AND sig_zero;
               
    pc_src : mux_2to1_4b
    port map ( mux_select => sig_pc_mux_select,
               data_a     => sig_normal_next_pc,
               data_b     => sig_branch_next_pc,
               data_out   => sig_next_pc);
    
    insn_mem : instruction_memory 
    port map ( reset    => reset,
--               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn );

    sign_extend : sign_extend_4to16 
    port map ( data_in  => sig_insn(3 downto 0),
               data_out => sig_sign_extended_offset );

    ctrl_unit : control_unit 
    port map ( opcode     => sig_insn(15 downto 12),
               reg_dst    => sig_reg_dst,
               reg_write  => sig_reg_write,
               alu_src    => sig_alu_src,
               mem_write  => sig_mem_write,
               mem_to_reg => sig_mem_to_reg,
               branch     => sig_branch,
               disp       => sig_disp,
               sw_to_reg  => sig_sw_to_reg );

    mux_reg_dst : mux_2to1_4b 
    port map ( mux_select => sig_reg_dst,
               data_a     => sig_insn(7 downto 4),
               data_b     => sig_insn(3 downto 0),
               data_out   => sig_write_register );

    reg_file : register_file 
    port map ( reset           => reset, 
               clk             => clk,
               led_output_en   => sig_disp,
               read_register_a => sig_insn(11 downto 8),
               read_register_b => sig_insn(7 downto 4),
               write_enable    => sig_reg_write,
               write_register  => sig_write_register,
               write_data      => sig_write_data,
               read_data_a     => sig_read_data_a,
               read_data_b     => sig_read_data_b,
               led             => led );
    
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
               zero      => sig_zero );

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

end structural;
