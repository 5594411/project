library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity block_part_sim is

end block_part_sim;

architecture Behavioral of block_part_sim is
    signal clk : std_logic;
    signal tag_sz :  std_logic_vector(3 downto 0);
    signal record_sz : std_logic_vector(5 downto 0);
    signal record_in :  std_logic_vector(31 downto 0);
    signal block_0 : std_logic_vector(7 downto 0);
    signal block_1 : std_logic_vector(7 downto 0);
    signal block_2 : std_logic_vector(7 downto 0);
    signal block_3 : std_logic_vector(7 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.block_partitioner
    port map( clk => clk,
              tag_sz => tag_sz,
              record_sz => record_sz,
              record_in => record_in,
              block_0 => block_0,
              block_1 => block_1,
              block_2 => block_2,
              block_3 => block_3);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        tag_sz <= "1000";
        record_sz <= "100000";
        record_in <= "00001111000011110000111100001111";
        wait for 50 ns;
        tag_sz <= "1000";
        record_sz <= "100000";
        record_in <= "01001011010100110011001100110011";
        wait for 50 ns;
        tag_sz <= "0100";
        record_sz <= "010000";
        record_in <= "00001111111100000011111111111100";
        wait for 50 ns;
        tag_sz <= "0010";
        record_sz <= "001000";
        record_in <= "11001100110011000011111100111100";
        wait for 50 ns;
        tag_sz <= "1000";
        record_sz <= "100000";
        record_in <= "11111111111111111111111111111111";
        wait;
    end process stimulus;
end Behavioral;
