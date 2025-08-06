----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.08.2025 21:26:57
-- Design Name: 
-- Module Name: mux_4to1_8b - Behavioral
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

entity mux_4to1_8b is
    generic 
    (
        NUM_TALLY: integer := 8
    );
    port 
    (
        btnU     : in std_logic;
        btnR     : in std_logic;
        btnD     : in std_logic;
        btnL     : in std_logic;
        dataA    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataB    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataC    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        dataD    : in std_logic_vector(NUM_TALLY - 1 downto 0);
        data_out : out std_logic_vector(NUM_TALLY - 1 downto 0)
    );
end mux_4to1_8b;

architecture Behavioral of mux_4to1_8b is
begin

    process(btnU, btnR, btnD, btnL, dataA, dataB, dataC, dataD)
    begin
        if btnU = '1' then
            data_out <= dataA;
        elsif btnR = '1' then
            data_out <= dataB;
        elsif btnD = '1' then
            data_out <= dataC;
        elsif btnL = '1' then
            data_out <= dataD;
        else
            data_out <= (others => '0');
        end if;
    end process;

end Behavioral;
