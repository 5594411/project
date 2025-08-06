----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/08/01 19:07:54
-- Design Name: 
-- Module Name: program_core_testbench - Behavioral
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

entity program_core_testbench is
end program_core_testbench;

architecture Behavioral of program_core_testbench is
    constant NUM_CANDIDATE: integer := 2;
    constant NUM_DISTRICT: integer := 2;
    constant NUM_TALLY: integer := 8;
    constant TAG_SIZE: integer := 4;
    constant RECORD_SIZE: integer := 16;
    signal btnR, btnC : std_logic;
    signal clk : std_logic;
    signal sw : std_logic_vector(15 downto 0);
    signal led : std_logic_vector(15 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.project
    generic map(
        NUM_CANDIDATE => NUM_CANDIDATE,
--        save the last column as sum for specfic candidate
        NUM_DISTRICT => NUM_DISTRICT,
        NUM_TALLY => NUM_TALLY,
        TAG_SIZE => TAG_SIZE,
        RECORD_SIZE => RECORD_SIZE
    )
    port map( clk => clk,
              btnR => btnR,
              btnC => btnC,
              btnL => '1',
              btnU => '1',
              btnD => '1',
              sw => sw,
              led => led);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        btnR <= '1';
        btnC <= '1';
        sw <= "1010100100101011";
        wait for 50 ns;
        btnR <= '0';
        btnC <= '0';
        sw <= "1010100100101011";
        wait;
    end process stimulus;
end Behavioral;

