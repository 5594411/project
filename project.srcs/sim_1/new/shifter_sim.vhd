library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter_sim is
--  Port ( );
end shifter_sim;

architecture Behavioral of shifter_sim is
    signal sig_block_a, sig_block_b, sig_block_c, sig_block_d : std_logic_vector(7 downto 0);
    signal sig_shift_a, sig_shift_b, sig_shift_c, sig_shift_d : std_logic_vector(7 downto 0);
    signal sig_shift_select, sig_r_in : std_logic_vector(1 downto 0);
    signal clk : std_logic;
    signal sig_block_size_in : std_logic_vector(3 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
        
    UUT : entity work.shifter
 port map(
              block_0 => sig_block_a,
              block_1 => sig_block_b,
              block_2 => sig_block_c,
              block_3 => sig_block_d,
              shift_select => sig_shift_select,
              block_size_in => sig_block_size_in,
              r_in => sig_r_in,
              shift_0 => sig_shift_a,
              shift_1 => sig_shift_b,
              shift_2 => sig_shift_c,
              shift_3 => sig_shift_d
           );

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;

    stimulus: process begin
        sig_block_a <= "00000000";
        sig_block_b <= "00000000";
        sig_block_c <= "00000000";
        sig_block_d <= "00000000";
        sig_shift_select <= "00";
        sig_block_size_in <= "0111";
        sig_r_in <= "01";
        
        wait for 25 ns; --tested
        sig_block_a <= "00101110"; --01100101
        sig_block_b <= "00000011";
        sig_block_c <= "10000000";
        sig_block_d <= "10000000";
        sig_shift_select <= "00";
        sig_block_size_in <= "0111";
        sig_r_in <= "10";
        
        wait for 25 ns; --tested
        sig_shift_select <= "01";
        sig_r_in <= "11";
        sig_block_size_in <= "0111";
        
        wait for 25 ns; --tested
        sig_block_size_in <= "1000";
        sig_shift_select <= "11";
        sig_r_in <= "01";
        
        wait for 25 ns; --tested
        sig_block_size_in <= "0001";
        sig_shift_select <= "10";
        
        wait;
    end process stimulus;
end Behavioral;
