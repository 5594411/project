----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2025 12:55:57
-- Design Name: 
-- Module Name: pipe_reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PipeReg is
  generic (
    WIDTH : integer := 32
  );
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    stall    : in  std_logic;                          -- '1' to hold, '0' to update
    flush    : in  std_logic;                          -- '1' to clear to all-zero (bubble)
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    dout     : buffer std_logic_vector(WIDTH-1 downto 0)
  );
end entity;

architecture Behavioral of PipeReg is
begin
    process(clk, reset)
    begin
        if reset= '1' then
            dout <= (others=>'0');
        elsif rising_edge(clk) then
            if stall = '1' then
                dout <= dout;              -- hold old value
            elsif flush = '1' then
                dout <= (others=>'0');     -- bubble
            else
                 dout <= din;               -- normal update
            end if;
        end if;
    end process;
end architecture;

adadadadad;


-- 1) IF/ID pipeline register (instruction+pc)
constant IFID_WIDTH : integer := 16 + 4;
signal IFID_bus_in, IFID_bus_out : std_logic_vector(IFID_WIDTH-1 downto 0);

-- 2) ID/EX pipeline register 
--    (pc, regA, regB, signimm, rs, rt, rd, control[9 bits])
constant IDEX_WIDTH : integer := 
     4  -- pc_plus1
  + 16 -- read_data1
  + 16 -- read_data2
  + 16 -- sign_ext_imm
  + 4  -- rs
  + 4  -- rt
  + 4  -- rd
  + 9; -- ctrl signals
signal IDEX_bus_in, IDEX_bus_out : std_logic_vector(IDEX_WIDTH-1 downto 0);

-- 3) EX/MEM
constant EXMEM_WIDTH : integer := 
     16 -- alu_result
   + 16 -- write_data
   + 4  -- write_reg
   + 6; -- control signals
signal EXMEM_bus_in, EXMEM_bus_out : std_logic_vector(EXMEM_WIDTH-1 downto 0);

-- 4) MEM/WB
constant MEMWB_WIDTH : integer := 
     16 -- mem_data
   + 16 -- alu_result
   + 4  -- write_reg
   + 4; -- control signals
signal MEMWB_bus_in, MEMWB_bus_out : std_logic_vector(MEMWB_WIDTH-1 downto 0);

IFID_bus_in <= 
      IF_ID_instr      &   -- (15 downto 0)
      IF_ID_pc_plus1;      -- (3 downto 0)

-- IF/ID
IF_ID_reg : entity work.PipeReg
  generic map (WIDTH => IFID_WIDTH)
  port map (
    clk   => clk,
    reset => reset,
    stall => stall_IFID,   -- hook up your stall signal
    flush => flush_IFID,   -- for branch flush
    din   => IFID_bus_in,
    dout  => IFID_bus_out
);

IF_ID_instr    <= IFID_bus_out(IFID_WIDTH-1 downto 4);   -- [19:4]
IF_ID_pc_plus1 <= IFID_bus_out(3 downto 0);              -- [3:0]

IDEX_bus_in <=
     ID_EX_pc_plus1       &  -- 4 bits
     ID_EX_read_data1     &  -- 16 bits
     ID_EX_read_data2     &  -- 16 bits
     ID_EX_sign_ext_imm   &  -- 16 bits
     ID_EX_rs             &  -- 4 bits
     ID_EX_rt             &  -- 4 bits
     ID_EX_rd             &  -- 4 bits
     ID_EX_ctrl_RegDst    &
     ID_EX_ctrl_ALUSrc    &
     ID_EX_ctrl_ALUOp     &  -- 2 bits
     ID_EX_ctrl_MemRead   &
     ID_EX_ctrl_MemWrite  &
     ID_EX_ctrl_RegWrite  &
     ID_EX_ctrl_MemtoReg  &
     ID_EX_ctrl_Branch;      

-- ID/EX
ID_EX_reg : entity work.PipeReg
  generic map (WIDTH => IDEX_WIDTH)
  port map (
    clk   => clk,
    reset => reset,
    stall => stall_IDEX,
    flush => flush_IDEX,
    din   => IDEX_bus_in,
    dout  => IDEX_bus_out
);

-- EX/MEM
EX_MEM_reg : entity work.PipeReg
  generic map (WIDTH => EXMEM_WIDTH)
  port map (
    clk   => clk,
    reset => reset,
    stall => '0',          -- typically no stall here
    flush => '0',
    din   => EXMEM_bus_in,
    dout  => EXMEM_bus_out
);

-- MEM/WB
MEM_WB_reg : entity work.PipeReg
  generic map (WIDTH => MEMWB_WIDTH)
  port map (
    clk   => clk,
    reset => reset,
    stall => '0',
    flush => '0',
    din   => MEMWB_bus_in,
    dout  => MEMWB_bus_out
);




