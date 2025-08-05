----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.08.2025 00:05:41
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    port (
        opcode       : in  std_logic_vector(3 downto 0);
        reg_write    : out std_logic;
        push_en : out std_logic;
        key_en       : out std_logic;
        mem_read     : out std_logic
    );
end control_unit;

architecture behavioural of control_unit is

    constant OP_SET_SECRET_KEY  : std_logic_vector(3 downto 0) := "0001";
   -- constant OP_SET_TAG_SIZE    : std_logic_vector(3 downto 0) := "0001";
   -- constant OP_SET_RECORD_SIZE : std_logic_vector(3 downto 0) := "0010";
    constant OP_PUSH_REC_TAG    : std_logic_vector(3 downto 0) := "0011";
    constant OP_LOAD_CAND_TALLY : std_logic_vector(3 downto 0) := "0100";

begin
    reg_write <= '1' when opcode = OP_LOAD_CAND_TALLY else
                '0';
    mem_read <= '1' when opcode = OP_LOAD_CAND_TALLY else
                '0';
    key_en <= '1' when opcode = OP_SET_SECRET_KEY else
                '0';
    push_en <= '1' when opcode = OP_PUSH_REC_TAG else
                    '0';
end behavioural;