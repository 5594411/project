-- For simulation purposes to have generic

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_queue is
  generic (
    DATA_WIDTH  : integer := 32;  -- width of each record + tag
    QUEUE_DEPTH : integer := 16   -- depth of the quueue
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;     -- sync active-high reset
    enq   : in  std_logic;     -- pulse to enqueue the word on 'din'
    din   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    dout  : out std_logic_vector(DATA_WIDTH-1 downto 0) -- use external signals to pass to block partitioner as disp skips
--    full  : out std_logic; -- Debugging 
--    empty : out std_logic
  );
end instruction_queue;

architecture behavioral of instruction_queue is

  -- Storage array
  type ram_t is array (0 to QUEUE_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ram     : ram_t := (others => (others => '0'));

  -- Pointers & count
  signal wr_ptr  : integer range 0 to QUEUE_DEPTH-1 := 0;
  signal rd_ptr  : integer range 0 to QUEUE_DEPTH-1 := 0;
  signal count   : integer range 0 to QUEUE_DEPTH   := 0;

begin

--  -- Status flags
--  full  <= '1' when count = QUEUE_DEPTH else '0';
--  empty <= '1' when count = 0           else '0';

  -- Output: head of queue or zeros if empty
  dout  <= ram(rd_ptr) when count > 0
           else (others => '0');

process(clk)
  variable v_wr    : integer := 0;
  variable v_rd    : integer := 0;
  variable v_count : integer := 0;
begin
  if rising_edge(clk) then
    if rst = '1' then
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
      ram    <= (others => (others => '0'));
    else
      -- copy state into variables
      v_wr    := wr_ptr;
      v_rd    := rd_ptr;
      v_count := count;

      -- enqueue (signal ram!) if requested & not full
      if enq = '1' and v_count < QUEUE_DEPTH then
        ram(v_wr) <= din;                      -- 
        v_wr     := (v_wr + 1) mod QUEUE_DEPTH;-- 
        v_count  := v_count + 1;               -- 
      end if;

      -- automatic dequeue to pass through next instruction 
      if v_count > 0 then
        v_rd     := (v_rd + 1) mod QUEUE_DEPTH;
        v_count  := v_count - 1;
      end if;

      -- write back updated state to signals
      wr_ptr <= v_wr;
      rd_ptr <= v_rd;
      count  <= v_count;
    end if;
  end if;
end process;

end behavioral;