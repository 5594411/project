----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2025 08:37:38 PM
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
    generic ( NUM_TALLY: integer := 8 )
    port ( an : in std_logic_vector(3 downto 0);
           data : in std_logic_vector(NUM_TALLY - 1 downto 0));
end display;

architecture Behavioral of display is

begin
        u_b2bcd : entity work.binarytobcd
        generic map(
        BIN_WIDTH => 8,
        DIGITS    => 3
        )
        port map(
            bin_in  => read_sum,
        bcd_out => bcd_digits
        );

        -- assign the three BCD nibbles plus blank leading digit
        d3 <= "0000";                            -- blank thousands
        d2 <= bcd_digits(11 downto 8);           -- hundreds
        d1 <= bcd_digits(7  downto 4);           -- tens
        d0 <= bcd_digits(3  downto 0);           -- units
        
    with clk_div(19 downto 18) select
    current_nibble <= d0 when "00",       -- show units on AN0
                       d1 when "01",       -- show tens on AN1
                       d2 when "10",       -- show hundreds on AN2
                       d3 when others;     -- show blank/zero on AN3

  -- instantiate your seven-segment BCD→seg decoder
  u_sevseg : entity work.sev_seg_dec
    port map(
      nbl => current_nibble,
      hex => seg
    );

  ----------------------------------------------------------------------------
  -- DRIVE DIGIT ENABLES (active LOW on Basys3)
  an(0) <= not (clk_div(19) or clk_div(18));  -- digit 0
  an(1) <= not (clk_div(19) or not clk_div(18));
  an(2) <= not (not clk_div(19) or clk_div(18));
  an(3) <= not (not clk_div(19) or not clk_div(18));

  -- always turn decimal point off
  dp <= '1';
end Behavioral;