-- Forwarding Unit
ForwardA <= "10" when EX_MEM_ctrl_RegWrite = '1' 
               and EX_MEM_write_reg = ID_EX_rs else
            "01" when MEM_WB_ctrl_RegWrite = '1' 
               and MEM_WB_write_reg = ID_EX_rs else
            "00";

ForwardB <= "10" when EX_MEM_ctrl_RegWrite = '1' 
               and EX_MEM_write_reg = ID_EX_rt else
            "01" when MEM_WB_ctrl_RegWrite = '1' 
               and MEM_WB_write_reg = ID_EX_rt else
            "00";

-- Hazard Detection for Load-Use
if ID_EX_ctrl_MemRead = '1' and
   (ID_EX_rt = IF_ID_instr(11 downto 8) or ID_EX_rt = IF_ID_instr(7 downto 4)) then
    stall_pipeline <= '1';
else
    stall_pipeline <= '0';
end if;

-- Branch Flush
if EX_MEM_ctrl_Branch = '1' and EX_MEM_zero_flag = '1' then
    flush_IF_ID  <= '1';
    flush_ID_EX  <= '1';
else
    flush_IF_ID  <= '0';
    flush_ID_EX  <= '0';
end if;


-- IF/ID Register
process(clk)
begin
  if rising_edge(clk) then
    IF_ID_instr    <= instruction_memory_out;  
    IF_ID_pc_plus1 <= sig_next_pc;              
  end if;
end process;


-- ID/EX Register
process(clk)
begin
  if rising_edge(clk) then
    ID_EX_pc_plus1     <= IF_ID_pc_plus1;
    ID_EX_read_data1   <= reg_read_data1;
    ID_EX_read_data2   <= reg_read_data2;
    ID_EX_sign_ext_imm <= sign_ext_imm;
    ID_EX_rs           <= IF_ID_instr(11 downto 8);
    ID_EX_rt           <= IF_ID_instr(7  downto 4);
    ID_EX_rd           <= IF_ID_instr(3  downto 0);

    -- control signals from control unit
    ID_EX_ctrl_RegDst   <= ctrl_RegDst;
    ID_EX_ctrl_ALUSrc   <= ctrl_ALUSrc;
    ID_EX_ctrl_ALUOp    <= ctrl_ALUOp;
    ID_EX_ctrl_MemRead  <= ctrl_MemRead;
    ID_EX_ctrl_MemWrite <= ctrl_MemWrite;
    ID_EX_ctrl_RegWrite <= ctrl_RegWrite;
    ID_EX_ctrl_MemtoReg <= ctrl_MemtoReg;
    ID_EX_ctrl_Branch   <= ctrl_Branch;
    ID_EX_ctrl_SwToReg  <= ctrl_SwToReg;
    ID_EX_ctrl_Disp     <= ctrl_Disp;
  end if;
end process;


-- EX/MEM Register
process(clk)
begin
  if rising_edge(clk) then
    EX_MEM_alu_result   <= alu_result;
    EX_MEM_write_data   <= forwarded_dataB;  -- after forwarding mux
    EX_MEM_write_reg    <= write_register_mux;  
    EX_MEM_zero_flag    <= alu_zero;

    EX_MEM_ctrl_MemRead  <= ID_EX_ctrl_MemRead;
    EX_MEM_ctrl_MemWrite <= ID_EX_ctrl_MemWrite;
    EX_MEM_ctrl_RegWrite <= ID_EX_ctrl_RegWrite;
    EX_MEM_ctrl_MemtoReg <= ID_EX_ctrl_MemtoReg;
    EX_MEM_ctrl_Branch   <= ID_EX_ctrl_Branch;
    EX_MEM_ctrl_SwToReg  <= ID_EX_ctrl_SwToReg;
    EX_MEM_ctrl_Disp     <= ID_EX_ctrl_Disp;
  end if;
end process;


-- MEM/WB Register
process(clk)
begin
  if rising_edge(clk) then
    MEM_WB_mem_data   <= data_memory_out;
    MEM_WB_alu_result <= EX_MEM_alu_result;
    MEM_WB_write_reg  <= EX_MEM_write_reg;

    MEM_WB_ctrl_RegWrite <= EX_MEM_ctrl_RegWrite;
    MEM_WB_ctrl_MemtoReg <= EX_MEM_ctrl_MemtoReg;
    MEM_WB_ctrl_SwToReg  <= EX_MEM_ctrl_SwToReg;
    MEM_WB_ctrl_Disp     <= EX_MEM_ctrl_Disp;
  end if;
end process;




