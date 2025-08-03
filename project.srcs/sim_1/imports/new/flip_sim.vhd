library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flip_sim is
end flip_sim;

architecture Behavioral of flip_sim is
    signal clk : std_logic;
    signal tag_size :  std_logic_vector(3 downto 0);
    signal bf : std_logic_vector(1 downto 0);
    signal block_0 : std_logic_vector(7 downto 0);
    signal block_1 : std_logic_vector(7 downto 0);
    signal block_2 : std_logic_vector(7 downto 0);
    signal block_3 : std_logic_vector(7 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.flip_blocks
    port map( tag_size => tag_size,
              bf => bf,
              A0_in => block_0,
              A1_in => block_1,
              A2_in => block_2,
              A3_in => block_3);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        tag_size <= "1000";
        bf <= "00";
        block_0 <= "00001111";
        block_1 <= "00001111";
        block_2 <= "00001111";
        block_3 <= "00001111";
        wait for 25 ns;
        tag_size <= "1000";
        bf <= "01";
        block_0 <= "00001111";
        block_1 <= "00001111";
        block_2 <= "00001111";
        block_3 <= "00001111";
        wait for 25 ns;
        tag_size <= "1000";
        bf <= "10";
        block_0 <= "00001111";
        block_1 <= "00001111";
        block_2 <= "00001111";
        block_3 <= "00001111";
        wait for 25 ns;
        tag_size <= "1000";
        bf <= "11";
        block_0 <= "00001111";
        block_1 <= "00001111";
        block_2 <= "00001111";
        block_3 <= "00001111";
        wait for 25 ns;
        tag_size <= "0100";
        bf <= "00";
        block_0 <= "11001100";
        block_1 <= "11001100";
        block_2 <= "11001100";
        block_3 <= "11001100";
        wait for 25 ns;
        tag_size <= "0100";
        bf <= "01";
        block_0 <= "11001100";
        block_1 <= "11001100";
        block_2 <= "11001100";
        block_3 <= "11001100";
        wait for 25 ns;
        tag_size <= "0100";
        bf <= "10";
        block_0 <= "11001100";
        block_1 <= "11001100";
        block_2 <= "11001100";
        block_3 <= "11001100";
        wait for 25 ns;
        tag_size <= "0100";
        bf <= "11";
        block_0 <= "11001100";
        block_1 <= "11001100";
        block_2 <= "11001100";
        block_3 <= "11001100";
        wait for 25 ns;
        tag_size <= "0000";
        bf <= "00";
        block_0 <= "00000000";
        block_1 <= "00000000";
        block_2 <= "00000000";
        block_3 <= "00000000";
        wait;
    end process stimulus;
end Behavioral;
