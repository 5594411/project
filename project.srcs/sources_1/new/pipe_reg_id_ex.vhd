----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 30.03.2021 23:27:54
-- Design Name:
-- Module Name: PipelineReg_ID_EX - Behavioral
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

entity pipe_reg_id_ex is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           stall : in STD_LOGIC;
           data_in : in std_logic_vector(31 downto 0);
           data_out : out std_logic_vector(31 downto 0);
           ctrl_MemWrite_in : in std_logic;
           ctrl_MemWrite_out : out std_logic;
           ctrl_RegWrite_in : in std_logic;
           ctrl_RegWrite_out : out std_logic;
           ctrl_Branch_in : in std_logic;
           ctrl_Branch_out : out std_logic
       );
end pipe_reg_id_ex;

architecture Behavioral of pipe_reg_id_ex is

begin
 reg: entity work.pipe_reg
        GENERIC MAP (width => 35)
        PORT MAP (
          clk => clk,
          reset => reset,
          stall => stall,
          din => ctrl_MemWrite_in & ctrl_RegWrite_in & ctrl_Branch_in & data_in,
          dout(34) => ctrl_MemWrite_out,
          dout(33) => ctrl_RegWrite_out,
          dout(32) => ctrl_Branch_out,
          dout(31 downto 0) => data_out
        );

end Behavioral;
