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
           pc_plus_one_in : in std_logic_vector(3 downto 0);
           pc_plus_one_out : out std_logic_vector(3 downto 0);
           read_data1_in : in std_logic_vector(15 downto 0);
           read_data1_out : out std_logic_vector(15 downto 0);
           read_data2_in : in std_logic_vector(15 downto 0);
           read_data2_out : out std_logic_vector(15 downto 0);
           sign_ext_imm_in : in std_logic_vector(15 downto 0);
           sign_ext_imm_out : out std_logic_vector(15 downto 0);
           rs_in : in std_logic_vector(3 downto 0);
           rs_out : out std_logic_vector(3 downto 0);
           rd_in : in std_logic_vector(3 downto 0);
           rd_out : out std_logic_vector(3 downto 0);
           ctrl_RegDst_in : in std_logic;
           ctrl_RegDst_out : out std_logic;
           ctrl_ALUSrc_in : in std_logic;
           ctrl_ALUSrc_out : out std_logic;
           ctrl_ALUOp_in : in std_logic;
           ctrl_ALUOp_out : out std_logic;
           ctrl_MemRead_in : in std_logic;
           ctrl_MemRead_out : out std_logic;
           ctrl_MemWrite_in : in std_logic;
           ctrl_MemWrite_out : out std_logic;
           ctrl_RegWrite_in : in std_logic;
           ctrl_RegWrite_out : out std_logic;
           ctrl_MemtoReg_in : in std_logic;
           ctrl_MemtoReg_out : out std_logic;
           ctrl_Branch_in : in std_logic;
           ctrl_Branch_out : out std_logic
       );
end pipe_reg_id_ex;

architecture Behavioral of pipe_reg_id_ex is

begin
 reg: entity work.pipe_reg
        GENERIC MAP (width => 60)
        PORT MAP (
          clk => clk,
          reset => reset,
          stall => stall,
          din => pc_plus_one_in & read_data1_in & read_data2_in & sign_ext_imm_in & ctrl_RegDst_in & ctrl_ALUSrc_in
          & ctrl_ALUOp_in & ctrl_MemRead_in & ctrl_MemWrite_in & ctrl_RegWrite_in & ctrl_MemtoReg_in & ctrl_Branch_in,
          dout(3 downto 0) => pc_plus_one_out,
          dout(3 downto 0) => read_data1_out,
          dout(3 downto 0) => read_data2_out,
          dout(3 downto 0) => sign_ext_imm_out,
          dout(16 downto 13) => rs_out,
          dout(11 downto 8) => rd_out,
          dout(7) => ctrl_RegDst_out,
          dout(6) => ctrl_ALUSrc_out,
          dout(5) => ctrl_ALUOp_out,
          dout(4) => ctrl_MemRead_out,
          dout(3) => ctrl_MemWrite_out,
          dout(2) => ctrl_RegWrite_out,
          dout(1) => ctrl_MemtoReg_out,
          dout(0) => ctrl_Branch_out,
        );

end Behavioral;
