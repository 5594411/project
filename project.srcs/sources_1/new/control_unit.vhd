----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/07/30 21:47:17
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
    generic (
        TAG_SIZE: integer := 8
    );
    port ( cal_tag     : in  std_logic_vector(TAG_SIZE - 1 downto 0);
           rec_tag     : in  std_logic_vector(TAG_SIZE - 1 downto 0);
           mem_read  : out std_logic);
end control_unit;

architecture behavioural of control_unit is

begin

    mem_read <= '1' when cal_tag = rec_tag else '0';

end behavioural;
