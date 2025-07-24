----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2025 00:18:40
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port (
        clk      : in  std_logic;  -- 100 MHz clock
        btn_in   : in  std_logic;  -- raw button input
        btn_out  : out std_logic   -- debounced output
    );
end debounce;

architecture Behavioral of debounce is
    constant DEBOUNCE_TIME : integer := 2_000_000; -- 20 ms at 100 MHz
    signal counter         : integer range 0 to DEBOUNCE_TIME := 0;
    signal btn_sync_0      : std_logic := '0';
    signal btn_sync_1      : std_logic := '0';
    signal btn_state       : std_logic := '0';
begin

    -- Double flip-flop synchronizer
    process(clk)
    begin
        if rising_edge(clk) then
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end if;
    end process;

    -- Debounce logic
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_sync_1 /= btn_state then
                counter <= counter + 1;
                if counter = DEBOUNCE_TIME then
                    btn_state <= btn_sync_1;
                    counter <= 0;
                end if;
            else
                counter <= 0;
            end if;
        end if;
    end process;

    btn_out <= btn_state;

end Behavioral;
