library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_sim is
--  Port ( );
end shift_sim;

architecture Behavioral of shift_sim is
    component shifter is
    port (
        block_a, block_b        : in std_logic_vector(7 downto 0);
        shift_select            : in std_logic_vector(1 downto 0);
        block_c, block_d        : in  std_logic_vector(7 downto 0); --s_b
        block_size_in, r_in     : in std_logic_vector(3 downto 0);
        shift_a, shift_b, shift_c, shift_d : out std_logic_vector(7 downto 0)
    );
end component;

    signal sig_block_a, sig_block_b, sig_block_c, sig_block_d : std_logic_vector(7 downto 0);
    signal sig_shift_a, sig_shift_b, sig_shift_c, sig_shift_d : std_logic_vector(7 downto 0);
    signal sig_shift_select : std_logic_vector(1 downto 0);
    signal clk, enable : std_logic;
    signal sig_block_size_in, sig_r_in : std_logic_vector(3 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : shifter
 port map(
              block_a => sig_block_a,
              block_b => sig_block_b,
              block_c => sig_block_c,
              block_d => sig_block_d,
              shift_select => sig_shift_select,
              block_size_in => sig_block_size_in,
              r_in => sig_r_in,
              shift_a => sig_shift_a,
              shift_b => sig_shift_b,
              shift_c => sig_shift_c,
              shift_d => sig_shift_d
           );

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;

    stimulus: process begin
        sig_block_a <= "00101110";
        sig_block_b <= "10000000";
        sig_block_c <= "10000000";
        sig_block_d <= "10000000";
        sig_shift_select <= "00";
        sig_block_size_in <= "0111";
        sig_r_in <= "0100";
        wait for 20 ns;
            --enable <= '0';
        sig_block_a <= "00101110";
        sig_block_b <= "10000000";
        sig_block_c <= "10000000";
        sig_block_d <= "10000000";
        sig_shift_select <= "00";
        sig_block_size_in <= "0111";
        sig_r_in <= "0100";
        wait;
    end process stimulus;
end Behavioral;
