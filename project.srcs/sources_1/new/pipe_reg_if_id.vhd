library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipe_reg_if_id is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           stall : in STD_LOGIC;
           instr_in : in STD_LOGIC_VECTOR(16 DOWNTO 0);
           instr_out : out STD_LOGIC_VECTOR(16 DOWNTO 0)
         );
end pipe_reg_if_id;

architecture Behavioral of pipe_reg_if_id is

begin
    reg: entity work.pipe_reg
        GENERIC MAP (width => 16)
        PORT MAP (
            clk => clk,
            reset => reset,
            stall => stall,
            din => instr_in,
            dout => instr_out);
end Behavioral;