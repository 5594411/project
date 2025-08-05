library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_sim is

end xor_sim;

architecture Behavioral of xor_sim is
    signal block_0 : std_logic_vector(7 downto 0);
    signal block_1 : std_logic_vector(7 downto 0);
    signal block_2 : std_logic_vector(7 downto 0);
    signal block_3 : std_logic_vector(7 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.xor_mod
    port map( block_0 => block_0,
              block_1 => block_1,
              block_2 => block_2,
              block_3 => block_3);

    clck: process begin
        loop
            wait for (ClockPeriod / 2);
        end loop;
    end process clck;
    
    stimulus: process begin
        block_0 <= "00001111";
        block_1 <= "11110000";
        block_2 <= "00000000";
        block_3 <= "00011000";
        wait for 25 ns;
        block_0 <= "00000000";
        block_1 <= "00000000";
        block_2 <= "11111111";
        block_3 <= "00000000";
        wait for 25 ns;
        block_0 <= "11111111";
        block_1 <= "11111111";
        block_2 <= "00000000";
        block_3 <= "11111111";
        wait for 25 ns;
        block_0 <= "11000000";
        block_1 <= "00110000";
        block_2 <= "00001100";
        block_3 <= "00000011";
        wait for 25 ns;
        block_0 <= "00000000";
        block_1 <= "00000000";
        block_2 <= "00000000";
        block_3 <= "00000000";
        wait;
    end process stimulus;
end Behavioral;
