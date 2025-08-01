library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity block_pipe_reg is
    Port ( clk : std_logic;
           record_in : in std_logic_vector(31 downto 0);
           block_0 : in std_logic_vector(7 downto 0);
           block_1 : in std_logic_vector(7 downto 0);
           block_2 : in std_logic_vector(7 downto 0);
           block_3 : in std_logic_vector(7 downto 0);
           record_out : out std_logic_vector(31 downto 0);
           block_0_out : out std_logic_vector(7 downto 0);
           block_1_out : out std_logic_vector(7 downto 0);
           block_2_out : out std_logic_vector(7 downto 0);
           block_3_out : out std_logic_vector(7 downto 0)
);
end block_pipe_reg;

architecture Behavioral of block_pipe_reg is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            record_out <= record_in;
            block_0_out <= block_0;
            block_1_out <= block_1;
            block_2_out <= block_2;
            block_3_out <= block_3;
        end if;
    end process;
end Behavioral;
