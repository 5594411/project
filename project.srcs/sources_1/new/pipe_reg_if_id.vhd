library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipe_reg_if_id is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           stall : in STD_LOGIC;
           instr_in : in STD_LOGIC_VECTOR(16 DOWNTO 0);
           pc_plus_one_in : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           instr_out : out STD_LOGIC_VECTOR(16 DOWNTO 0);
           pc_plus_one_out : out STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
end pipe_reg_if_id;

architecture Behavioral of pipe_reg_if_id is

begin
    reg: entity work.pipe_reg
        GENERIC MAP (width => 19)
        PORT MAP (
            clk => clk,
            reset => reset,
            stall => stall,
            din => instr & pc_plus_one,
            dout(19 downto 4) => instr_out,
            dout(3 downto 0) => pc_plus_one_out
        );
end Behavioral;