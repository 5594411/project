---------------------------------------------------------------------------
-- instruction_memory.vhd - Implementation of A Single-Port, 16 x 16-bit
--                          Instruction Memory.
-- 
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
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

entity instruction_memory is
    port ( reset    : in  std_logic;
--           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(3 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end instruction_memory;



architecture behavioral of instruction_memory is

    type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);
    signal sig_insn_mem : mem_array;

begin
    
    -- Instruction run down:
    -- LOAD:  (1) | 4 OPCODE | 4 MEM_ADDR | 4 R_DST | 4 OFFSET |
    -- STORE: (3) | 4 OPCODE | 4 MEM_ADDR | 4 R_SRC | 4 OFFSET |
    -- BEQ:   (4) | 4 OPCODE | 4 REG_TAR  | 4 R_SRC | 4 OFFSET |
    -- DISP:  (5) | 4 OPCODE | 4 MEM_ADDR | 4 R_15  | 4 OFFSET |
    -- READ:  (6) | 4 OPCODE | 4 NA       | 4 R_SRC | 4 NA     |
    -- ADD:   (8) | 4 OPCODE | 4 REG_SRC  | 4 R_TAR | 4 R_DST  |
    
    -- Process to initialize instruction memory on reset
    init_process: process (reset)
    begin
        if reset = '1' then
            sig_insn_mem(0)  <= X"50F1"; -- Display Initial Value of 1438
            sig_insn_mem(1)  <= X"1011"; -- Load 1438_16 into $1
            sig_insn_mem(2)  <= X"6020"; -- Read SW into $2
            sig_insn_mem(3)  <= X"8123"; -- Add $3 <- $1, $2
            sig_insn_mem(4)  <= X"3030"; -- Store into DM
            sig_insn_mem(5)  <= X"50F1"; -- Display stored value
            sig_insn_mem(6)  <= X"0000";
            sig_insn_mem(7)  <= X"0000";
            sig_insn_mem(8)  <= X"0000";
            sig_insn_mem(9)  <= X"0000";
            sig_insn_mem(10)  <= X"0000";
            sig_insn_mem(11) <= X"0000";
            sig_insn_mem(12) <= X"0000";
            sig_insn_mem(13) <= X"0000";
            sig_insn_mem(14) <= X"0000";
            sig_insn_mem(15) <= X"0000";
        end if;
    end process;

    -- Combinational read: output updates instantly with addr_in
    insn_out <= sig_insn_mem(conv_integer(addr_in));

end behavioral;

--architecture behavioral of instruction_memory is

--type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);
--signal sig_insn_mem : mem_array;

--begin
--    mem_process: process ( clk,
--                           addr_in ) is
  
--    variable var_insn_mem : mem_array;
--    variable var_addr     : integer;
  
--    begin
--        if (reset = '1') then
--            -- initial values of the instruction memory :
--            --  insn_0 : load  $1, $0, 0   - load data 0($0) into $1
--            --  insn_1 : load  $2, $0, 1   - load data 1($0) into $2
--            --  insn_2 : add   $3, $0, $1  - $3 <- $0 + $1
--            --  insn_3 : add   $4, $1, $2  - $4 <- $1 + $2
--            --  insn_4 : store $3, $0, 2   - store data $3 into 2($0)
--            --  insn_5 : store $4, $0, 3   - store data $4 into 3($0)
--            --  insn_6 - insn_15 : noop    - end of program

--            var_insn_mem(0)  := X"1010";
--            var_insn_mem(1)  := X"1020";
--            var_insn_mem(2)  := X"4123";
--            var_insn_mem(3)  := X"8012";
--            var_insn_mem(4)  := X"8011";
--            var_insn_mem(5)  := X"0000";
--            var_insn_mem(6)  := X"8123";
--            var_insn_mem(7)  := X"3340";
--            var_insn_mem(8)  := X"0000";
--            var_insn_mem(9)  := X"0000";
--            var_insn_mem(10) := X"0000";
--            var_insn_mem(11) := X"0000";
--            var_insn_mem(12) := X"0000";
--            var_insn_mem(13) := X"0000";
--            var_insn_mem(14) := X"0000";
--            var_insn_mem(15) := X"0000";
--        end if;
        
--        if (rising_edge(clk)) then
--            -- read instructions on the rising clock edge
--            var_addr := conv_integer(addr_in);
--            insn_out <= var_insn_mem(var_addr);
--        end if;

--        -- the following are probe signals (for simulation purpose)
--        sig_insn_mem <= var_insn_mem;

--    end process;
  
--end behavioral;