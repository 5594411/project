library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity swap_sim is
end swap_sim;

architecture Behavioral of swap_sim is
    signal sig_block_x, sig_block_y, sig_swaped_block_x, sig_swaped_block_y : std_logic_vector(7 downto 0);
    signal px, py, s : std_logic_vector(1 downto 0);
    signal tag_size : std_logic_vector(3 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.swap
    port map( block_x => sig_block_x,
              block_y => sig_block_y,
              px => px,
              py => py,
              s => s,
              tag_size => tag_size,
              bx_swapped => sig_swaped_block_x,
              by_swapped => sig_swaped_block_y);

    stimulus: process begin
        sig_block_x <= "00111100";
        sig_block_y <= "11000011";
        px <= "00";
        py <= "00";
        s <= "10";
        tag_size <= "1000";
        wait for 25 ns;
        sig_block_x <= "00110000";
        sig_block_y <= "11001100";
        px <= "00";
        py <= "10";
        s <= "01";
        tag_size <= "1000";
        wait for 25 ns;
        sig_block_x <= "00110000";
        sig_block_y <= "11001100";
        px <= "10";
        py <= "10";
        s <= "11";
        tag_size <= "1000";
        wait for 25 ns;
        sig_block_x <= "00110000";
        sig_block_y <= "11001100";
        px <= "00";
        py <= "10";
        s <= "00";
        tag_size <= "1000";
        wait for 25 ns;
        sig_block_x <= "00001100";
        sig_block_y <= "00000011";
        px <= "01";
        py <= "11";
        s <= "10";
        tag_size <= "0100";
        wait for 25 ns;
        sig_block_x <= "00111100";
        sig_block_y <= "00000011";
        px <= "11";
        py <= "11";
        s <= "11";
        tag_size <= "0100";
        wait for 25 ns;
        sig_block_x <= "00000000";
        sig_block_y <= "00000000";
        px <= "00";
        py <= "00";
        s <= "00";
        tag_size <= "0000";
        wait;
    end process stimulus;
end Behavioral;
