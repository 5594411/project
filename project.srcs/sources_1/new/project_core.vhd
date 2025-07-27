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

begin
    
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
